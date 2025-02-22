// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final carList;
  const Details({super.key, this.carList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(carList.name)),
      body: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(carList.image ?? '', width: 300, height: 300, fit: BoxFit.cover),
              Text(carList.name ?? "اسم غير متوفر"),
              Text(carList.description ?? "وصف غير متوفر"),
              Text(carList.name ?? "اسم غير متوفر"),
              Text(carList.phone ?? "اسم غير متوفر"),
              Text(carList.name ?? "اسم غير متوفر"),
              Text(carList.name ?? "اسم غير متوفر"),
            ],
          ),
        ),
      ),
    );
  }
}
