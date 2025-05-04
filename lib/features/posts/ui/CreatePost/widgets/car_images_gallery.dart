// إنشاء كلاس منفصل لعرض الصور
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:image_picker/image_picker.dart';

class CarImagesGallery extends StatelessWidget {
  final PostsCubit postsCubit;
  final int maxImages;

  const CarImagesGallery({super.key, required this.postsCubit, this.maxImages = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('صور السيارة', style: TextStyles.font16BlacMedium),
            Text(
              '${postsCubit.carImages.length}/$maxImages',
              style: TextStyle(
                color: postsCubit.carImages.length >= maxImages ? Colors.red : ColorsManager.kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        verticalSpace(12),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(postsCubit.carImages.length, (index) => _buildImageItem(context, index)),
              // إظهار زر الإضافة فقط إذا كان عدد الصور أقل من الحد الأقصى
              if (postsCubit.carImages.length < maxImages) _buildAddImageButton(context),
            ],
          ),
        ),
      ],
    );
  }

  // عنصر عرض الصورة
  Widget _buildImageItem(BuildContext context, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(left: 10, bottom: 10),
      child: Stack(
        children: [
          // عرض الصورة
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorsManager.kPrimaryColor.withOpacity(0.3)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: 'car_image_$index',
                child: GestureDetector(
                  onTap: () => _showFullScreenImage(context, index),
                  child: Image.file(postsCubit.carImages[index], fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          // زر حذف الصورة
          Positioned(
            top: -5,
            right: -5,
            child: GestureDetector(
              onTap: () {
                _showDeleteConfirmation(context, index);
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 1))],
                ),
                child: Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
          // عرض رقم الصورة
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ColorsManager.kPrimaryColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // زر إضافة صورة جديدة
  Widget _buildAddImageButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceOptions(context),
      child: Container(
        width: 90,
        height: 90,
        margin: EdgeInsets.only(left: 10, bottom: 10),
        decoration: BoxDecoration(
          color: ColorsManager.lighterGray,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ColorsManager.kPrimaryColor.withOpacity(0.3),
            width: 1.5,
            // style: BorderStyle.dashed,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, color: ColorsManager.kPrimaryColor, size: 32),
              SizedBox(height: 4),
              Text(
                'إضافة صورة',
                style: TextStyle(color: ColorsManager.kPrimaryColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // عرض خيارات اختيار الصورة (كاميرا أو معرض)
  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext bc) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('اختر مصدر الصورة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      context,
                      icon: Icons.camera_alt,
                      title: 'الكاميرا',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(context, ImageSource.camera);
                      },
                    ),
                    _buildImageSourceOption(
                      context,
                      icon: Icons.photo_library,
                      title: 'المعرض',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(context, ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // خيار مصدر الصورة
  Widget _buildImageSourceOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: ColorsManager.kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: ColorsManager.kPrimaryColor, size: 30),
          ),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // دالة لاختيار صورة
  void _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80, // تقليل حجم الصورة
      );

      if (image != null) {
        postsCubit.addCarImage(File(image.path));
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء اختيار الصورة'), backgroundColor: Colors.red));
    }
  }

  // عرض تأكيد حذف الصورة
  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('حذف الصورة'),
            content: Text('هل أنت متأكد من حذف هذه الصورة؟'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  postsCubit.removeCarImage(index);
                },
                child: Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

  // عرض الصورة في وضع ملء الشاشة
  void _showFullScreenImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                title: Text('صورة ${index + 1}', style: TextStyle(color: Colors.white)),
                actions: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(context, index);
                    },
                  ),
                ],
              ),
              body: Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4,
                  child: Hero(
                    tag: 'car_image_$index',
                    child: Image.file(postsCubit.carImages[index], fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}








// class CarImagesGallery extends StatelessWidget {
//   final PostsCubit postsCubit;

//   const CarImagesGallery({super.key, required this.postsCubit});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('صور السيارة', style: TextStyles.font16BlacMedium),
//         verticalSpace(12),
//         SizedBox(
//           height: 110,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               ...List.generate(postsCubit.carImages.length, (index) => _buildImageItem(context, index)),
//               _buildAddImageButton(context),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // عنصر عرض الصورة
//   Widget _buildImageItem(BuildContext context, int index) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       margin: EdgeInsets.only(left: 10, bottom: 10),
//       child: Stack(
//         children: [
//           // عرض الصورة
//           Container(
//             width: 90,
//             height: 90,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: ColorsManager.kPrimaryColor.withOpacity(0.3)),
//               boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2))],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Hero(tag: 'car_image_$index', child: Image.file(postsCubit.carImages[index], fit: BoxFit.cover)),
//             ),
//           ),
//           // زر حذف الصورة
//           Positioned(
//             top: -5,
//             right: -5,
//             child: GestureDetector(
//               onTap: () {
//                 postsCubit.removeCarImage(index);
//               },
//               child: Container(
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade600,
//                   shape: BoxShape.circle,
//                   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 1))],
//                 ),
//                 child: Icon(Icons.close, color: Colors.white, size: 14),
//               ),
//             ),
//           ),
//           // عرض رقم الصورة
//           Positioned(
//             bottom: 0,
//             left: 0,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                 color: ColorsManager.kPrimaryColor,
//                 borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
//               ),
//               child: Text(
//                 '${index + 1}',
//                 style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // زر إضافة صورة جديدة
//   Widget _buildAddImageButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _pickImage(context),
//       child: Container(
//         width: 90,
//         height: 90,
//         margin: EdgeInsets.only(left: 10, bottom: 10),
//         decoration: BoxDecoration(
//           color: ColorsManager.lighterGray,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: ColorsManager.kPrimaryColor.withOpacity(0.3), width: 1.5),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.add_photo_alternate_outlined, color: ColorsManager.kPrimaryColor, size: 32),
//               SizedBox(height: 4),
//               Text(
//                 'إضافة صورة',
//                 style: TextStyle(color: ColorsManager.kPrimaryColor, fontSize: 10, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // دالة لاختيار صورة من المعرض
//   void _pickImage(BuildContext context) async {
//     try {
//       final ImagePicker picker = ImagePicker();

//       final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

//       if (image != null) {
//         postsCubit.addCarImage(File(image.path));
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }
// }
