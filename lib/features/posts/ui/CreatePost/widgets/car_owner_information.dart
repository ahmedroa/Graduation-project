import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/button_sned_post.dart';

class CarOwnerInformation extends StatefulWidget {
  const CarOwnerInformation({super.key});

  @override
  State<CarOwnerInformation> createState() => _CarOwnerInformationState();
}

class _CarOwnerInformationState extends State<CarOwnerInformation> {
  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(20),
            Text('بيانات صاحب المركبه', style: TextStyles.font16BlacMedium),
            verticalSpace(20),

            buildAppTextFormField(postsCubit),
            verticalSpace(20),
            ButtonSnedPost(),
          ],
        ),
      ),
    );
  }

  buildAppTextFormField(PostsCubit postsCubit) {
    return Form(
      key: postsCubit.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('اسم صاحب المركبه', style: TextStyles.font14DarkMedium),
          verticalSpace(8),
          AppTextFormField(
            controller: postsCubit.nameOnerCarController,
            hintText: 'اكتب الاسم',
            validator: (value) {
              return null;
            },
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'لا يمكن ترك الحقل فارغ';
            //   }
            //   return null;
            // },
          ),
          verticalSpace(12),

          Text('رقم الهاتف', style: TextStyles.font14DarkMedium),
          verticalSpace(8),
          AppTextFormField(
            controller: postsCubit.phoneOnerCarController,
            hintText: 'اكتب رقم الهاتف',
            validator: (v) {
              return null;
            },
          ),
          Row(
            children: [
              Checkbox(
                value: postsCubit.whats,
                onChanged: (bool? value) {
                  setState(() {
                    postsCubit.whats = value!;
                  });
                },
              ),
              Text('يحتوي على واتساب', style: TextStyles.font14DarkMedium),
            ],
          ),

          Text('رقم هاتف اخر', style: TextStyles.font14DarkMedium),
          verticalSpace(8),
          AppTextFormField(
            controller: postsCubit.phoneOnerCarController2,
            hintText: 'اكتب رقم هاتف اخر ',
            validator: (v) {
              return null;
            },
          ), //
          Row(
            children: [
              Checkbox(
                value: postsCubit.whats2,
                onChanged: (bool? value) {
                  setState(() {
                    postsCubit.whats2 = value!;
                  });
                },
              ),
              Text('يحتوي على واتساب', style: TextStyles.font14DarkMedium),
            ],
          ),
          verticalSpace(12),
          AppTextFormField(
            controller: postsCubit.descriptionController,
            hintText: 'كتابة تعليق',
            validator: (value) {
              return null;
            },
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
