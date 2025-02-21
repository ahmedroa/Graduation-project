import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsManager.kPrimaryColor,
        onPressed: () {
          showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) => Container());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('الرئيسية'),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.notifications, color: ColorsManager.kPrimaryColor))],
      ),
      body: Column(children: []),
    );
  }
}
