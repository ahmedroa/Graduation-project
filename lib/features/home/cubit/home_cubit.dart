import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/features/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  final List<String> tags = ['الكل', 'سيارات معثور عليها', 'سيارات مفقودة'];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _currentTagIndex = 0;

  // Pagination variables
  static const int _pageSize = 20;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  void getHomeData({int tagIndex = 0, bool isRefresh = false}) async {
    try {
      _currentTagIndex = tagIndex;

      // Reset pagination when refreshing or changing tag
      if (isRefresh || tagIndex != _currentTagIndex) {
        _lastDocument = null;
        _hasMoreData = true;
        _isLoadingMore = false;
      }

      if (state.isSearching) {
        emit(state.copyWith(isSearching: false, searchResults: [], isLoading: true));
      } else {
        emit(HomeState.loading());
      }

      List<PostCar> carList = await _fetchPosts(tagIndex, isInitialLoad: true);

      if (_currentTagIndex == tagIndex) {
        emit(HomeState.success(carInformation: carList, hasMoreData: _hasMoreData, isLoadingMore: false));
      }
    } catch (e) {
      if (_currentTagIndex == tagIndex) {
        emit(HomeState.error(error: e.toString()));
      }
    }
  }

  Future<void> loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData || state.isSearching || state.isLoading) return;

    try {
      _isLoadingMore = true;
      emit(state.copyWith(isLoadingMore: true));

      // Add small delay to show loading indicator
      await Future.delayed(Duration(milliseconds: 300));

      List<PostCar> newCarList = await _fetchPosts(_currentTagIndex, isInitialLoad: false);

      if (newCarList.isNotEmpty) {
        List<PostCar> updatedList = [...state.carInformation, ...newCarList];
        emit(state.copyWith(carInformation: updatedList, hasMoreData: _hasMoreData, isLoadingMore: false));
      } else {
        _hasMoreData = false;
        emit(state.copyWith(isLoadingMore: false, hasMoreData: false));
      }
    } catch (e) {
      print('خطأ في تحميل المزيد من البيانات: $e');
      emit(state.copyWith(isLoadingMore: false, error: e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<List<PostCar>> _fetchPosts(int tagIndex, {required bool isInitialLoad}) async {
    Query query;

    if (tagIndex == 0) {
      // All posts
      query = firestore.collection('posts').orderBy('timestamp', descending: true);
    } else {
      // Filtered posts
      bool stolenValue = tagIndex == 2;
      query = firestore.collection('posts').where('stolen', isEqualTo: stolenValue);
      // .orderBy('timestamp', descending: true);
    }

    // Add pagination
    if (!isInitialLoad && _lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    query = query.limit(_pageSize);

    QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
      _hasMoreData = snapshot.docs.length == _pageSize;
    } else {
      _hasMoreData = false;
    }

    return snapshot.docs.map((doc) {
      return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  void startSearch() {
    emit(state.copyWith(isSearching: true, searchResults: [], isLoading: false));
  }

  void stopSearch() {
    emit(state.copyWith(isSearching: false, searchResults: [], isLoading: false));
  }

  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(searchResults: [], isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final QuerySnapshot postsSnapshot = await firestore.collection('posts').get();
      final List<QueryDocumentSnapshot> filteredDocs = _filterDocuments(postsSnapshot.docs, query.toLowerCase());
      if (state.isSearching) {
        emit(state.copyWith(searchResults: filteredDocs, isLoading: false));
      }
    } catch (e) {
      print('حدث خطأ أثناء البحث: $e');
      if (state.isSearching) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    }
  }

  List<QueryDocumentSnapshot> _filterDocuments(List<QueryDocumentSnapshot> allCars, String query) {
    return allCars.where((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return (data['name']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['typeCar']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['model']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['plateNumber']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['city']?.toString().toLowerCase() ?? '').contains(query) ||
          (data['neighborhood']?.toString().toLowerCase() ?? '').contains(query);
    }).toList();
  }

  void refreshData() {
    getHomeData(tagIndex: _currentTagIndex, isRefresh: true);
  }
}
// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeState.initial());

//   final List<String> tags = ['الكل', 'سيارات معثور عليها', 'سيارات مفقودة'];
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   int _currentTagIndex = 0;

//   String? getCurrentUserId() {
//     return FirebaseAuth.instance.currentUser?.uid;
//   }

//   void getHomeData({int tagIndex = 0}) async {
//     try {
//       _currentTagIndex = tagIndex;

//       if (state.isSearching) {
//         emit(state.copyWith(isSearching: false, searchResults: [], isLoading: true));
//       } else {
//         emit(state.copyWith(isLoading: true, error: null));
//       }

//       List<PostCar> carList = [];

//       if (tagIndex == 0) {
//         QuerySnapshot snapshot = await firestore.collection('posts').orderBy('timestamp', descending: true).get();
//         carList =
//             snapshot.docs.map((doc) {
//               return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//             }).toList();
//       } else {
//         bool stolenValue = tagIndex == 2;
//         QuerySnapshot snapshot =
//             await firestore
//                 .collection('posts')
//                 .where('stolen', isEqualTo: stolenValue)
//                 .orderBy('timestamp', descending: true)
//                 .get();

//         List<PostCar> tempList =
//             snapshot.docs.map((doc) {
//               return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//             }).toList();

//         tempList.sort((a, b) {
//           if (a.timestamp == null && b.timestamp == null) return 0;
//           if (a.timestamp == null) return 1;
//           if (b.timestamp == null) return -1;
//           return b.timestamp!.compareTo(a.timestamp!);
//         });

//         carList = tempList;
//       }

//       if (_currentTagIndex == tagIndex) {
//         emit(HomeState.success(carInformation: carList));
//       }
//     } catch (e) {
//       if (_currentTagIndex == tagIndex) {
//         emit(HomeState.error(error: e.toString()));
//       }
//     }
//   }

//   void startSearch() {
//     emit(state.copyWith(isSearching: true, searchResults: [], isLoading: false));
//   }

//   void stopSearch() {
//     emit(state.copyWith(isSearching: false, searchResults: [], isLoading: false));
//   }

//   Future<void> performSearch(String query) async {
//     if (query.isEmpty) {
//       emit(state.copyWith(searchResults: [], isLoading: false));
//       return;
//     }

//     emit(state.copyWith(isLoading: true));

//     try {
//       final QuerySnapshot postsSnapshot = await firestore.collection('posts').get();
//       final List<QueryDocumentSnapshot> filteredDocs = _filterDocuments(postsSnapshot.docs, query.toLowerCase());
//       if (state.isSearching) {
//         emit(state.copyWith(searchResults: filteredDocs, isLoading: false));
//       }
//     } catch (e) {
//       print('حدث خطأ أثناء البحث: $e');
//       if (state.isSearching) {
//         emit(state.copyWith(isLoading: false, error: e.toString()));
//       }
//     }
//   }

//   List<QueryDocumentSnapshot> _filterDocuments(List<QueryDocumentSnapshot> allCars, String query) {
//     return allCars.where((doc) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       return (data['name']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['typeCar']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['model']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['plateNumber']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['city']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['neighborhood']?.toString().toLowerCase() ?? '').contains(query);
//     }).toList();
//   }
// }





  // void getHomeDadtaAlternative({int tagIndex = 0}) async {
  //   try {
  //     _currentTagIndex = tagIndex;

  //     if (state.isSearching) {
  //       emit(state.copyWith(isSearching: false, searchResults: [], isLoading: true));
  //     } else {
  //       emit(state.copyWith(isLoading: true, error: null));
  //     }

  //     // جلب كل البيانات مرتبة حسب التاريخ
  //     QuerySnapshot snapshot = await firestore.collection('posts').orderBy('timestamp', descending: true).get();

  //     List<PostCar> allCars =
  //         snapshot.docs.map((doc) {
  //           return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  //         }).toList();
  //     List<PostCar> filteredCars;
  //     if (tagIndex == 0) {
  //       filteredCars = allCars;
  //     } else if (tagIndex == 1) {
  //       filteredCars = allCars.where((car) => car.stolen == false).toList();
  //     } else {
  //       filteredCars = allCars.where((car) => car.stolen == true).toList();
  //     }
  //     if (_currentTagIndex == tagIndex) {
  //       emit(HomeState.success(carInformation: filteredCars));
  //     }
  //   } catch (e) {
  //     if (_currentTagIndex == tagIndex) {
  //       emit(HomeState.error(error: e.toString()));
  //     }
  //   }
  // }


  // Future<bool> checkIfCarLiked(String? carId) async {
  //   if (carId == null) return false;

  //   final userId = getCurrentUserId();
  //   if (userId == null) {
  //     return false;
  //   }

  //   try {
  //     emit(state.copyWith(isLikeLoading: true));

  //     final docSnapshot = await firestore.collection('users').doc(userId).collection('liked_cars').doc(carId).get();

  //     final isLiked = docSnapshot.exists;
  //     emit(state.copyWith(isLikeLoading: false));
  //     return isLiked;
  //   } catch (e) {
  //     print('Error checking like status: $e');
  //     emit(state.copyWith(isLikeLoading: false, error: e.toString()));
  //     return false;
  //   }
  // }


// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeState.initial());

//   final List<String> tags = ['الكل', 'سيارات معثور عليها', 'سيارات مفقودة'];
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   String? getCurrentUserId() {
//     return FirebaseAuth.instance.currentUser?.uid;
//   }

//   void getHomeData({int tagIndex = 0}) async {
//     try {
//       emit(HomeState.loading());

//       Query query = firestore.collection('posts').orderBy('timestamp', descending: true);

//       if (tagIndex == 1) {
//         query = query.where('stolen', isEqualTo: false);
//       } else if (tagIndex == 2) {
//         query = query.where('stolen', isEqualTo: true);
//       }

//       QuerySnapshot snapshot = await query.get();

//       List<PostCar> carList =
//           snapshot.docs.map((doc) {
//             return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//           }).toList();

//       emit(HomeState.success(carInformation: carList));
//     } catch (e) {
//       emit(HomeState.error(error: e.toString()));
//     }
//   }

//   void startSearch() {
//     emit(state.copyWith(isSearching: true));
//   }

//   void stopSearch() {
//     emit(state.copyWith(isSearching: false, searchResults: []));
//   }

//   Future<void> performSearch(String query) async {
//     if (query.isEmpty) {
//       emit(state.copyWith(searchResults: []));
//       return;
//     }

//     emit(state.copyWith(isLoading: true));

//     try {
//       final QuerySnapshot postsSnapshot = await firestore.collection('posts').get();
//       final List<QueryDocumentSnapshot> filteredDocs = _filterDocuments(postsSnapshot.docs, query.toLowerCase());

//       emit(state.copyWith(searchResults: filteredDocs, isLoading: false));
//     } catch (e) {
//       print('حدث خطأ أثناء البحث: $e');
//       emit(state.copyWith(isLoading: false));
//     }
//   }

//   List<QueryDocumentSnapshot> _filterDocuments(List<QueryDocumentSnapshot> allCars, String query) {
//     return allCars.where((doc) {
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       return (data['name']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['typeCar']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['model']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['plateNumber']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['city']?.toString().toLowerCase() ?? '').contains(query) ||
//           (data['neighborhood']?.toString().toLowerCase() ?? '').contains(query);
//     }).toList();
//   }

//   Future<bool> checkIfCarLiked(String? carId) async {
//     if (carId == null) return false;

//     final userId = getCurrentUserId();
//     if (userId == null) {
//       return false;
//     }

//     try {
//       emit(state.copyWith(isLikeLoading: true));

//       final docSnapshot = await firestore.collection('users').doc(userId).collection('liked_cars').doc(carId).get();

//       final isLiked = docSnapshot.exists;
//       emit(state.copyWith(isLikeLoading: false));
//       return isLiked;
//     } catch (e) {
//       print('Error checking like status: $e');
//       emit(state.copyWith(isLikeLoading: false, error: e.toString()));
//       return false;
//     }
//   }
// }
