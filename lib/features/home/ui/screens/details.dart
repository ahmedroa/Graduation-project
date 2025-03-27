// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Details extends StatelessWidget {
  final carList;
  const Details({super.key, this.carList});

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(); // للتحكم في الصور

    return Scaffold(
      body: Column(
        children: [
          buildImage(pageController, context),
          verticalSpace(24),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(carList.name ?? "اسم غير متوفر", style: TextStyle(fontSize: 20, color: Colors.black)),

                Container(
                  height: 80,
                  decoration: BoxDecoration(color: ColorsManager.grayBorder, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: ColorsManager.kPrimaryColor),
                      horizontalSpace(20),
                      Text(carList.nameFound ?? "اسم غير متوفر", style: TextStyle(fontSize: 20, color: Colors.black)),
                    ],
                  ),
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
            itemCount: carList.images.length,
            itemBuilder: (context, index) {
              return Image.network(carList.images[index] ?? '', width: double.infinity, height: 300, fit: BoxFit.cover);
            },
          ),

          Padding(
            padding: const EdgeInsets.only(top: 55, right: 16),
            child: Align(
              alignment: Alignment.topRight,
              child: Positioned(
                top: 40,
                left: 16,

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
            ),
          ),

          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: SmoothPageIndicator(
              controller: pageController,
              count: carList.images.length,
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



//  Text(carList.name ?? "اسم غير متوفر"),
//             Text(carList.description ?? "وصف غير متوفر"),
//             Text(carList.name ?? "اسم غير متوفر"),
//             Text(carList.phone ?? "اسم غير متوفر"),
//             Text(carList.name ?? "اسم غير متوفر"),
//             Text(carList.name ?? "اسم غير متوفر")