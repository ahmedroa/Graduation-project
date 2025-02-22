import 'package:flutter/material.dart';
import 'package:graduation/core/data/models/Car_information.dart';

class BuildItemPostsCars extends StatelessWidget {
  final PostCar carList;
  const BuildItemPostsCars({super.key, required this.carList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.grey[200],
        width: double.infinity,

        child: Padding(padding: const EdgeInsets.all(12.0), child: Text(carList.name ?? "اسم غير متوفر")),
      ),
    );
  }
}
