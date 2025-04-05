import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/data/models/Car_information.dart';
import 'package:graduation/core/widgets/main_button.dart';
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
                  PostCar postCar = PostCar(
                    // car information
                    name: 'haval H9',
                    typeCar: 'haval',
                    color: 'white',
                    model: '2025',
                    chassisNumber: '123456789',
                    plateNumber: '123456789',
                    image:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                    images: [
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnU6sqdcgr8Y1uXsxiYBwR4rgT8rVJJ-rPMg&s',
                    ],
                    carTheftHistory: 'تم العثور عليها',

                    // location information
                    city: 'الخرطوم',
                    neighborhood: 'المنشية',
                    street: 'شارع النيل',

                    nameOwner: 'ahmed',
                    phone: '0912345678',
                    phone2: '0912345678',
                    description: 'سيارة مسروقة',
                    isWhatsapp: true,
                    isWhatsapp2: true,
                    stolen: true,
                    foundIt: false,
                    // // car information

                    // name: postsCubit.carNameController.text,
                    // typeCar: postsCubit.carTypeController.text,
                    // color: postsCubit.carColorController.text,
                    // model: postsCubit.carModelController.text,
                    // chassisNumber: postsCubit.chassisNumberController.text,
                    // plateNumber: postsCubit.plateNumberController.text,
                    // image: postsCubit.firstCarImageUrl,
                    // images: ['${postsCubit.firstCarImageUrl}', '${postsCubit.secondCarImageUrl}'],

                    // // location information
                    // city: postsCubit.cityController.text,
                    // neighborhood: postsCubit.neighborhoodController.text,
                    // street: postsCubit.streetController.text,

                    // // owner information
                    // nameOwner: postsCubit.nameOnerCarController.text,
                    // phone: postsCubit.phoneOnerCarController.text,
                    // phone2: postsCubit.phoneOnerCarController2.text,
                    // description: postsCubit.descriptionController.text,
                    // isWhatsapp: postsCubit.whats,
                    // isWhatsapp2: postsCubit.whats2,
                    // stolen: true,
                    // foundIt: false,
                  );

                  context.read<PostsCubit>().addPostCar(postCar);
                },
              );
        },
      ),
    );
  }
}
