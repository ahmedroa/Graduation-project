// import 'package:cloud_firestore/cloud_firestore.dart';

// class CarModel {
//   final String title;
//   final String description;
//   final String image;
//   final String model;
//   final String carLocation;
//   final int carYear;
//   final String carColor;
//   final DateTime createdAt;

//   CarModel({
//     required this.title,
//     required this.description,
//     required this.image,
//     required this.model,
//     required this.carLocation,
//     required this.carYear,
//     required this.carColor,
//     required this.createdAt,
//   });

//   factory CarModel.fromJson(Map<String, dynamic> json) {
//     return CarModel(
//       title: json['title'] as String,
//       description: json['description'] as String,
//       image: json['image'] as String,
//       model: json['model'] as String,
//       carLocation: json['carLocation'] as String,
//       carYear: json['carYear'] as int,
//       carColor: json['carColor'] as String,
//       createdAt: (json['createdAt'] as Timestamp).toDate(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       'image': image,
//       'model': model,
//       'carLocation': carLocation,
//       'carYear': carYear,
//       'carColor': carColor,
//       'createdAt': createdAt,
//     };
//   }
// }
