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

  // دالة للتحقق من جميع الحقول المطلوبة في جميع الصفحات
  bool _validateAllFields(BuildContext context, PostsCubit postsCubit) {
    // التحقق من حقول صفحة معلومات السيارة
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
    if (postsCubit.firstCarImage == null) {
      showError(context, "الرجاء إضافة صورة السيارة");
      return false;
    }

    // التحقق من حقول صفحة معلومات الموقع
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

// دالة لعرض رسائل الخطأ مع أنيميشن
// void _showErrorAnimation(BuildContext context, String message) {
  // ScaffoldMessenger.of(context).hideCurrentSnackBar();
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: TweenAnimationBuilder<double>(
  //       tween: Tween<double>(begin: 0.0, end: 1.0),
  //       duration: const Duration(milliseconds: 400),
  //       curve: Curves.easeOutBack,
  //       builder: (context, value, child) {
  //         return Transform.scale(
  //           scale: value,
  //           child: Row(
  //             children: [
  //               Icon(Icons.error_outline, color: Colors.white, size: 24),
  //               horizontalSpace(12),
  //               Expanded(child: Text(message, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //     backgroundColor: Colors.red.shade800,
  //     duration: const Duration(seconds: 3),
  //     behavior: SnackBarBehavior.floating,
  //     margin: const EdgeInsets.all(8),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     elevation: 4,
  //     action: SnackBarAction(
  //       label: 'حسناً',
  //       textColor: Colors.white,
  //       onPressed: () {
  //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       },
  //     ),
  //   ),
  // );
// }
  

  // car information
                    // name: 'haval H9',
                    // typeCar: 'haval',
                    // color: 'white',
                    // model: '2025',
                    // chassisNumber: '123456789',
                    // plateNumber: '123456789',
                    // image:
                    //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                    // images: [
                    //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                    //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                    //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                    //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                    // ],
                    // carTheftHistory: 'تم العثور عليها',

                    // // location information
                    // city: 'الخرطوم',
                    // neighborhood: 'المنشية',
                    // street: 'شارع النيل',

                    // nameOwner: 'ahmed',
                    // phone: '0912345678',
                    // phone2: '0912345678',
                    // description: 'سيارة مسروقة',
                    // isWhatsapp: true,
                    // isWhatsapp2: true,
                    // stolen: true,
                    // foundIt: false,
                    // // car information




          // MainButton(
          //   text: 'التالي',
          //   width: MediaQuery.of(context).size.width / 3,
          //   onTap: () {
          //     if (postsCubit.formKey.currentState!.validate()) {
          //       PostCar postCar = PostCar(
          //         name: postsCubit.carNameController.text,
          //         typeCar: postsCubit.carTypeController.text,
          //         color: postsCubit.carColorController.text,
          //         model: postsCubit.carModelController.text,
          //         chassisNumber: postsCubit.chassisNumberController.text,
          //         plateNumber: postsCubit.plateNumberController.text,
          //         // image: postsCubit.firstCarImageUrl,
          //         image:
          //             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
          //         images: [
          //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
          //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
          //         ],
          //         // images: ['${postsCubit.firstCarImageUrl}', '${postsCubit.secondCarImageUrl}'],

          //         // location information
          //         city: postsCubit.cityController.text,
          //         neighborhood: postsCubit.neighborhoodController.text,
          //         street: postsCubit.streetController.text,

          //         // owner information
          //         nameOwner: postsCubit.nameOnerCarController.text,
          //         phone: postsCubit.phoneOnerCarController.text,
          //         phone2: postsCubit.phoneOnerCarController2.text,
          //         description: postsCubit.descriptionController.text,
          //         isWhatsapp: postsCubit.whats,
          //         isWhatsapp2: postsCubit.whats2,
          //         stolen: true,
          //       );

          //       context.read<PostsCubit>().addPostCar(postCar);
          //     } else {
          //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("الرجاء ملء جميع الحقول")));
          //     }
          //   },
          // );