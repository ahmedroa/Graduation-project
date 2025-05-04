import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String uid = FirebaseAuth.instance.currentUser!.uid;

  int selectedOption = 1;
  final List<String> tags = ["صغيره", "كبيره", "بيكأب", "باص"];
  final List<String> tagImages = ['img/sedan.png', 'img/crossover.png', 'img/pickup.png', 'img/bus.png'];
  String selectedTagName = "صغيره";
  int selectedTag = 0;

  void updateSelectedTag(int index) {
    selectedTag = index;
    selectedTagName = tags[index];
    print(selectedTagName);
    emit(TagUpdated());
  }

  List<File> carImages = [];

  void addCarImage(File image) {
    carImages.add(image);
    emit(CarImagesUpdated());
  }

  void removeCarImage(int index) {
    if (index >= 0 && index < carImages.length) {
      carImages.removeAt(index);
      emit(CarImagesUpdated());
    }
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

  bool validatePage(int pageIndex) {
    switch (pageIndex) {
      case 1:
        return carNameController.text.isNotEmpty &&
            carTypeController.text.isNotEmpty &&
            carColorController.text.isNotEmpty &&
            carModelController.text.isNotEmpty &&
            plateNumberController.text.isNotEmpty &&
            chassisNumberController.text.isNotEmpty &&
            firstCarImage != null;

      case 2:
        return cityController.text.isNotEmpty &&
            neighborhoodController.text.isNotEmpty &&
            streetController.text.isNotEmpty;

      case 3:
        return nameOnerCarController.text.isNotEmpty &&
            phoneOnerCarController.text.isNotEmpty &&
            (phoneOnerCarController.text.length >= 9);

      default:
        return true;
    }
  }

  Future<void> addPostCar(PostCar postCar) async {
    try {
      emit(PostsLoading());

      List<String> imageUrls = [];

      if (carImages.isNotEmpty) {
        for (int i = 0; i < carImages.length; i++) {
          try {
            final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
            final path = 'car_images/$uid/$fileName';
            final ref = FirebaseStorage.instance.ref().child(path);
            final uploadTask = ref.putFile(carImages[i]);

            await uploadTask;

            final url = await ref.getDownloadURL();
            imageUrls.add(url);
            print('تم رفع الصورة $i بنجاح: $url');
          } catch (e) {
            print('خطأ في رفع الصورة $i: $e');
            emit(PostsError('حدث خطأ أثناء رفع الصور، حاول مرة أخرى'));
            return;
          }
        }
      }

      if (imageUrls.isNotEmpty) {
        postCar = postCar.copyWith(image: imageUrls.first, images: imageUrls);
      }

      firestore.collection('posts').add(postCar.toMap()).then((va) {
        va.update({'id': va.id});
        firestore.collection('users').doc(uid).collection('posts').doc(va.id).set({...postCar.toMap(), 'id': va.id});
      });

      emit(PostsSendSuccess());
    } catch (e) {
      print('خطأ عام: $e');
      emit(PostsError(e.toString()));
    }
  }

  Future<void> getLocation() async {
    emit(PostsLoading());

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

  final List<String> carModels = List.generate(2025 - 1990 + 1, (index) => (2025 - index).toString());

  File? firstCarImage;

  void selectOption(int option) {
    selectedOption = option;
    emit(PostsSelectedOption());
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




  // Future<String?> uploadImageoStorage(File imageFile, String path) async {
  //   try {
  //     // التحقق من وجود الملف
  //     if (!await imageFile.exists()) {
  //       print("خطأ: الملف غير موجود في المسار: ${imageFile.path}");
  //       return null;
  //     }

  //     // التحقق من حجم الملف
  //     int fileSize = await imageFile.length();
  //     if (fileSize <= 0) {
  //       print("خطأ: الملف فارغ أو حجمه صفر");
  //       return null;
  //     }

  //     print("جاري رفع الملف: $path (الحجم: ${(fileSize / 1024).toStringAsFixed(2)} كيلوبايت)");

  //     // إنشاء مرجع للتخزين
  //     final storageRef = FirebaseStorage.instance.ref().child(path);

  //     // إعداد البيانات الوصفية
  //     final metadata = SettableMetadata(
  //       contentType: 'image/jpeg',
  //       customMetadata: {'picked-file-path': imageFile.path},
  //     );

  //     // بدء الرفع مع خيارات إضافية
  //     final uploadTask = storageRef.putFile(imageFile, metadata);

  //     // متابعة تقدم الرفع
  //     uploadTask.snapshotEvents.listen(
  //       (TaskSnapshot snapshot) {
  //         double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
  //         print('تقدم رفع الصورة: ${progress.toStringAsFixed(1)}%');
  //       },
  //       onError: (e) {
  //         print("خطأ أثناء متابعة تقدم الرفع: $e");
  //       },
  //     );

  //     // انتظار الانتهاء
  //     final snapshot = await uploadTask.whenComplete(() => print('اكتمل رفع الصورة بنجاح'));

  //     // الحصول على الرابط
  //     final imageUrl = await snapshot.ref.getDownloadURL();
  //     print("تم الحصول على رابط الصورة: $imageUrl");
  //     return imageUrl;
  //   } on FirebaseException catch (e) {
  //     print("خطأ Firebase في رفع الصورة: ${e.code} - ${e.message}");
  //     return null;
  //   } catch (e) {
  //     print("خطأ عام في رفع الصورة: $e");
  //     return null;
  //   }
  // }












// Future<void> addPostCar(PostCar postCar) async {
  //   try {
  //     emit(PostsLoading());

  //     // التحقق من وجود صور للرفع
  //     if (carImages.isEmpty) {
  //       emit(PostsError("الرجاء إضافة صورة واحدة على الأقل للسيارة"));
  //       return;
  //     }

  //     print("=== بدء عملية إضافة بيانات السيارة ===");
  //     print("عدد الصور للرفع: ${carImages.length}");

  //     // رفع الصور واحدة تلو الأخرى
  //     List<String> imageUrls = [];
  //     for (int i = 0; i < carImages.length; i++) {
  //       print("جاري رفع الصورة ${i + 1} من ${carImages.length}");

  //       // إنشاء اسم فريد للصورة باستخدام UUID
  //       String uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}_$i";
  //       String storagePath = 'car_images/$uid/$uniqueFileName.jpg';

  //       try {
  //         String? url = await uploadImageToStorage(carImages[i], storagePath);

  //         if (url != null && url.isNotEmpty) {
  //           imageUrls.add(url);
  //           print("تم رفع الصورة ${i + 1} بنجاح");
  //         } else {
  //           print("فشل في رفع الصورة ${i + 1}: لم يتم الحصول على رابط صالح");
  //           emit(PostsError("فشل في رفع الصورة ${i + 1}. الرجاء المحاولة مرة أخرى."));
  //           return;
  //         }
  //       } catch (uploadError) {
  //         print("استثناء أثناء رفع الصورة ${i + 1}: $uploadError");
  //         emit(PostsError("خطأ في رفع الصورة ${i + 1}: $uploadError"));
  //         return;
  //       }
  //     }

  //     // التحقق من رفع جميع الصور بنجاح
  //     if (imageUrls.isEmpty) {
  //       print("لم يتم رفع أي صورة بنجاح");
  //       emit(PostsError("لم يتم رفع أي صورة بنجاح. تحقق من اتصالك بالإنترنت."));
  //       return;
  //     }

  //     print("تم رفع جميع الصور بنجاح (${imageUrls.length} من أصل ${carImages.length})");
  //     print("جاري حفظ البيانات في Firestore...");

  //     // تحديث البيانات مع روابط الصور
  //     Map<String, dynamic> updatedPostData = postCar.toMap();
  //     updatedPostData['image'] = imageUrls.first; // الصورة الرئيسية
  //     updatedPostData['images'] = imageUrls; // قائمة الصور
  //     updatedPostData['timestamp'] = FieldValue.serverTimestamp(); // وقت الإنشاء
  //     updatedPostData['userId'] = uid; // معرف المستخدم

  //     try {
  //       // حفظ في مجموعة المنشورات العامة
  //       DocumentReference docRef = await firestore.collection('posts').add(updatedPostData);
  //       String postId = docRef.id;
  //       print("تم إنشاء منشور جديد بمعرف: $postId");

  //       // تحديث المستند بالمعرف
  //       await docRef.update({'id': postId});
  //       print("تم تحديث المنشور بالمعرف");

  //       // حفظ نسخة في مجموعة المستخدم
  //       await firestore.collection('users').doc(uid).collection('posts').doc(postId).set({
  //         ...updatedPostData,
  //         'id': postId,
  //       });
  //       print("تم حفظ نسخة من المنشور في مجموعة المستخدم");

  //       print("=== اكتملت عملية إضافة بيانات السيارة بنجاح ===");
  //       emit(PostsSendSuccess());
  //     } catch (firestoreError) {
  //       print("خطأ في حفظ البيانات في Firestore: $firestoreError");
  //       emit(PostsError("تم رفع الصور بنجاح ولكن حدث خطأ في حفظ البيانات: $firestoreError"));
  //     }
  //   } catch (e) {
  //     print("خطأ عام في عملية إضافة بيانات السيارة: $e");
  //     emit(PostsError("حدث خطأ غير متوقع: $e"));
  //   }
  // }

  // Future<void> addPostCar(PostCar postCar) async {
  //   try {
  //     emit(PostsLoading());

  //     // رفع الصور أولاً
  //     List<String> imageUrls = [];
  //     if (carImages.isNotEmpty) {
  //       // عرض حالة رفع الصور
  //       emit(UploadingImages(0));

  //       // رفع كل صورة على حدة
  //       for (int i = 0; i < carImages.length; i++) {
  //         // حساب نسبة التقدم
  //         int progress = ((i / carImages.length) * 100).round();
  //         emit(UploadingImages(progress));

  //         // رفع الصورة
  //         String uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}_$i";
  //         String? url = await uploadImageToStorage(carImages[i], 'car_images/$uid/$uniqueFileName.jpg');

  //         imageUrls.add(url!);
  //       }

  //       // إذا كان هناك مشكلة في رفع الصور
  //       if (imageUrls.isEmpty) {
  //         emit(PostsError("فشل في رفع الصور، حاول مرة أخرى"));
  //         return;
  //       }
  //     }

  //     // إنشاء نسخة من بيانات السيارة مع تحديث روابط الصور
  //     Map<String, dynamic> updatedPostData = postCar.toMap();

  //     // إضافة روابط الصور إذا تم رفعها بنجاح
  //     if (imageUrls.isNotEmpty) {
  //       updatedPostData['image'] = imageUrls.first; // الصورة الرئيسية
  //       updatedPostData['images'] = imageUrls; // قائمة الصور
  //     }

  //     // حفظ البيانات في Firestore (نفس الطريقة الأصلية)
  //     firestore.collection('posts').add(updatedPostData).then((va) {
  //       firestore.collection('users').doc(uid).collection('posts').doc(va.id).set(updatedPostData);
  //     });

  //     emit(PostsSendSuccess());
  //   } catch (e) {
  //     emit(PostsError(e.toString()));
  //   }
  // }
  // Future<void> addPostCar(PostCar postCar) async {
  //   try {
  //     emit(PostsLoading());
  //     firestore.collection('posts').add(postCar.toMap()).then((va) {
  //       firestore.collection('users').doc(uid).collection('posts').doc(va.id).set(postCar.toMap());
  //     });
  //     emit(PostsSendSuccess());
  //   } catch (e) {
  //     emit(PostsError(e.toString()));
  //   }
  // }


// التحقق من جميع الصفحات
  // bool validffffffdateAllPages() {
  //   // التحقق من كل صفحة على حدة
  //   bool page1Valid = validatePage(1);
  //   bool page2Valid = validatePage(2);
  //   bool page3Valid = validatePage(3);

  //   // إرجاع النتيجة مع رسالة توضح أي صفحة بها مشكلة
  //   if (!page1Valid) {
  //     emit(PageValidationError("الرجاء إكمال جميع بيانات السيارة في الصفحة الأولى"));
  //     return false;
  //   }

  //   if (!page2Valid) {
  //     emit(PageValidationError("الرجاء إكمال جميع بيانات الموقع في الصفحة الثانية"));
  //     return false;
  //   }

  //   if (!page3Valid) {
  //     emit(PageValidationError("الرجاء إكمال جميع بيانات المالك في الصفحة الثالثة"));
  //     return false;
  //   }

  //   return true;
  // }


    // @override
  // Future<void> close() {
  //   neighborhoodController.dispose();
  //   cityController.dispose();
  //   streetController.dispose();
  //   return super.close();
  // }

  // Future<void> greateReport() async {
  //   emit(PostsLoading());
  //   try {
  //     // firestore.collection('posts').add();
  //   } catch (e) {
  //     emit(PostsError(e.toString()));
  //   }
  // }
  // File? secondCarImage;