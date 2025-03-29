import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:image_picker/image_picker.dart';

class CarInformation extends StatelessWidget {
  const CarInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();

    void pickFirstImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        postsCubit.setFirstCarImage(File(image.path));
      }
    }

    void pickSecondImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        postsCubit.setSecondCarImage(File(image.path));
      }
    }

    void showCarTypeSelectionSheet() {
      showModalBottomSheet(
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

    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                selectImages(pickFirstImage, postsCubit, pickSecondImage),
                verticalSpace(20),
                Text('اكتب اسم و وصف السياره', style: TextStyles.font16BlacMedium),
                verticalSpace(8),
                buildAppTextFormField(postsCubit, showCarTypeSelectionSheet, showSelectionSheet),

                verticalSpace(24),

                if (state is PostsLoading)
                  Center(child: CircularProgressIndicator())
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MainButton(
                      text: 'التالي',
                      onTap: () {
                        if (postsCubit.validateCarInfo()) {
                          postsCubit.selectOption(2);
                        }
                      },
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column buildAppTextFormField(
    PostsCubit postsCubit,
    void Function() showCarTypeSelectionSheet,
    void Function(List<String> items, TextEditingController controller, String title) showSelectionSheet,
  ) {
    return Column(
      children: [
        AppTextFormField(
          hintText: 'اسم السياره',
          controller: postsCubit.carNameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'لا يمكن ترك الحقل فارغ';
            }
            return null;
          },
        ),

        verticalSpace(16),
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
          // readOnly: true,
        ),

        verticalSpace(16),
        AppTextFormField(
          hintText: "اختر لون السيارة",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'لا يمكن ترك الحقل فارغ';
            }
            return null;
          },
          controller: postsCubit.carColorController,
          onTap: () => showSelectionSheet(postsCubit.carColors, postsCubit.carColorController, "اختر لون السيارة"),
          suffixIcon: Icon(Icons.arrow_drop_down),
          // readOnly: true,
        ),

        verticalSpace(16),
        AppTextFormField(
          hintText: "اختر موديل السيارة",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'لا يمكن ترك الحقل فارغ';
            }
            return null;
          },
          controller: postsCubit.carModelController,
          onTap: () => showSelectionSheet(postsCubit.carModels, postsCubit.carModelController, "اختر موديل السيارة"),
          suffixIcon: Icon(Icons.arrow_drop_down),
          // readOnly: true,
        ),

        verticalSpace(16),
        AppTextFormField(
          hintText: 'رقم الهيكل',
          controller: postsCubit.chassisNumberController,
          validator: (value) {
            return null;
          },
        ),

        verticalSpace(16),
        AppTextFormField(
          hintText: 'رقم اللوحة',
          controller: postsCubit.plateNumberController,
          validator: (value) {
            return null;
          },
        ),
      ],
    );
  }

  Row selectImages(void Function() pickFirstImage, PostsCubit postsCubit, void Function() pickSecondImage) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickFirstImage,
                child: Container(
                  height: 200,
                  width: double.infinity,

                  color: ColorsManager.lighterGray,
                  child:
                      postsCubit.firstCarImage != null
                          ? Image.file(postsCubit.firstCarImage!, fit: BoxFit.cover)
                          : Icon(Icons.add_a_photo),
                ),
              ),
              Text('الصورة الاولى', style: TextStyles.font14DarkRegular),
            ],
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickSecondImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: ColorsManager.lighterGray,
                  child:
                      postsCubit.secondCarImage != null
                          ? Image.file(postsCubit.secondCarImage!, fit: BoxFit.cover)
                          : Icon(Icons.add_a_photo),
                ),
              ),
              Text('الصورة الثانية', style: TextStyles.font14DarkRegular),
            ],
          ),
        ),
      ],
    );
  }
}
