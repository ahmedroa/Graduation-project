import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/features/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getHomeData() async {
    try {
      emit(HomeState.loading());
      QuerySnapshot snapshot = await firestore.collection('posts').get();
      List<PostCar> carList =
          snapshot.docs.map((doc) {
            return PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
      emit(HomeState.success(carInformation: carList));
    } catch (e) {
      emit(HomeState.error(error: e.toString()));
    }
  }
}
