// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Details extends StatelessWidget {
  final PostCar? carList;
  const Details({super.key, this.carList});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();

    return Scaffold(
      body: Column(
        children: [
          buildImage(pageController, context),
          verticalSpace(24),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(carList?.name ?? "اسم غير متوفر", style: TextStyles.font16BlacMedium),
                Text(carList?.description ?? "اسم غير متوفر", style: TextStyles.font14GrayMedium),

                Container(
                  height: 80,
                  decoration: BoxDecoration(color: ColorsManager.grayBorder, borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [Icon(Icons.person, color: ColorsManager.kPrimaryColor), horizontalSpace(20)]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildImage(PageController pageController, BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: carList?.images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius:
                      index == carList!.images.length - 1
                          ? BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                          : BorderRadius.zero, // تضيف التدوير للصورة الأخيرة فقط
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), offset: Offset(0, 4), blurRadius: 8)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(index == carList!.images.length - 1 ? 20 : 0),
                    bottomRight: Radius.circular(index == carList!.images.length - 1 ? 20 : 0),
                  ),
                  child: Image.network(
                    carList?.images[index] ?? '',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: 40,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: SmoothPageIndicator(
              controller: pageController,
              count: carList!.images.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Colors.white,
                dotColor: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
