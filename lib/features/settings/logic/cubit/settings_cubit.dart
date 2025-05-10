import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.dart';
part 'settings_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.initial());

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getDataUser() async {
    emit(SettingsState.loading());
    try {
      await firestore.collection('users').doc(auth.currentUser!.uid).get();
      emit(SettingsState.success());
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  void logout() async {
    emit(SettingsState.loggingOut());
    try {
      await auth.signOut();
      emit(SettingsState.logoutSuccess());
    } catch (e) {
      emit(SettingsState.logoutFailure(e.toString()));
    }
  }

  void deleteAccount() async {
    emit(SettingsState.loading());
    try {
      final String userId = auth.currentUser!.uid;

      await firestore.collection('users').doc(userId).delete();

      await auth.currentUser!.delete();

      emit(SettingsState.deleteAccountSuccess());
    } catch (e) {
      emit(SettingsState.deleteAccountFailure(e.toString()));
    }
  }
}
// class SettingsCubit extends Cubit<SettingsState> {
//   SettingsCubit() : super(SettingsState.initial());

//   FirebaseAuth auth = FirebaseAuth.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   void getDataUser() {
//     emit(SettingsState.loading());
//     try {
//       firestore.collection('users').doc(auth.currentUser!.uid).get().then((value) {
//         emit(SettingsState.success());
//       });
//       emit(SettingsState.success());
//     } catch (e) {
//       emit(SettingsState.error(e.toString()));
//     }
//   }

//   void logout() {
//     emit(SettingsState.loggingOut());
//     try {
//       auth.signOut();
//       emit(SettingsState.logoutSuccess());
//     } catch (e) {
//       emit(SettingsState.logoutFailure(e.toString()));
//     }
//   }

//   void deleteAccount() {
//     emit(SettingsState.loading());
//     try {
//       auth.currentUser!.delete();
//       firestore.collection('users').doc(auth.currentUser!.uid).delete();
//       emit(SettingsState.deleteAccountSuccess());
//     } catch (e) {
//       emit(SettingsState.deleteAccountFailure(e.toString()));
//     }
//   }
// }
