import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/car_images_gallery.dart';
import 'package:graduation/features/posts/ui/data/show_car_type_selections_sheet.dart';
import 'package:graduation/features/posts/ui/data/show_selection_sheet.dart';
import 'package:intl/intl.dart';

class BuildFormCarInformation extends StatelessWidget {
  final PostsCubit postsCubit;
  const BuildFormCarInformation({super.key, required this.postsCubit});

  @override
  Widget build(BuildContext context) {
    Widget buildTags(int index, PostsCubit postsCubit) {
      return GestureDetector(
        onTap: () {
          postsCubit.updateSelectedTag(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(15),
            border:
                postsCubit.selectedTag == index
                    ? Border.all(color: ColorsManager.kPrimaryColor, width: 2)
                    : Border.all(color: Colors.transparent),
            boxShadow:
                postsCubit.selectedTag == index
                    ? [
                      BoxShadow(
                        color: ColorsManager.kPrimaryColor.withOpacity(0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Image.asset(
                  postsCubit.tagImages[index],
                  key: ValueKey<int>(postsCubit.selectedTag == index ? 1 : 0),
                  height: 24,
                  width: 24,
                  color: postsCubit.selectedTag == index ? ColorsManager.kPrimaryColor : Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 12.sp,
                  color:
                      postsCubit.selectedTag == index
                          ? ColorsManager.kPrimaryColor
                          : Theme.of(context).colorScheme.secondary,
                  fontWeight: postsCubit.selectedTag == index ? FontWeight.bold : FontWeight.normal,
                ),
                child: Text(postsCubit.tags[index]),
              ),
            ],
          ),
        ),
      );
    }

    return Form(
      key: context.read<PostsCubit>().formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarImagesGallery(postsCubit: postsCubit, maxImages: 4),
          verticalSpace(20),
          Text('نوع السيارة', style: TextStyles.font16BlacMedium),
          verticalSpace(8),
          Center(
            child: SizedBox(
              height: 70.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    postsCubit.tags.asMap().entries.map((MapEntry map) {
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.8, end: 1.0),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: map.key == postsCubit.selectedTag ? value : 1.0,
                            child: buildTags(map.key, postsCubit),
                          );
                        },
                      );
                    }).toList(),
              ),
            ),
          ),
          verticalSpace(20),
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
            onTap: () => showCarTypeSelectionSheet(context, postsCubit),

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
                () => showSelectionSheet(
                  context,
                  postsCubit.carColors,
                  postsCubit.carColorController,
                  "اختر لون السيارة",
                ),
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
                () => showSelectionSheet(
                  context,
                  postsCubit.carModels,
                  postsCubit.carModelController,
                  "اختر موديل السيارة",
                ),
            suffixIcon: Icon(Icons.arrow_drop_down),
            readOnly: true,
          ),
          verticalSpace(16),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: 'رقم الهيكل  ', style: TextStyles.font14DarkMedium),
                TextSpan(text: '( إن وجد )', style: TextStyles.font10GreyRegular),
              ],
            ),
          ),
          verticalSpace(8),
          AppTextFormField(
            hintText: 'ادخل رقم الهيكل',
            controller: postsCubit.chassisNumberController,
            keyboardType: TextInputType.number,

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
            keyboardType: TextInputType.number,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لا يمكن ترك الحقل فارغ';
              }
              return null;
            },
          ),
          verticalSpace(16),
          Text('تاريخ سرقة السيارة', style: TextStyles.font14DarkMedium),
          verticalSpace(8),

          AppTextFormField(
            hintText: 'ادخل التاريخ',
            controller: postsCubit.dateController,
            keyboardType: TextInputType.datetime,
            readOnly: true,
            // suffixIcon: Icon(Icons.calendar_today, color: ColorsManager.kPrimaryColor, size: 20),
            onTap: () async {
              FocusScope.of(context).unfocus();
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2019),
                lastDate: DateTime(2100),
                locale: Locale('ar', 'SA'),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: ColorsManager.kPrimaryColor,
                        onPrimary: Colors.white,
                        surface: ColorsManager.grayBorder,
                        onSurface: Colors.black,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(foregroundColor: ColorsManager.kPrimaryColor),
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (selectedDate != null) {
                String formattedDate = DateFormat('dd/MM/yyyy', 'en').format(selectedDate);
                postsCubit.dateController.text = formattedDate;
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لا يمكن ترك الحقل فارغ';
              }
              return null;
            },
          ),

          verticalSpace(12),
        ],
      ),
    );
  }
}
