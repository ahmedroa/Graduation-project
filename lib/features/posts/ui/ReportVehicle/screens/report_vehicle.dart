// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
// import 'package:graduation/core/theme/text_styles.dart';
// import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';
// import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:image_picker/image_picker.dart';

class ReportVehicle extends StatefulWidget {
  const ReportVehicle({super.key});

  @override
  _ReportVehicleState createState() => _ReportVehicleState();
}

class _ReportVehicleState extends State<ReportVehicle> {
  File? _firstCarImage;
  File? _secondCarImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildImageContainer(_firstCarImage, true, 'الصورة الأولى')),
            horizontalSpace(12),
            Expanded(child: _buildImageContainer(_secondCarImage, false, 'الصورة الثانية')),
          ],
        ),
        verticalSpace(20),

        verticalSpace(20),
        Align(alignment: Alignment.topLeft, child: MainButton(text: 'نشر', onTap: () {}, width: 120.w)),
        verticalSpace(20),
      ],
    );
  }

  Widget _buildImageContainer(File? image, bool isFirstImage, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _pickImage(isFirstImage),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(color: ColorsManager.lighterGray, borderRadius: BorderRadius.circular(10)),
            child:
                image != null
                    ? Stack(
                      children: [
                        Positioned.fill(child: Image.file(image, fit: BoxFit.cover)),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () => _removeImage(isFirstImage),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 15,
                              child: Icon(Icons.close, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700]),
          ),
        ),
        verticalSpace(12),
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<void> _pickImage(bool isFirstImage) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await showModalBottomSheet<XFile>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('التقاط صورة'),
                onTap: () async {
                  Navigator.pop(context, await picker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('اختيار من المعرض'),
                onTap: () async {
                  Navigator.pop(context, await picker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        if (isFirstImage) {
          _firstCarImage = File(pickedFile.path);
        } else {
          _secondCarImage = File(pickedFile.path);
        }
      });
    }
  }

  void _removeImage(bool isFirstImage) {
    setState(() {
      if (isFirstImage) {
        _firstCarImage = null;
      } else {
        _secondCarImage = null;
      }
    });
  }

  // Widget _buildLocationFields() {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Text('تحديد الموقع الحالي', style: TextStyles.font14DarkMedium),
  //           Spacer(),
  //           MainButton(
  //             text: 'تحديد الموقع الحالي',
  //             onTap: () => context.read<PostsCubit>().getLocation(),
  //             height: 35,
  //             width: 145,
  //             color: ColorsManager.dark,
  //             icon: Icon(Icons.location_on, color: Colors.white),
  //           ),
  //         ],
  //       ),
  //       verticalSpace(12),
  //       AppTextFormField(
  //         hintText: 'الحي',
  //         validator: (value) {
  //           if (value!.isEmpty) {
  //             return 'الحي مطلوب';
  //           }
  //           return null;
  //         },
  //         controller: context.read<PostsCubit>().neighborhoodController,
  //       ),
  //       verticalSpace(12),
  //       AppTextFormField(
  //         hintText: 'المدينه',
  //         validator: (value) {
  //           if (value!.isEmpty) {
  //             return 'المدينه مطلوب';
  //           }
  //           return null;
  //         },
  //         controller: context.read<PostsCubit>().cityController,
  //       ),
  //       verticalSpace(12),
  //       AppTextFormField(
  //         hintText: 'الشارع',
  //         validator: (value) {
  //           if (value!.isEmpty) {
  //             return 'الشارع مطلوب';
  //           }
  //           return null;
  //         },
  //         controller: context.read<PostsCubit>().streetController,
  //       ),
  //     ],
  //   );
  // }
}
