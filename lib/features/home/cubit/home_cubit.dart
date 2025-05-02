import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/features/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  final List<String> tags = ['الكل', 'سيارات معثور عليها', 'سيارات مفقودة'];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  void getHomeData({int tagIndex = 0}) async {
    try {
      emit(HomeState.loading());

      Query query = firestore.collection('posts');

      if (tagIndex == 1) {
        query = query.where('stolen', isEqualTo: false);
      } else if (tagIndex == 2) {
        query = query.where('stolen', isEqualTo: true);
      }

      QuerySnapshot snapshot = await query.get();

      List<PostCar> carList =
          snapshot.docs.map((doc) {
            return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

      emit(HomeState.success(carInformation: carList));
    } catch (e) {
      emit(HomeState.error(error: e.toString()));
    }
  }

  void startSearch() {
    emit(state.copyWith(isSearching: true));
  }

  void stopSearch() {
    emit(state.copyWith(isSearching: false, searchResults: []));
  }

  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(searchResults: []));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final QuerySnapshot postsSnapshot = await firestore.collection('posts').get();
      final List<QueryDocumentSnapshot> filteredDocs = _filterDocuments(postsSnapshot.docs, query.toLowerCase());

      emit(state.copyWith(searchResults: filteredDocs, isLoading: false));
    } catch (e) {
      print('حدث خطأ أثناء البحث: $e');
      emit(state.copyWith(isLoading: false));
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

  // التحقق إذا كان المستخدم قد سجل إعجابه بالسيارة
  Future<bool> checkIfCarLiked(String? carId) async {
    if (carId == null) return false;

    // التحقق من تسجيل دخول المستخدم
    final userId = getCurrentUserId();
    if (userId == null) {
      return false; // لا نبعث بحدث هنا، فقط نُرجع false
    }

    try {
      emit(state.copyWith(isLikeLoading: true));

      final docSnapshot = await firestore.collection('users').doc(userId).collection('liked_cars').doc(carId).get();

      final isLiked = docSnapshot.exists;
      emit(state.copyWith(isLikeLoading: false));
      return isLiked;
    } catch (e) {
      print('Error checking like status: $e');
      emit(state.copyWith(isLikeLoading: false, error: e.toString()));
      return false;
    }
  }

  // تبديل حالة الإعجاب للسيارة
  Future<bool> toggleLike(PostCar car) async {
    if (car.id == null) return false;

    // التحقق من تسجيل دخول المستخدم
    final userId = getCurrentUserId();
    if (userId == null) {
      return false;
    }

    try {
      final isCurrentlyLiked = await checkIfCarLiked(car.id);

      emit(state.copyWith(isLikeLoading: true));

      final userLikesRef = firestore.collection('users').doc(userId).collection('liked_cars');

      if (isCurrentlyLiked) {
        await userLikesRef.doc(car.id).delete();
      } else {
        await userLikesRef.doc(car.id).set(car.toMap());
      }

      final carRef = firestore.collection('cars').doc(car.id);
      await firestore.runTransaction((transaction) async {
        final carDoc = await transaction.get(carRef);
        if (carDoc.exists) {
          int currentLikes = carDoc.data()?['likesCount'] ?? 0;
          transaction.update(carRef, {'likesCount': isCurrentlyLiked ? currentLikes - 1 : currentLikes + 1});
        }
      });

      // تحديث الحالة لتعكس حالة الإعجاب الجديدة
      emit(state.copyWith(isLikeLoading: false));
      return true; // نجحت العملية
    } catch (e) {
      print('Error toggling like: $e');
      emit(state.copyWith(isLikeLoading: false, error: e.toString()));
      return false;
    }
  }
}
