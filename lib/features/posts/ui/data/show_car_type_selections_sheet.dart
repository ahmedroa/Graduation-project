import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

void showCarTypeSelectionSheet(BuildContext context, PostsCubit postsCubit) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  const Text('اختر نوع السيارة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: postsCubit.carTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.directions_car, color: ColorsManager.kPrimaryColor),
                    title: Text(
                      postsCubit.carTypes[index],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing:
                        postsCubit.carTypeController.text == postsCubit.carTypes[index]
                            ? Icon(Icons.check_circle, color: ColorsManager.kPrimaryColor)
                            : null,
                    onTap: () {
                      postsCubit.carTypeController.text = postsCubit.carTypes[index];
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
