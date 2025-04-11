import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/features/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  final List<String> tags = ['الكل', "السيارات اللتي تم العثور عليها", "السيارات المبلغ عنها"];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
}








