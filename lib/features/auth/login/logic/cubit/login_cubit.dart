import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation/features/auth/login/logic/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void login({required String email, required String password}) async {
    emit(LoginState.loading());
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseMessaging.instance.subscribeToTopic('users');
      emit(LoginState.success('User logged in successfully'));
    } on FirebaseAuthException catch (e) {
      emit(LoginState.error(error: e.message ?? 'An error occurred'));
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
