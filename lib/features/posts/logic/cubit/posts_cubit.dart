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
  String auth = 'test';
  int selectedOption = 1;

  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController chassisNumberController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
    final LocationService _locationService = LocationService();

  Future<void> getLocation() async {
        emit(LocationLoading()); // 🔄 بدء التحميل

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

  final List<String> carModels = List.generate(2025 - 1990 + 1, (index) => (2025 - index).toString());

  File? firstCarImage;
  File? secondCarImage;

  void selectOption(int option) {
    selectedOption = option;
    emit(PostsSelectedOption());
  }

  // Car image handling methods
  void setFirstCarImage(File image) {
    firstCarImage = image;
    emit(CarImagesUpdated());
  }

  void setSecondCarImage(File image) {
    secondCarImage = image;
    emit(CarImagesUpdated());
  }

  // Method to clear all car information
  // void clearCarInfo() {
  //   carNameController.clear();
  //   carTypeController.clear();
  //   carColorController.clear();
  //   carModelController.clear();
  //   chassisNumberController.clear();
  //   plateNumberController.clear();
  //   firstCarImage = null;
  //   secondCarImage = null;
  //   emit(CarInfoCleared());
  // }

  // Method to validate car information
  bool validateCarInfo() {
    if (carNameController.text.isEmpty ||
        carTypeController.text.isEmpty ||
        carColorController.text.isEmpty ||
        carModelController.text.isEmpty) {
      emit(PostsError('يرجى إدخال جميع المعلومات المطلوبة'));
      return false;
    }

    if (firstCarImage == null) {
      emit(PostsError('يرجى إضافة صورة السيارة'));
      return false;
    }

    return true;
  }

  // Modified createPost method to include car information
  Future<void> createPost({
    String? name,
    String? description,
    String? carTheftHistory,
    String? location,
    String? phone,
    String? phone2,
    String? tokinNotification,
    String? locationName,
    String? nameFound,
    bool what1 = false,
    bool what2 = false,
    bool isFound = false,
    bool isLocation = false,
  }) async {
    emit(PostsLoading());

    // Validate car information first
    if (!validateCarInfo()) {
      return;
    }

    try {
      String userId = 'test';

      // Upload images to storage first (assuming you have a method for this)
      List<String> imageUrls = await uploadCarImages();

      PostCar post = PostCar(
        id: '',
        name: name ?? carNameController.text,
        description: description ?? '',
        year: int.tryParse(carModelController.text) ?? DateTime.now().year,
        carTheftHistory: carTheftHistory ?? '',
        // carType: carTypeController.text,
        // carColor: carColorController.text,
        // chassisNumber: chassisNumberController.text,
        // plateNumber: plateNumberController.text,
        image: imageUrls.isNotEmpty ? imageUrls[0] : '',
        // secondImage: imageUrls.length > 1 ? imageUrls[1] : '',
        location: location ?? '',
        isLocation: isLocation,
        locationName: locationName ?? '',
        nameFound: nameFound ?? '',
        phone: phone ?? '',
        phone2: phone2 ?? '',
        what1: what1,
        what2: what2,
        isFound: isFound,
        tokinNotification: tokinNotification ?? '',
        userId: userId,
        createdAt: FieldValue.serverTimestamp(),
      );

      DocumentReference postRef = await firestore.collection('posts').add(post.toJson());
      await postRef.update({'id': postRef.id});
      post.id = postRef.id;

      await firestore.collection('users').doc(userId).collection('posts').doc(postRef.id).set(post.toJson());

      // Clear form after successful submission
      // clearCarInfo();
      emit(PostsCreated(post));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  // Method to upload car images to Firebase Storage
  Future<List<String>> uploadCarImages() async {
    List<String> imageUrls = [];

    try {
      if (firstCarImage != null) {
        // final ref = FirebaseStorage.instance.ref().child('car_images/${DateTime.now().millisecondsSinceEpoch}_1.jpg');
        // await ref.putFile(firstCarImage!);
        // String url = await ref.getDownloadURL();
        // imageUrls.add(url);
      }

      if (secondCarImage != null) {
        // final ref = FirebaseStorage.instance.ref().child('car_images/${DateTime.now().millisecondsSinceEpoch}_2.jpg');
        // await ref.putFile(secondCarImage!);
        // String url = await ref.getDownloadURL();
        // imageUrls.add(url);
      }
    } catch (e) {
      emit(PostsError('فشل في رفع الصور: ${e.toString()}'));
    }

    return imageUrls;
  }
}
