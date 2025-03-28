import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/network/firebase_error_handler.dart';
import 'package:graduation/features/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getHomeData() async {
    try {
      emit(HomeState.loading());

      QuerySnapshot snapshot = await firestore.collection('posts').get();
      List<PostCar> posts =
          snapshot.docs.map((doc) {
            final data = doc.data();
            if (data != null && data is Map<String, dynamic>) {
              return PostCar.fromJson(data);
            } else {
              throw Exception("Invalid document format");
            }
          }).toList();

      emit(HomeState.success(carInformation: posts));
    } catch (e) {

      emit(HomeState.error(error: e.toString()));
    }
  }
}
