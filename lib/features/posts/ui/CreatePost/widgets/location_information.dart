import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class LocationInformation extends StatelessWidget {
  const LocationInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();
    void showCitySelectionSheet() {
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
                Text("اختر المدينة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: postsCubit.sudanCities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(postsCubit.sudanCities[index]),
                        leading: Icon(Icons.location_city),
                        onTap: () {
                          postsCubit.cityController.text = postsCubit.sudanCities[index];
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(20),
            Text('بيانات الموقع', style: TextStyles.font16BlacMedium),
            verticalSpace(8),
            AppTextFormField(
              hintText: "اختر المدينة",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'لا يمكن ترك الحقل فارغ';
                }
                return null;
              },
              controller: postsCubit.cityController,
              onTap: showCitySelectionSheet,
              suffixIcon: Icon(Icons.arrow_drop_down, size: 24),
              readOnly: true,
            ),
            verticalSpace(8),
          AppTextFormField(
              controller: postsCubit.neighborhoodController,
              hintText: 'الحي',
              validator: (value) => null,
            ),
            verticalSpace(8),
            AppTextFormField(
              controller: postsCubit.streetController,
              hintText: 'الشارع او المربع',
              validator: (value) => null,
            ),
            verticalSpace(30),
            Align(
              alignment: Alignment.centerLeft,
              child: MainButton(
                text: 'التالي',
                onTap: () {
                  if (postsCubit.selectedOption < 3) {
                    postsCubit.selectOption(postsCubit.selectedOption + 1);
                  }
                },
                width: MediaQuery.of(context).size.width / 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
