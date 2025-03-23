import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial()) {
    // تهيئة المصفوفات
    carTypes = ['سيدان', 'SUV', 'رياضية', 'شاحنة'];
    carColors = ['أبيض', 'أسود', 'أحمر', 'أزرق', 'فضي'];
    carModels = List.generate(30, (index) => '${2024 - index}');
  }

  // القوائم المستخدمة في الاختيارات
  List<String> carTypes = [];
  List<String> carColors = [];
  List<String> carModels = [];

  // متغير لتتبع الخطوة الحالية
  int selectedOption = 1;

  // متغيرات لتخزين الصور
  File? firstCarImage;
  File? secondCarImage;

  // Controllers لحقول النص
  final carNameController = TextEditingController();
  final carTypeController = TextEditingController();
  final carColorController = TextEditingController();
  final carModelController = TextEditingController();
  final chassisNumberController = TextEditingController();
  final plateNumberController = TextEditingController();

  // دالة لتحديث الخطوة الحالية
  void selectOption(int option) {
    selectedOption = option;
    emit(PostsOptionSelected(option));
  }

  // دوال لتحديث الصور
  void setFirstCarImage(File image) {
    firstCarImage = image;
    emit(PostsImageUpdated());
  }

  void setSecondCarImage(File image) {
    secondCarImage = image;
    emit(PostsImageUpdated());
  }

  // دالة للتحقق من صحة البيانات
  bool validateCarInfo() {
    return carNameController.text.isNotEmpty &&
        carTypeController.text.isNotEmpty &&
        carColorController.text.isNotEmpty &&
        carModelController.text.isNotEmpty;
  }

  @override
  Future<void> close() {
    // تنظيف الـ controllers عند إغلاق الـ cubit
    carNameController.dispose();
    carTypeController.dispose();
    carColorController.dispose();
    carModelController.dispose();
    chassisNumberController.dispose();
    plateNumberController.dispose();
    return super.close();
  }
}
