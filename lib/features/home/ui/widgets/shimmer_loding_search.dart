import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';

import 'package:shimmer/shimmer.dart';

class ShimmerLodingSearch extends StatelessWidget {
  const ShimmerLodingSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: ColorsManager.lightGray,
                    highlightColor: Colors.white,
                    child: Container(
                      width: 110,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: ColorsManager.lightGray,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 18,
                            width: 180,
                            decoration: BoxDecoration(
                              color: ColorsManager.lightGray,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Shimmer.fromColors(
                          baseColor: ColorsManager.lightGray,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 14,
                            width: 160,
                            decoration: BoxDecoration(
                              color: ColorsManager.lightGray,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Shimmer.fromColors(
                          baseColor: ColorsManager.lightGray,
                          highlightColor: Colors.white,
                          child: Container(
                            height: 14,
                            width: 160,
                            decoration: BoxDecoration(
                              color: ColorsManager.lightGray,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
