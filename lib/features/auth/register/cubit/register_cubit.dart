import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.dart';
part 'register_cubit.freezed.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState.initial());

  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void register({required String email, required String password, required String name, required String phone}) async {
    emit(RegisterState.loading());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
          await FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
            'name': name,
            'email': email,
            'password': password,
            'phone': phone,
            'uid': value.user!.uid,
          });
          print('User Added');
          emit(RegisterState.success());
        })
        .catchError((onError) {
          print(onError);
          emit(RegisterState.error(error: onError.toString()));
        });
  }
}
