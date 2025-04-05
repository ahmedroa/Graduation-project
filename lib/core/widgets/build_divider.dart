import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';

class BuildDivider extends StatelessWidget {
  const BuildDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 0, color: ColorsManager.grayBorder, thickness: .4);
  }
}
