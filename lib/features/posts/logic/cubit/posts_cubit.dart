import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/location_service.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int selectedOption = 1;

  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController chassisNumberController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController cityLocationController = TextEditingController();
  final LocationService _locationService = LocationService();

  Future<void> getLocation() async {
    emit(LocationLoading());

    try {
      final locationData = await _locationService.getCurrentLocation();
      neighborhoodController.text = locationData['neighborhood']!;
      cityController.text = locationData['city']!;
      streetController.text = locationData['street']!;
      emit(LocationFetched());
    } catch (e) {
      print("خطأ في جلب الموقع: $e");
      emit(LocationError("حدث خطأ أثناء جلب الموقع"));
    }
  }

  @override
  Future<void> close() {
    neighborhoodController.dispose();
    cityController.dispose();
    streetController.dispose();
    return super.close();
  }

  Future<void> greateReport() async {
    emit(PostsLoading());
    try {
      // firestore.collection('posts').add();
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  final List<String> carModels = List.generate(2025 - 1990 + 1, (index) => (2025 - index).toString());

  File? firstCarImage;
  File? secondCarImage;

  void selectOption(int option) {
    selectedOption = option;
    emit(PostsSelectedOption());
  }

  void setFirstCarImage(File image) {
    firstCarImage = image;
    emit(CarImagesUpdated());
  }

  void setSecondCarImage(File image) {
    secondCarImage = image;
    emit(CarImagesUpdated());
  }

  List<String> sudanCities = [
    "الخرطوم",
    " الخرطوم - أم درمان",
    "الخرطوم - بحري",
    "بورتسودان",
    "ود مدني",
    "كسلا",
    "الأبيض",
    "القضارف",
    "عطبرة",
    "سنار",
    "كادوقلي",
    "الدمازين",
    "دنقلا",
    "نيالا",
    "الفاشر",
    "زالنجي",
    "كوستي",
    "ربك",
    "وادي حلفا",
    "حلفا الجديدة",
    "سواكن",
    "الدامر",
    "الرهد",
    "الجنينة",
  ];

  final List<String> carTypes = [
    "أستون مارتن",
    "ألفا روميو",
    "إنفينيتي",
    "أودي",
    "بي إم دبليو",
    "بيجو",
    "بورش",
    "بوجاتي",
    "بوغاتي",
    "بويك",
    "تاتا",
    "تسلا",
    "تويوتا",
    "جي إم سي",
    "جيلي",
    "جاكوار",
    "جينيسيس",
    "دايهاتسو",
    "دودج",
    "دي إس",
    "دونغفينغ",
    "رام",
    "رينو",
    "سيتروين",
    "سوبارو",
    "سوزوكي",
    "شيري",
    "شيفروليه",
    "شانجان",
    "فاو",
    "فورد",
    "فيراري",
    "فولفو",
    "فولكس فاجن",
    "كاديلاك",
    "كيا",
    "كوينيجسيج",
    "لاند روفر",
    "لكزس",
    "لامبورغيني",
    "لينكولن",
    "لوتس",
    "مازدا",
    "مازيراتي",
    "ماهيندرا",
    "مايباخ",
    "ميتسوبيشي",
    "ميني",
    "مرسيدس",
    "نيسان",
    "هافال",
    "هوندا",
    "هيونداي",
  ];

  final List<String> carColors = [
    "أبيض",
    "أسود",
    "فضي",
    "رمادي",
    "أزرق",
    "أحمر",
    "أخضر",
    "ذهبي",
    "برتقالي",
    "بني",
    "أرجواني",
    "زهري",
  ];
}
