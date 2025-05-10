// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/car_images_gallery.dart';
import 'package:graduation/features/posts/ui/ReportVehicle/widgets/build_form_report_vehicle.dart';

class ReportVehicle extends StatefulWidget {
  const ReportVehicle({super.key});

  @override
  _ReportVehicleState createState() => _ReportVehicleState();
}

class _ReportVehicleState extends State<ReportVehicle> {
  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();

    return Expanded(
      child: Form(
        key: postsCubit.formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarImagesGallery(postsCubit: postsCubit, maxImages: 4),
              verticalSpace(20),
              Text('نوع السيارة', style: TextStyles.font16BlacMedium),
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
                                  child: buildTags(map.key, postsCubit, context),
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
              verticalSpace(20),
              BuildFormReportVehicle(postsCubit: postsCubit),

              verticalSpace(12),
              verticalSpace(20),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.95, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: MainButton(
                        text: 'التالي',
                        onTap: () {
                          if (postsCubit.formKey.currentState!.validate()) {
                            if (postsCubit.carImages.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(Icons.error_outline, color: Colors.white),
                                      SizedBox(width: 10),
                                      Text('الرجاء إضافة صورة واحدة على الأقل'),
                                    ],
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                              return;
                            }
                            if (postsCubit.selectedOption < 3) {
                              postsCubit.selectOption(postsCubit.selectedOption + 1);
                            }
                          }
                        },
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                    ),
                  );
                },
              ),
              verticalSpace(60),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTags(int index, PostsCubit postsCubit, BuildContext context) {
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
                ? [BoxShadow(color: ColorsManager.kPrimaryColor.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 2))]
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
              fontSize: 12,
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
