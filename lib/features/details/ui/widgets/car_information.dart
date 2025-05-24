import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/details/ui/details.dart';

class CarInformationWidget extends StatelessWidget {
  const CarInformationWidget({super.key, required this.widget});

  final Details widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130.h,
      // color: Colors.white,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(widget.carList?.name ?? "اسم غير متوفر", style: TextStyles.font16BlacMedium),
                Spacer(),
                widget.carList?.stolen == true
                    ? Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFF4D4D).withOpacity(0.16),
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text("مفقود", style: TextStyle(fontSize: 16, color: Color(0xffFF4D4D))),
                      ),
                    )
                    : Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff0070D1).withOpacity(0.16),
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text("موجود", style: TextStyle(fontSize: 16, color: Color(0xff0070D1))),
                      ),
                    ),
              ],
            ),
            verticalSpace(20),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('موديل السيارة :', style: TextStyles.font16DarkBold),
                      horizontalSpace(8),
                      Text(widget.carList?.model ?? "موقع غير متوفر", style: TextStyles.font14DarkMedium),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text('لون السيارة :', style: TextStyles.font16DarkBold),
                      horizontalSpace(8),
                      Text(widget.carList?.color ?? "موقع غير متوفر", style: TextStyles.font14DarkMedium),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('تاريخ فقد السيارة', style: TextStyles.font16DarkBold),
                      horizontalSpace(8),
                      Text(widget.carList?.dateOfCarLoss ?? "موقع غير متوفر", style: TextStyles.font14DarkMedium),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
