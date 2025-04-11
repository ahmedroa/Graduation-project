import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class ButtonSnedReport extends StatelessWidget {
  const ButtonSnedReport({super.key});

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();
    return Align(
      alignment: Alignment.centerLeft,
      child: BlocConsumer<PostsCubit, PostsState>(
        listener: (context, state) {
          if (state is PostsSendSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تمت إضافة بيانات المالك بنجاح!")));
            context.pushNamed(Routes.bottomNavBar);
          } else if (state is PostsError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ: ${state.message}")));
          }
        },
        builder: (context, state) {
          return state is PostsLoading
              ? const CircularProgressIndicator()
              : MainButton(
                text: 'التالي',
                width: MediaQuery.of(context).size.width / 3,
                onTap: () {
                  if (postsCubit.formKey.currentState!.validate()) {
                    PostCar postCar = PostCar(
                      name: postsCubit.carNameController.text,
                      typeCar: postsCubit.carTypeController.text,
                      color: postsCubit.carColorController.text,
                      model: postsCubit.carModelController.text,
                      chassisNumber: postsCubit.chassisNumberController.text,
                      plateNumber: postsCubit.plateNumberController.text,
                      // image: postsCubit.firstCarImageUrl,
                      image:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                      images: [
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                      ],
                      // images: ['${postsCubit.firstCarImageUrl}', '${postsCubit.secondCarImageUrl}'],

                      // location information
                      city: postsCubit.cityController.text,
                      neighborhood: postsCubit.neighborhoodController.text,
                      street: postsCubit.streetController.text,

                      // owner information
                      nameOwner: postsCubit.nameOnerCarController.text,
                      phone: postsCubit.phoneOnerCarController.text,
                      phone2: postsCubit.phoneOnerCarController2.text,
                      description: postsCubit.descriptionController.text,
                      isWhatsapp: postsCubit.whats,
                      isWhatsapp2: postsCubit.whats2,
                      stolen: false,
                    );

                    context.read<PostsCubit>().addPostCar(postCar);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("الرجاء ملء جميع الحقول")));
                  }
                },
              );
        },
      ),
    );
  }
}
