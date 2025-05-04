import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final List<String> tags = ["صغيره", "كبيره", "بيكأب", "باص"];
  final List<String> tagImages = ['img/sedan.png', 'img/crossover.png', 'img/pickup.png', 'img/bus.png'];
  String selectedTagName = "صغيره"; // إضافة متغير لحفظ اسم التاج المختار
  int selectedTag = 0;

  void updateSelectedTag(int index) {
    selectedTag = index;
    selectedTagName = tags[index]; 
    print(selectedTagName);
    emit(TagUpdated());
  }

  final formKey = GlobalKey<FormState>();
  final LocationService _locationService = LocationService();

  // car information
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController chassisNumberController = TextEditingController();

  // car owner information
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController streetController = TextEditingController();

  // car owner information
  final TextEditingController nameOnerCarController = TextEditingController();
  final TextEditingController phoneOnerCarController = TextEditingController();
  final TextEditingController phoneOnerCarController2 = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool whats = true;
  bool whats2 = true;

  // إضافة طريقة للتحقق من اكتمال البيانات في الصفحة المحددة
  bool validatePage(int pageIndex) {
    switch (pageIndex) {
      case 1: // التحقق من صفحة معلومات السيارة
        return carNameController.text.isNotEmpty &&
            carTypeController.text.isNotEmpty &&
            carColorController.text.isNotEmpty &&
            carModelController.text.isNotEmpty &&
            plateNumberController.text.isNotEmpty &&
            chassisNumberController.text.isNotEmpty &&
            firstCarImage != null; // التأكد من وجود صورة للسيارة

      case 2: // التحقق من صفحة موقع السيارة
        return cityController.text.isNotEmpty &&
            neighborhoodController.text.isNotEmpty &&
            streetController.text.isNotEmpty;

      case 3: // التحقق من صفحة معلومات المالك
        return nameOnerCarController.text.isNotEmpty &&
            phoneOnerCarController.text.isNotEmpty &&
            (phoneOnerCarController.text.length >= 9); // تحقق من طول رقم الهاتف

      default:
        return true;
    }
  }

  // التحقق من جميع الصفحات
  bool validateAllPages() {
    // التحقق من كل صفحة على حدة
    bool page1Valid = validatePage(1);
    bool page2Valid = validatePage(2);
    bool page3Valid = validatePage(3);

    // إرجاع النتيجة مع رسالة توضح أي صفحة بها مشكلة
    if (!page1Valid) {
      emit(PageValidationError("الرجاء إكمال جميع بيانات السيارة في الصفحة الأولى"));
      return false;
    }

    if (!page2Valid) {
      emit(PageValidationError("الرجاء إكمال جميع بيانات الموقع في الصفحة الثانية"));
      return false;
    }

    if (!page3Valid) {
      emit(PageValidationError("الرجاء إكمال جميع بيانات المالك في الصفحة الثالثة"));
      return false;
    }

    return true;
  }

  Future<void> addPostCar(PostCar postCar) async {
    try {
      emit(PostsLoading());
      await FirebaseFirestore.instance.collection('posts').doc(postCar.id).set(postCar.toMap()).then((value) {
        FirebaseFirestore.instance.collection('posts').doc(postCar.id).update({'id': postCar.id});
      });
      emit(PostsSendSuccess());
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  String? firstCarImageUrl;
  String? secondCarImageUrl;
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  Future<String?> uploadImageToStorage(File imageFile, String path) async {
    try {
      if (!path.startsWith("cars/")) {
        throw FirebaseException(plugin: "firebase_storage", code: "invalid-path", message: "مسار التخزين غير صحيح.");
      }

      final storageRef = FirebaseStorage.instance.ref().child(path);
      final uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (e) {
      print("🔥 Firebase Storage Error: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("❌ Unknown Error: $e");
      return null;
    }
  }

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
