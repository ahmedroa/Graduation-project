// دالة showCarTypeSelectionSheet خارج الكلاس
import 'package:flutter/material.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

void showarTypeSelectionSheet(BuildContext context, PostsCubit postsCubit) {
  showModalBottomSheet(
    backgroundColor: ColorsManager.lighterGray,
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return Container(
        color: Colors.white,
        height: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: postsCubit.carTypes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(postsCubit.carTypes[index]),
                    leading: Icon(Icons.directions_car),
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
