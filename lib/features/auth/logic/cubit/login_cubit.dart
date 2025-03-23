import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation/features/auth/logic/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void register({required String email, required String password}) async {
    try {
      emit(LoginState.loading());

      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then({} as FutureOr Function(UserCredential value))
          .catchError((e) {});
      emit(LoginState.success('User created successfully'));
    } catch (e) {
      emit(LoginState.error(error: e.toString()));
    }
  }

  void login({required String email, required String password}) async {
    try {
      emit(LoginState.loading());

      auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      emit(LoginState.error(error: e.toString()));
    }
  }

  resetPassword({required String email}) {
    try {
      emit(LoginState.loading());
      auth.sendPasswordResetEmail(email: email);
      emit(LoginState.success('Reset password email sent'));
    } catch (e) {
      emit(LoginState.error(error: e.toString()));
    }
  }

  void signOut() {
    auth.signOut();
  }
}
