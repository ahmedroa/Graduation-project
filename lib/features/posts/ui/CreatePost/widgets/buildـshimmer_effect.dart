import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerEffect() {
  return Column(
    children: List.generate(
      3,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(color: ColorsManager.gray, borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    ),
  );
}
