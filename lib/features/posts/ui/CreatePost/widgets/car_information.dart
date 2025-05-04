import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/build_form_car_information.dart';
import 'package:image_picker/image_picker.dart';

class CarInformation extends StatefulWidget {
  const CarInformation({super.key});

  @override
  State<CarInformation> createState() => _CarInformationState();
}

class _CarInformationState extends State<CarInformation> {
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
                    BoxShadow(color: ColorsManager.kPrimaryColor.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 2)),
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

    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.asset('img/sedan.png', height: 20),
                verticalSpace(20),
                selectImages(pickFirstImage, postsCubit, pickSecondImage),
                verticalSpace(20),
                Text('اكتب اسم و وصف السياره', style: TextStyles.font16BlacMedium),
                verticalSpace(8),
                Center(
                  child: SizedBox(
                    height: 70,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
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
                ),
                verticalSpace(20),
                BuildFormCarInformation(postsCubit: postsCubit),

                // buildAppTextFormField(postsCubit, context, showCarTypeSelectionSheet, showSelectionSheet),
                verticalSpace(24),

                if (state is PostsLoading)
                  Center(child: CircularProgressIndicator())
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MainButton(
                      text: 'التالي',
                      onTap: () {
                        if (postsCubit.formKey.currentState!.validate()) {
                          if (postsCubit.selectedOption < 3) {
                            postsCubit.selectOption(postsCubit.selectedOption + 1);
                          }
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
      ],
    );
  }
}
