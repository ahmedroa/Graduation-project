import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:image_picker/image_picker.dart';

class CarInformation extends StatelessWidget {
  const CarInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final postsCubit = context.read<PostsCubit>();

    // Methods to handle image selection
    void pickFirstImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        postsCubit.setFirstCarImage(File(image.path));
      }
    }

    void pickSecondImage() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        postsCubit.setSecondCarImage(File(image.path));
      }
    }

    // Methods to show selection sheets
    void showCarTypeSelectionSheet() {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Container(
            color: Colors.white,
            height: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("اختر نوع السيارة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
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

    void showSelectionSheet(List<String> items, TextEditingController controller, String title) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index]),
                        onTap: () {
                          controller.text = items[index];
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

    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: pickFirstImage,
                          child: Container(
                            height: 200,
                            width: 200,
                            color: ColorsManager.lighterGray,
                            child:
                                postsCubit.firstCarImage != null
                                    ? Image.file(postsCubit.firstCarImage!, fit: BoxFit.cover)
                                    : Icon(Icons.add_a_photo),
                          ),
                        ),
                        Text('الصورة الاولى', style: TextStyles.font14DarkRegular),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: pickSecondImage,
                          child: Container(
                            height: 200,
                            width: 200,
                            color: ColorsManager.lighterGray,
                            child:
                                postsCubit.secondCarImage != null
                                    ? Image.file(postsCubit.secondCarImage!, fit: BoxFit.cover)
                                    : Icon(Icons.add_a_photo),
                          ),
                        ),
                        Text('الصورة الثانيه', style: TextStyles.font14DarkRegular),
                      ],
                    ),
                  ],
                ),
                verticalSpace(30),

                Text('اكتب اسم و وصف السياره', style: TextStyles.font16BlacMedium),
                verticalSpace(20),

                verticalSpace(8),
                AppTextFormField(
                  hintText: 'اسم السياره',
                  controller: postsCubit.carNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن ترك الحقل فارغ';
                    }
                    return null;
                  },
                ),

                verticalSpace(16),
                AppTextFormField(
                  hintText: "اختر نوع السيارة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن ترك الحقل فارغ';
                    }
                    return null;
                  },
                  controller: postsCubit.carTypeController,
                  onTap: showCarTypeSelectionSheet,
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  // readOnly: true,
                ),

                verticalSpace(16),
                AppTextFormField(
                  hintText: "اختر لون السيارة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن ترك الحقل فارغ';
                    }
                    return null;
                  },
                  controller: postsCubit.carColorController,
                  onTap:
                      () => showSelectionSheet(postsCubit.carColors, postsCubit.carColorController, "اختر لون السيارة"),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  // readOnly: true,
                ),

                verticalSpace(16),
                AppTextFormField(
                  hintText: "اختر موديل السيارة",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'لا يمكن ترك الحقل فارغ';
                    }
                    return null;
                  },
                  controller: postsCubit.carModelController,
                  onTap:
                      () =>
                          showSelectionSheet(postsCubit.carModels, postsCubit.carModelController, "اختر موديل السيارة"),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                  // readOnly: true,
                ),

                verticalSpace(16),
                AppTextFormField(
                  hintText: 'رقم الهيكل',
                  controller: postsCubit.chassisNumberController,
                  validator: (value) {
                    return null;
                  },
                ),

                verticalSpace(16),
                AppTextFormField(
                  hintText: 'رقم اللوحة',
                  controller: postsCubit.plateNumberController,
                  validator: (value) {
                    return null;
                  },
                ),

                verticalSpace(24),

                if (state is PostsLoading)
                  Center(child: CircularProgressIndicator())
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: MainButton(
                      text: 'التالي',
                      onTap: () {
                        // Validate basic data before proceeding
                        if (postsCubit.validateCarInfo()) {
                          postsCubit.selectOption(2);
                        }
                      },
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
// class CarInformation extends StatefulWidget {
//   const CarInformation({super.key});

//   @override
//   State<CarInformation> createState() => _CarInformationState();
// }

// class _CarInformationState extends State<CarInformation> {
//   final TextEditingController _controller = TextEditingController();
//   final List<String> carTypes = [
//     "أستون مارتن",
//     "ألفا روميو",
//     "إنفينيتي",
//     "أودي",
//     "بي إم دبليو",
//     "بيجو",
//     "بورش",
//     "بوجاتي",
//     "بوغاتي",
//     "بويك",
//     "تاتا",
//     "تسلا",
//     "تويوتا",
//     "جي إم سي",
//     "جيلي",
//     "جاكوار",
//     "جينيسيس",
//     "دايهاتسو",
//     "دودج",
//     "دي إس",
//     "دونغفينغ",
//     "رام",
//     "رينو",
//     "سيتروين",
//     "سوبارو",
//     "سوزوكي",
//     "شيري",
//     "شيفروليه",
//     "شانجان",
//     "فاو",
//     "فورد",
//     "فيراري",
//     "فولفو",
//     "فولكس فاجن",
//     "كاديلاك",
//     "كيا",
//     "كوينيجسيج",
//     "لاند روفر",
//     "لكزس",
//     "لامبورغيني",
//     "لينكولن",
//     "لوتس",
//     "مازدا",
//     "مازيراتي",
//     "ماهيندرا",
//     "مايباخ",
//     "ميتسوبيشي",
//     "ميني",
//     "مرسيدس",
//     "نيسان",
//     "هافال",
//     "هوندا",
//     "هيونداي",
//   ];

//   final List<String> carColors = [
//     "أبيض",
//     "أسود",
//     "فضي",
//     "رمادي",
//     "أزرق",
//     "أحمر",
//     "أخضر",
//     "ذهبي",
//     "برتقالي",
//     "بني",
//     "أرجواني",
//     "زهري",
//   ]..sort();
//   TextEditingController carModelController = TextEditingController();

//   final List<String> carModels = List.generate(2025 - 1990 + 1, (index) => (2025 - index).toString());

//   TextEditingController carTypeController = TextEditingController();

//   TextEditingController carColorController = TextEditingController();

//   void _showCarSelectionSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (context) {
//         return Container(
//           color: Colors.white,
//           height: 350,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("اختر نوع السيارة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Divider(),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: carTypes.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(carTypes[index]),
//                       leading: Icon(Icons.directions_car),
//                       onTap: () {
//                         setState(() {
//                           _controller.text = carTypes[index];
//                         });
//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showSelectionSheet(List<String> items, TextEditingController controller, String title) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           height: 400,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Divider(),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(items[index]),
//                       onTap: () {
//                         controller.text = items[index];
//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(height: 200, width: 200, color: ColorsManager.lighterGray, child: Icon(Icons.image)),
//                       ],
//                     ),
//                     Text('الصورة الاولى', style: TextStyles.font14DarkRegular),
//                   ],
//                 ),
//                 Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(height: 200, width: 200, color: ColorsManager.lighterGray, child: Icon(Icons.image)),
//                       ],
//                     ),
//                     Text('الصورة الثانيه', style: TextStyles.font14DarkRegular),
//                   ],
//                 ),
//               ],
//             ),
//             verticalSpace(30),

//             Text('اكتب اسم و وصف السياره', style: TextStyles.font16BlacMedium),
//             verticalSpace(20),

//             verticalSpace(8),
//             AppTextFormField(hintText: 'اسم السياره', validator: (p0) {}),

//             verticalSpace(16),
//             AppTextFormField(
//               hintText: "اختر نوع السيارة",
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'لا يمكن ترك الحقل فارغ';
//                 }
//                 return null;
//               },
//               controller: _controller,
//               onTap: _showCarSelectionSheet,
//               suffixIcon: Icon(Icons.arrow_drop_down),
//               //  filled: true,
//             ),

//             verticalSpace(16),
//             AppTextFormField(
//               hintText: "اختر لون السيارة",

//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'لا يمكن ترك الحقل فارغ';
//                 }
//                 return null;
//               },
//               controller: carColorController,
//               onTap: () => _showSelectionSheet(carColors, carColorController, "اختر لون السيارة"),
//               suffixIcon: Icon(Icons.arrow_drop_down),
//               // readOnly: true,

//               //  filled: true,
//             ),

//             verticalSpace(16),
//             AppTextFormField(
//               hintText: "اختر موديل السيارة",

//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'لا يمكن ترك الحقل فارغ';
//                 }
//                 return null;
//               },
//               controller: carModelController,
//               onTap: () => _showSelectionSheet(carModels, carModelController, "اختر موديل السيارة"),
//               suffixIcon: Icon(Icons.arrow_drop_down),
//               // readOnly: true,

//               //  filled: true,
//             ),

//             verticalSpace(16),

//             AppTextFormField(hintText: 'رقم الهيكل', validator: (p0) {}),
//             verticalSpace(16),
//             AppTextFormField(hintText: 'رقم اللوحة', validator: (p0) {}),
//             verticalSpace(24),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: MainButton(
//                 text: 'التالي',
//                 onTap: () {
//                   context.read<PostsCubit>().selectOption(2);
//                 },
//                 width: MediaQuery.of(context).size.width / 3,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
