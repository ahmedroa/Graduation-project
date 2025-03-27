// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:image_picker/image_picker.dart';

class ReportVehicle extends StatefulWidget {
  const ReportVehicle({super.key});

  @override
  _ReportVehicleState createState() => _ReportVehicleState();
}

class _ReportVehicleState extends State<ReportVehicle> {
  File? _firstCarImage;
  File? _secondCarImage;

  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('خدمة الموقع غير مفعلة');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('تم رفض إذن الوصول إلى الموقع');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error('إذن الموقع مرفوض دائمًا، يجب تفعيله من الإعدادات');
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          neighborhoodController.text = place.subLocality ?? ''; // الحي
          cityController.text = place.locality ?? ''; // المدينة
          streetController.text = place.street ?? ''; // الشارع
        });
      }
      print('الموقع: ${position.latitude}, ${position.longitude}');
      print('العنوان: ${placemarks.first}');
      print('الحي: ${placemarks.first.subLocality}');
      print('المدينة: ${placemarks.first.locality}');
      print('الشارع: ${placemarks.first.street}');
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // الآن نقوم بتحديث الحقول باستخدام setState
        setState(() {
          neighborhoodController.text = place.subLocality ?? 'غير متوفر'; // الحي
          cityController.text = place.locality ?? 'غير متوفر'; // المدينة
          streetController.text = place.street ?? 'غير متوفر'; // الشارع
        });
      }
    } catch (e) {
      print("خطأ في جلب الموقع: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الإبلاغ عن سيارة')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildImageContainer(_firstCarImage, true, 'الصورة الأولى'),
                SizedBox(width: 10),
                _buildImageContainer(_secondCarImage, false, 'الصورة الثانية'),
              ],
            ),
            verticalSpace(20),

            _buildLocationFields(),
            verticalSpace(20),

            Align(
              alignment: Alignment.topLeft,
              child: MainButton(text: 'تحديد الموقع', onTap: _getLocation, width: 120.w),
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(File? image, bool isFirstImage, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _pickImage(isFirstImage),
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            child:
                image != null
                    ? Stack(
                      children: [
                        Positioned.fill(child: Image.file(image, fit: BoxFit.cover)),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () => _removeImage(isFirstImage),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 15,
                              child: Icon(Icons.close, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700]),
          ),
        ),
        SizedBox(height: 10),
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<void> _pickImage(bool isFirstImage) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await showModalBottomSheet<XFile>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('التقاط صورة'),
                onTap: () async {
                  Navigator.pop(context, await picker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('اختيار من المعرض'),
                onTap: () async {
                  Navigator.pop(context, await picker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        if (isFirstImage) {
          _firstCarImage = File(pickedFile.path);
        } else {
          _secondCarImage = File(pickedFile.path);
        }
      });
    }
  }

  void _removeImage(bool isFirstImage) {
    setState(() {
      if (isFirstImage) {
        _firstCarImage = null;
      } else {
        _secondCarImage = null;
      }
    });
  }

  Widget _buildLocationFields() {
    return Column(
      children: [
        TextFormField(
          controller: neighborhoodController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsManager.kPrimaryColor, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primaryContainer),
              borderRadius: BorderRadius.circular(16.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),

            hintText: 'المدينه',
            helperStyle: const TextStyle(color: Color(0xffA2A2A2)),

            fillColor: Theme.of(context).colorScheme.primaryContainer,
            filled: true,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'الحي مطلوب';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: cityController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsManager.kPrimaryColor, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primaryContainer),
              borderRadius: BorderRadius.circular(16.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),

            hintText: 'المدينه',
            helperStyle: const TextStyle(color: Color(0xffA2A2A2)),

            fillColor: Theme.of(context).colorScheme.primaryContainer,
            filled: true,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'المدينة مطلوبة';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: streetController,
          decoration: InputDecoration(
            // helperText: '',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorsManager.kPrimaryColor, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primaryContainer),
              borderRadius: BorderRadius.circular(16.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.3),
              borderRadius: BorderRadius.circular(16.0),
            ),
            hintText: 'الشارع',
            helperStyle: const TextStyle(color: Color(0xffA2A2A2)),

            fillColor: Theme.of(context).colorScheme.primaryContainer,
            filled: true,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'الشارع مطلوب';
            }
            return null;
          },
        ),
      ],
    );
  }
}

// class ReportVehicle extends StatefulWidget {
//   const ReportVehicle({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _ReportVehicleState createState() => _ReportVehicleState();
// }

