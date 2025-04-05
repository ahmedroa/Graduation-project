// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
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
    final postsCubit = context.read<PostsCubit>();
    void showCarTypeSelectionSheet() {
      showModalBottomSheet(
        backgroundColor: ColorsManager.lighterGray,
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Container(
            color: Colors.white,
            height: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("اختر نوع السيارة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: postsCubit.carTypes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(postsCubit.carTypes[index]),
                        leading: Icon(Icons.directions_car),
                        onTap: () {
                          postsCubit.carTypeController.text = postsCubit.carTypes[index];
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    void showSelectionSheet(List<String> items, TextEditingController controller, String title) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index]),
                        onTap: () {
                          controller.text = items[index];
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildImageContainer(_firstCarImage, true, 'الصورة الأولى')),
                horizontalSpace(12),
                Expanded(child: _buildImageContainer(_secondCarImage, false, 'الصورة الثانية')),
              ],
            ),
            verticalSpace(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('اسم السيارة', style: TextStyles.font14DarkMedium),
                verticalSpace(8),
                AppTextFormField(
                  hintText: 'ادخل اسم السياره',
                  controller: postsCubit.carNameController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن ترك الحقل فارغ';
                    }
                    return null;
                  },
                ),

                verticalSpace(16),
                Text('نوع السيارة', style: TextStyles.font14DarkMedium),
                verticalSpace(8),
                AppTextFormField(
                  hintText: "اختر نوع السيارة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن ترك الحقل فارغ';
                    }
                    return null;
                  },
                  controller: postsCubit.carTypeController,
                  onTap: showCarTypeSelectionSheet,
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  readOnly: true,
                ),

                verticalSpace(16),
                Text('لون السيارة', style: TextStyles.font14DarkMedium),
                verticalSpace(8),
                AppTextFormField(
                  hintText: "اختر لون السيارة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن ترك الحقل فارغ';
                    }
                    return null;
                  },
                  controller: postsCubit.carColorController,
                  onTap:
                      () => showSelectionSheet(postsCubit.carColors, postsCubit.carColorController, "اختر لون السيارة"),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  readOnly: true,
                ),
                verticalSpace(16),
                Text('موديل السيارة', style: TextStyles.font14DarkMedium),
                verticalSpace(8),
                AppTextFormField(
                  hintText: "اختر موديل السيارة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن ترك الحقل فارغ';
                    }
                    return null;
                  },
                  controller: postsCubit.carModelController,
                  onTap:
                      () =>
                          showSelectionSheet(postsCubit.carModels, postsCubit.carModelController, "اختر موديل السيارة"),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  readOnly: true,
                ),
                verticalSpace(16),
                Text('رقم الهيكل', style: TextStyles.font14DarkMedium),
                verticalSpace(8),
                AppTextFormField(
                  hintText: 'ادخل رقم الهيكل',
                  controller: postsCubit.chassisNumberController,
                  validator: (value) {
                    return null;
                  },
                ),
                verticalSpace(16),
                Text('رقم اللوحة', style: TextStyles.font14DarkMedium),
                verticalSpace(8),
                AppTextFormField(
                  hintText: 'ادخل اللوحة',
                  controller: postsCubit.plateNumberController,
                  validator: (value) {
                    return null;
                  },
                ),

                verticalSpace(12),
              ],
            ),
            verticalSpace(20),
            Align(alignment: Alignment.topLeft, child: MainButton(text: 'التالي', onTap: () {}, width: 120.w)),
            verticalSpace(20),
          ],
        ),
      ),
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
}
