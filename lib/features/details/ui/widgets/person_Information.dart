import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/details/ui/details.dart';

class PersonInformation extends StatelessWidget {
  const PersonInformation({super.key, required this.widget});

  final Details widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90.h,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.person, color: ColorsManager.kPrimaryColor, size: 20.sp),
            horizontalSpace(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.carList?.nameOwner ?? "اسم غير متوفر", style: TextStyles.font16DarkBold),
                Text(widget.carList?.phone ?? "اسم غير متوفر", style: TextStyles.font14DarkRegular),
              ],
            ),
            Spacer(),
            Icon(Icons.phone, color: ColorsManager.kPrimaryColor, size: 20.sp),
            horizontalSpace(8),
          ],
        ),
      ),
    );
  }
}
