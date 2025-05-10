
import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler {
  final PostsCubit postsCubit;

  ImagePickerHandler({required this.postsCubit});

  Future<void> pickFirstImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // تحسين جودة الصورة
      );

      if (image != null) {
        // postsCubit.setFirstCarImage(File(image.path));
      }
    } catch (e) {
      print('خطأ في التقاط الصورة الأولى: $e');
    }
  }

  Future<void> pickSecondImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (image != null) {
        // postsCubit.setSecondCarImage(File(image.path));
      }
    } catch (e) {
      print('خطأ في التقاط الصورة الثانية: $e');
    }
  }

  Future<void> takeFirstImageWithCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

      if (image != null) {
        // postsCubit.setFirstCarImage(File(image.path));
      }
    } catch (e) {
      print('خطأ في التقاط الصورة بالكاميرا: $e');
    }
  }

  Future<void> takeSecondImageWithCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);

      if (image != null) {
        // postsCubit.setSecondCarImage(File(image.path));
      }
    } catch (e) {
      print('خطأ في التقاط الصورة بالكاميرا: $e');
    }
  }

  // عرض خيارات التقاط الصورة (معرض أو كاميرا)
  void showImageSourceOptions(BuildContext context, {required bool isFirstImage}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: ColorsManager.kPrimaryColor),
                title: Text('اختيار من المعرض'),
                onTap: () {
                  Navigator.of(context).pop();
                  isFirstImage ? pickFirstImage() : pickSecondImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: ColorsManager.kPrimaryColor),
                title: Text('التقاط صورة'),
                onTap: () {
                  Navigator.of(context).pop();
                  isFirstImage ? takeFirstImageWithCamera() : takeSecondImageWithCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