// class _ReportVehicleState extends State<ReportVehicle> {
//   File? _firstCarImage;
//   File? _secondCarImage;

//   Future<void> _pickImage(bool isFirstImage) async {
//     final ImagePicker picker = ImagePicker();

//     final XFile? pickedFile = await showModalBottomSheet<XFile>(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera),
//                 title: Text('التقاط صورة'),
//                 onTap: () async {
//                   Navigator.pop(context, await picker.pickImage(source: ImageSource.camera));
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.photo_library),
//                 title: Text('اختيار من المعرض'),
//                 onTap: () async {
//                   Navigator.pop(context, await picker.pickImage(source: ImageSource.gallery));
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );

//     if (pickedFile != null) {
//       setState(() {
//         if (isFirstImage) {
//           _firstCarImage = File(pickedFile.path);
//         } else {
//           _secondCarImage = File(pickedFile.path);
//         }
//       });
//     }
//   }

//   void _removeImage(bool isFirstImage) {
//     setState(() {
//       if (isFirstImage) {
//         _firstCarImage = null;
//       } else {
//         _secondCarImage = null;
//       }
//     });
//   }

//   TextEditingController locationController = TextEditingController();

//   Future<void> _getLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         return Future.error('خدمة الموقع غير مفعلة');
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return Future.error('تم رفض إذن الوصول إلى الموقع');
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         return Future.error('إذن الموقع مرفوض دائمًا، يجب تفعيله من الإعدادات');
//       }

//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         String address = "${place.locality}, ${place.subLocality}, ${place.street}";
//         setState(() {
//           locationController.text = address; // تعبئة الحقل بالموقع
//         });
//       }
//     } catch (e) {
//       print("خطأ في جلب الموقع: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('الإبلاغ عن سيارة')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 _buildImageContainer(_firstCarImage, true, 'الصورة الأولى'),
//                 SizedBox(width: 10),
//                 _buildImageContainer(_secondCarImage, false, 'الصورة الثانية'),
//               ],
//             ),
//             verticalSpace(20),
//             MainButton(text: 'تحديد الموقع', onTap: _getLocation),
//             verticalSpace(20),
//           AppTextFormField(hintText: 'الحي', validator: (p0) {

//           },),
//           verticalSpace(20),

//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImageContainer(File? image, bool isFirstImage, String label) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () => _pickImage(isFirstImage),
//           child: Container(
//             height: 200,
//             width: 200,
//             decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
//             child:
//                 image != null
//                     ? Stack(
//                       children: [
//                         Positioned.fill(child: Image.file(image, fit: BoxFit.cover)),
//                         Positioned(
//                           top: 5,
//                           right: 5,
//                           child: GestureDetector(
//                             onTap: () => _removeImage(isFirstImage),
//                             child: CircleAvatar(
//                               backgroundColor: Colors.red,
//                               radius: 15,
//                               child: Icon(Icons.close, color: Colors.white, size: 20),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                     : Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700]),
//           ),
//         ),
//         SizedBox(height: 10),
//         Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }
// }

// class ReportVehicle extends StatelessWidget {
//   const ReportVehicle({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final postsCubit = context.read<PostsCubit>();

//     void pickFirstImage() async {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         postsCubit.setFirstCarImage(File(image.path));
//       }
//     }

//     void pickSecondImage() async {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         postsCubit.setSecondCarImage(File(image.path));
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text('الإبلاغ عن سيارة')),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: pickFirstImage,
//                       child: Container(
//                         height: 200,
//                         width: 200,
//                         color: ColorsManager.lighterGray,
//                         child:
//                             postsCubit.firstCarImage != null
//                                 ? Image.file(postsCubit.firstCarImage!, fit: BoxFit.cover)
//                                 : Icon(Icons.add_a_photo),
//                       ),
//                     ),
//                     Text('الصورة الاولى', style: TextStyles.font14DarkRegular),
//                   ],
//                 ),
//                 Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       onTap: pickSecondImage,
//                       child: Container(
//                         height: 200,
//                         width: 200,
//                         color: ColorsManager.lighterGray,
//                         child:
//                             postsCubit.secondCarImage != null
//                                 ? Image.file(postsCubit.secondCarImage!, fit: BoxFit.cover)
//                                 : Icon(Icons.add_a_photo),
//                       ),
//                     ),
//                     Text('الصورة الثانيه', style: TextStyles.font14DarkRegular),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
