import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/core/widgets/show_error.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class ButtonSnedPost extends StatelessWidget {
  const ButtonSnedPost({super.key});

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
          } else if (state is PageValidationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
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

                        nameOwner: postsCubit.nameOnerCarController.text,
                        phone: postsCubit.phoneOnerCarController.text,
                        phone2: postsCubit.phoneOnerCarController2.text,
                        description: postsCubit.descriptionController.text,
                        isWhatsapp: postsCubit.whats,
                        isWhatsapp2: postsCubit.whats2,
                        stolen: true,
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
    if (postsCubit.carModelController.text.isEmpty) {
      showError(context, "الرجاء إدخال موديل السيارة");
      return false;
    }
    if (postsCubit.plateNumberController.text.isEmpty) {
      showError(context, "الرجاء إدخال رقم اللوحة");
      return false;
    }
    if (postsCubit.chassisNumberController.text.isEmpty) {
      showError(context, "الرجاء إدخال رقم الشاسيه");
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

    // التحقق من حقول صفحة معلومات المالك
    if (postsCubit.nameOnerCarController.text.isEmpty) {
      showError(context, "الرجاء إدخال اسم المالك");
      return false;
    }
    if (postsCubit.phoneOnerCarController.text.isEmpty) {
      showError(context, "الرجاء إدخال رقم الهاتف");
      return false;
    }
    if (postsCubit.phoneOnerCarController.text.length < 9) {
      showError(context, "رقم الهاتف غير صالح");
      return false;
    }

    return true;
  }
}



// MainButton(
//                 text: 'التالي',
//                 width: MediaQuery.of(context).size.width / 3,
//                 onTap: () {
//                   PostCar postCar = PostCar(
//                     name: 'Haval H6 ',
//                     typeCar: '',
//                     color: 'احمر',
//                     model: '2023',
//                     chassisNumber: '9490490032',
//                     plateNumber: '47492',
//                     image:
//                         'https://i1.wp.com/saudiauto.com.sa/wp-content/uploads/2024/10/haval-h9-cn-reveal-my24-1001x565-4.webp',
//                     images: [
//                       'https://i1.wp.com/saudiauto.com.sa/wp-content/uploads/2024/10/haval-h9-cn-reveal-my24-1001x565-4.webp',
//                       'https://i1.wp.com/saudiauto.com.sa/wp-content/uploads/2024/10/haval-h9-cn-reveal-my24-1001x565-4.webp',
//                       'https://i1.wp.com/saudiauto.com.sa/wp-content/uploads/2024/10/haval-h9-cn-reveal-my24-1001x565-4.webp',
//                     ],

//                     city: 'الخرطوم',
//                     neighborhood: 'المعمورة',
//                     street: 'اخر محطة',

//                     nameOwner: 'احمد خالد رمضان',
//                     phone: '0548828730',
//                     phone2: '0548828730',
//                     description: 'سرقت سيارتي من المعموره اخر محطه من قبل الدعم السريع ',
//                     isWhatsapp: postsCubit.whats,
//                     isWhatsapp2: postsCubit.whats2,
//                     stolen: false,
//                     carSize: 'كبيره',
//                     timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
//                   );
//                   context.read<PostsCubit>().addPostCar(postCar);
//                 },
//               );