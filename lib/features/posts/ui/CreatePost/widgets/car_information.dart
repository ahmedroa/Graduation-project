import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/build_form_car_information.dart';

class CarInformation extends StatefulWidget {
  const CarInformation({super.key});

  @override
  State<CarInformation> createState() => _CarInformationState();
}

class _CarInformationState extends State<CarInformation> {
  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();

    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(20),
                BuildFormCarInformation(postsCubit: postsCubit),
                verticalSpace(24),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.95, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: MainButton(
                          text: 'التالي',
                          onTap: () {
                            if (postsCubit.formKey.currentState!.validate()) {
                              if (postsCubit.carImages.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.error_outline, color: Colors.white),
                                        SizedBox(width: 10),
                                        Text('الرجاء إضافة صورة واحدة على الأقل'),
                                      ],
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                                return;
                              }
                              if (postsCubit.selectedOption < 3) {
                                postsCubit.selectOption(postsCubit.selectedOption + 1);
                              }
                            }
                          },
                          width: MediaQuery.of(context).size.width / 3,
                        ),
                      ),
                    );
                  },
                ),
                verticalSpace(60),
              ],
            ),
          ),
        );
      },
    );
  }
}
