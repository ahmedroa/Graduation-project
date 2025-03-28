import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graduation/core/data/models/Car_information.dart';

part 'reported_cars_state.dart';
part 'reported_cars_cubit.freezed.dart';

class ReportedCarsCubit extends Cubit<ReportedCarsState> {
  ReportedCarsCubit() : super(ReportedCarsState.initial());
  String uid = 'test';
  final firestore = FirebaseFirestore.instance;

  void getReportedCars() async {
    try {
      emit(ReportedCarsState.loading());
      QuerySnapshot snapshot = await firestore.collection('users').doc(uid).collection('posts').get();
      List<PostCar> posts =
          snapshot.docs.map((doc) {
            final data = doc.data();
            if (data != null && data is Map<String, dynamic>) {
              return PostCar.fromJson(data);
            } else {
              throw Exception("Invalid document format");
            }
          }).toList();

      emit(ReportedCarsState.success(carInformation: posts));
    } catch (e) {
      emit(ReportedCarsState.error(e.toString()));
    }
  }

  void deleteReportedCar(String postId) async {
    try {
      emit(ReportedCarsState.loading());
      await firestore.collection('users').doc(uid).collection('posts').doc(postId).delete();
      emit(ReportedCarsState.success(carInformation: []));
    } catch (e) {
      // FirebaseFailure failure = FirebaseErrorHandler.handleError(e);
      emit(ReportedCarsState.error(e.toString()));
    }
  }

  void editReportedCar(String postId, PostCar postCar) async {
    try {
      emit(ReportedCarsState.loading());
      await firestore.collection('users').doc(uid).collection('posts').doc(postId).update(postCar.toJson());
      emit(ReportedCarsState.success(carInformation: []));
    } catch (e) {
      // FirebaseFailure failure = FirebaseErrorHandler.handleError(e);
      emit(ReportedCarsState.error(e.toString()));
    }
  }
}
