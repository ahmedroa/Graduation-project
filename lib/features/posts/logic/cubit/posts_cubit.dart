import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/location_service.dart';
import 'package:graduation/features/posts/logic/cubit/list.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  int selectedOption = 1;

  final List<String> tags = CarData.tags;
  final List<String> tagImages = CarData.tagImages;
  String selectedTagName = CarData.tags[0];
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

  // Future<void> getLocation() async {
  //   emit(PostsLoading());

  //   try {
  //     final locationData = await _locationService.getCurrentLocation();
  //     neighborhoodController.text = locationData['neighborhood']!;
  //     cityController.text = locationData['city']!;
  //     streetController.text = locationData['street']!;
  //     emit(LocationFetched());
  //   } catch (e) {
  //     print("خطأ في جلب الموقع: $e");
  //     emit(LocationError("حدث خطأ أثناء جلب الموقع"));
  //   }
  // }
  // في PostsCubit:
  Future<void> getLocation(BuildContext context) async {
    emit(PostsLoadingLoctation());
    try {
      final locationData = await _locationService.getCurrentLocation(context);
      neighborhoodController.text = locationData['neighborhood']!;
      cityController.text = locationData['city']!;
      streetController.text = locationData['street']!;
      emit(LocationFetched());
    } catch (e) {
      print("خطأ في جلب الموقع: $e");
      emit(LocationError("حدث خطأ أثناء جلب الموقع"));
    }
  }

  final List<String> carModels = CarData.generateCarModels();

  File? firstCarImage;

  void selectOption(int option) {
    selectedOption = option;
    emit(PostsSelectedOption());
  }

  List<String> get sudanCities => CarData.sudanCities;
  List<String> get carTypes => CarData.carTypes;
  List<String> get carColors => CarData.carColors;
}
