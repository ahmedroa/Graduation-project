import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';

class AddPostBottomSheet extends StatelessWidget {
  const AddPostBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.35,
        child: Column(
          children: [
            verticalSpace(12),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(12),
                  verticalSpace(12),
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    tween: Tween<double>(begin: -30, end: 0),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: (value + 30) / 30,
                        child: Transform.translate(offset: Offset(0, value), child: child),
                      );
                    },
                    child: buildItem(
                      title: 'أبلغ عن سيارة مفقودة',
                      titlee: 'قم بنشر بلاغ لسيارتك المفقودة',
                      onTap: () {
                        context.pushNamed(Routes.createPost);
                      },
                    ),
                  ),
                  verticalSpace(8),
                  TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    tween: Tween<double>(begin: -30, end: 0),
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: (value + 30) / 30,
                        child: Transform.translate(offset: Offset(0, value), child: child),
                      );
                    },
                    child: buildItem(
                      title: 'أبلغ عن سيارة تم العثور عليها',
                      titlee: 'شارك معلومات عن سيارة وجدتها',
                      onTap: () {
                        context.pushNamed(Routes.sectionReportVehicle);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem({required String title, required String titlee, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: ColorsManager.grayBorder, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.font16BlacMedium.copyWith(fontSize: 20)),
              Text(titlee, style: TextStyles.font14GraySemiBold),
            ],
          ),
        ),
      ),
    );
  }
}
