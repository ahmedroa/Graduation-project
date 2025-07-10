import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/core/widgets/show_error.dart';
import 'package:graduation/features/auth/register/ui/widgets/register_bloc_listener.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class ButtonSnedPostReport extends StatelessWidget {
  const ButtonSnedPostReport({super.key});

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();
    return Align(
      alignment: Alignment.centerLeft,
      child: BlocConsumer<PostsCubit, PostsState>(
        listener: (context, state) {
          if (state is PostsSendSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تمت إضافة بيانات المالك بنجاح!")));
                  context.pushReplacementNamed(Routes.bottomNavBar);
          } else if (state is PostsError) {
            setupErrorState(context, state.message);
          } else if (state is PageValidationError) {
            setupErrorState(context, state.message);
          }
        },
        builder: (context, state) {
          return state is PostsLoading
              ? const Center(child: CircularProgressIndicator())
              : MainButton(
                text: 'التالي',
                width: MediaQuery.of(context).size.width / 3,
                onTap: () {
                  if (postsCubit.formKey.currentState!.validate()) {
                    if (_validateAllFields(context, postsCubit)) {
                      PostCar postCar = PostCar(
                        name: postsCubit.carNameController.text,
                        typeCar: postsCubit.carTypeController.text,
                        color: postsCubit.carColorController.text,
                        model: postsCubit.carModelController.text,
                        chassisNumber: postsCubit.chassisNumberController.text,
                        plateNumber: postsCubit.plateNumberController.text,
                        image: '',
                        images: [],

                        city: postsCubit.cityController.text,
                        neighborhood: postsCubit.neighborhoodController.text,
                        street: postsCubit.streetController.text,

                        description: postsCubit.descriptionController.text,
                        stolen: false,
                        carSize: postsCubit.selectedTagName,
                        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
                      );
                      context.read<PostsCubit>().addPostCar(postCar);
                    }
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("الرجاء ملء جميع الحقول في الصفحة الحالية بشكل صحيح")));
                  }
                },
              );
        },
      ),
    );
  }

  bool _validateAllFields(BuildContext context, PostsCubit postsCubit) {
    if (postsCubit.carNameController.text.isEmpty) {
      showError(context, "الرجاء إدخال اسم السيارة");
      return false;
    }
    if (postsCubit.carTypeController.text.isEmpty) {
      showError(context, "الرجاء إدخال نوع السيارة");
      return false;
    }
    if (postsCubit.carColorController.text.isEmpty) {
      showError(context, "الرجاء إدخال لون السيارة");
      return false;
    }

    if (postsCubit.carImages.isEmpty) {
      showError(context, "الرجاء إضافة صورة واحدة على الأقل للسيارة");
      return false;
    }

    if (postsCubit.cityController.text.isEmpty) {
      showError(context, "الرجاء إدخال اسم المدينة");
      return false;
    }
    if (postsCubit.neighborhoodController.text.isEmpty) {
      showError(context, "الرجاء إدخال اسم الحي");
      return false;
    }
    if (postsCubit.streetController.text.isEmpty) {
      showError(context, "الرجاء إدخال اسم الشارع");
      return false;
    }

    return true;
  }
}
