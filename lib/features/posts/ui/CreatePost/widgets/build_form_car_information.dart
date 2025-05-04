import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class BuildFormCarInformation extends StatelessWidget {
  final PostsCubit postsCubit;
  const BuildFormCarInformation({super.key, required this.postsCubit});

  @override
  Widget build(BuildContext context) {
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

    return Form(
      key: context.read<PostsCubit>().formKey,
      child: Column(
        children: [
          AppTextFormField(
            hintText: 'اسم السياره',
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
            readOnly: true,
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
            readOnly: true,
          ),
          verticalSpace(16),
          AppTextFormField(
            hintText: 'رقم الهيكل',
            controller: postsCubit.chassisNumberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لا يمكن ترك الحقل فارغ';
              }
              return null;
            },
          ),
          verticalSpace(16),
          AppTextFormField(
            hintText: 'رقم اللوحة',
            controller: postsCubit.plateNumberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لا يمكن ترك الحقل فارغ';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
