// ignore_for_file: file_names
class PostCar {
  String? id;
  String? name;
  String? description;
  int? year;
  String? carTheftHistory;
  String? image;
  List<String> images; // جعلناها غير قابلة لأن تكون null

  String? location;
  String? phone;
  bool? isFound;
  String? userId;
  bool? what1;
  bool? what2;
  String? nameFound;
  String? phone2;
  String? locationName;
  bool? isLocation;
  String? tokinNotification;
  dynamic createdAt;

  PostCar({
    this.id,
    this.name,
    this.description,
    this.year,
    this.carTheftHistory,
    this.image,
    this.location,
    this.phone,
    this.isFound,
    this.userId,
    this.what1,
    this.what2,
    this.nameFound,
    this.phone2,
    this.locationName,
    this.isLocation,
    this.tokinNotification,
    this.createdAt,
    List<String>? images, // استقبال الصور كـ nullable
  }) : images = images ?? []; // تعيين قائمة فارغة في حالة null

  factory PostCar.fromJson(Map<String, dynamic> json) {
    return PostCar(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      year: json['year'],
      carTheftHistory: json['carTheftHistory'],
      image: json['image'],
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [], // ✅ تصحيح الخطأ هنا
      location: json['location'],
      phone: json['phone'],
      isFound: json['isFound'],
      userId: json['userId'],
      what1: json['what1'],
      what2: json['what2'],
      nameFound: json['nameFound'],
      phone2: json['phone2'],
      locationName: json['locationName'],
      isLocation: json['isLocation'],
      tokinNotification: json['tokinNotification'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'year': year,
      'carTheftHistory': carTheftHistory,
      'image': image,
      'images': images, // ✅ ستتم إعادتها كقائمة فارغة إذا لم يكن هناك صور
      'location': location,
      'phone': phone,
      'isFound': isFound,
      'userId': userId,
      'what1': what1,
      'what2': what2,
      'nameFound': nameFound,
      'phone2': phone2,
      'locationName': locationName,
      'isLocation': isLocation,
      'tokinNotification': tokinNotification,
      'createdAt': createdAt,
    };
  }
}

// class PostCar {
//   String? id;
//   String? name;
//   String? description;
//   int? year;
//   String? carTheftHistory;
//   String? image;
//   // List<String>? images;
//   List<String>? images; // قائمة صور

//   String? location;
//   String? phone;
//   bool? isFound;
//   String? userId;
//   bool? what1;
//   bool? what2;
//   String? nameFound;
//   String? phone2;
//   String? locationName;
//   bool? isLocation;
//   String? tokinNotification;
//   dynamic createdAt;

//   PostCar({
//     this.id,
//     this.name,
//     // this.images,
//     this.images,
//     this.description,
//     this.year,
//     this.carTheftHistory,
//     this.image,
//     this.location,
//     this.phone,
//     this.isFound,
//     this.userId,
//     this.what1,
//     this.what2,
//     this.nameFound,
//     this.phone2,
//     this.locationName,
//     this.isLocation,
//     this.tokinNotification,
//     this.createdAt,
//   });

//   PostCar.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     year = json['year'];
//     carTheftHistory = json['carTheftHistory'];
//     image = json['image'];
//     images:
//     (json['images'] as List<dynamic>?)?.map<String>((e) => e.toString()).toList() ?? [];

//     location = json['location'];
//     phone = json['phone'];
//     isFound = json['isFound'];
//     userId = json['userId'];
//     what1 = json['what1'];
//     what2 = json['what2'];
//     nameFound = json['nameFound'];
//     phone2 = json['phone2'];
//     locationName = json['locationName'];
//     isLocation = json['isLocation'];
//     tokinNotification = json['tokinNotification'];
//     createdAt = json['createdAt'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'year': year,
//       'carTheftHistory': carTheftHistory,
//       'image': image,
//       'images': images,
//       'location': location,
//       'phone': phone,
//       'isFound': isFound,
//       'userId': userId,
//       'what1': what1,
//       'what2': what2,
//       'nameFound': nameFound,
//       'phone2': phone2,
//       'locationName': locationName,
//       'isLocation': isLocation,
//       'tokinNotification': tokinNotification,
//       'createdAt': createdAt,
//     };
//   }
// }
// class PostCar {
//   String? id;
//   String? name;
//   String? description;
//   int? year;
//   String? carTheftHistory;
//   String? image;
//   String? location;
//   String? phone;
//   bool? isFound;
//   String? userId;

//   PostCar({
//     this.id,
//     this.name,
//     this.description,
//     this.year,
//     this.carTheftHistory,
//     this.image,
//     this.location,
//     this.phone,
//     this.isFound,
//     this.userId,
//   });

//   PostCar.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     year = json['year'];
//     carTheftHistory = json['carTheftHistory'];
//     image = json['image'];
//     location = json['location'];
//     phone = json['phone'];
//     isFound = json['isFound'];
//     userId = json['userId'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'year': year,
//       'carTheftHistory': carTheftHistory,
//       'image': image,
//       'location': location,
//       'phone': phone,
//       'isFound': isFound,
//       'userId': userId,
//     };
//   }
// }

// class PostCar {
//   String? id;
//   String? name;
//   String? title;
//   String? model;
//   String? color;
//   String? year;
//   String? image;

//   PostCar({this.id, this.name, this.title, this.model, this.color, this.year, this.image});

//   PostCar.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     title = json['title'];
//     model = json['model'];
//     color = json['color'];
//     year = json['year'];
//     image = json['image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['title'] = title;
//     data['model'] = model;
//     data['color'] = color;
//     data['year'] = year;
//     data['image'] = image;
//     return data;
//   }
// }
