import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/features/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  final List<String> tags = ['الكل', 'سيارات معثور عليها', 'سيارات مفقودة'];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _currentTagIndex = 0;

  static const int _pageSize = 20;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;


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
      query = firestore.collection('posts').orderBy('timestamp', descending: true);
    } else {
      bool stolenValue = tagIndex == 2;
      query = firestore.collection('posts').where('stolen', isEqualTo: stolenValue);
      // .orderBy('timestamp', descending: true);
    }

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
