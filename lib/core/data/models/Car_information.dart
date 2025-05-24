// ignore_for_file: file_names
class PostCar {
  String? id;
  String? timestamp;
  String? name;
  String? typeCar;
  String? model;
  String? color;
  String? chassisNumber;
  String? plateNumber;
  String? image;
  String? dateOfCarLoss;

  List<String> images;

  String? city;
  String? neighborhood;
  String? street;

String? note;
  String? description;
  String? carTheftHistory;

  String? nameOwner;
  String? userId;
  String? tokinNotification;

  String? phone;
  bool? isWhatsapp;

  String? phone2;
  bool? isWhatsapp2;

  bool? stolen;
  String? carSize;

  PostCar({
    this.id,
    this.timestamp,
    this.name,
    this.typeCar,
    this.model,
    this.color,
    this.chassisNumber,
    this.plateNumber,
    this.dateOfCarLoss,
    this.image,
    this.images = const [],
    this.city,
    this.neighborhood,
    this.street,
    this.description,
    this.carTheftHistory,
    this.nameOwner,
    this.userId,
    this.carSize,
    this.note,
    this.tokinNotification,
    this.phone,
    this.isWhatsapp,
    this.phone2,
    this.isWhatsapp2,
    this.stolen,
  });

  // 🔹 **تحويل البيانات من Firestore إلى كائن `PostCar`**
  factory PostCar.fromMap(Map<String, dynamic> data, String documentId) {
    return PostCar(
      id: documentId,
      name: data['name'] ?? '',

      timestamp: data['timestamp'] ?? '',
      typeCar: data['typeCar'] ?? '',
      dateOfCarLoss: data['dateOfCarLoss'] ?? '',
      model: data['model'] ?? '',
      carSize: data['carSize'] ?? '',
      note: data['note'] ?? '',
      color: data['color'] ?? '',
      chassisNumber: data['chassisNumber'] ?? '',
      plateNumber: data['plateNumber'] ?? '',
      image: data['image'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      city: data['city'] ?? '',
      neighborhood: data['neighborhood'] ?? '',
      street: data['street'] ?? '',
      description: data['description'] ?? '',
      carTheftHistory: data['carTheftHistory'] ?? '',
      nameOwner: data['nameOwner'] ?? '',
      userId: data['userId'] ?? '',
      tokinNotification: data['tokinNotification'] ?? '',
      phone: data['phone'] ?? '',
      isWhatsapp: data['isWhatsapp'] ?? false,
      phone2: data['phone2'] ?? '',
      isWhatsapp2: data['isWhatsapp2'] ?? false,
      stolen: data['stolen'] ?? false,
    );
  }

  // 🔹 **تحويل الكائن إلى `Map<String, dynamic>` لحفظه في Firestore**
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'timestamp': timestamp,
      'typeCar': typeCar,
      'model': model,
      'color': color,
      'chassisNumber': chassisNumber,
      'plateNumber': plateNumber,
      'image': image,
      'images': images,
      'dateOfCarLoss': dateOfCarLoss,
      'city': city,
      'neighborhood': neighborhood,
      'street': street,
      'note': note,
      'description': description,
      'carSize': carSize,
      'carTheftHistory': carTheftHistory,
      'nameOwner': nameOwner,
      'userId': userId,
      'tokinNotification': tokinNotification,
      'phone': phone,
      'isWhatsapp': isWhatsapp ?? false,
      'phone2': phone2,
      'isWhatsapp2': isWhatsapp2 ?? false,
      'stolen': stolen ?? false,
    };
  }

  // 🔹 **دالة `copyWith` لتحديث بيانات الكائن بسهولة**
  PostCar copyWith({
    String? id,
    String? name,
    String? timestamp,
    String? typeCar,
    String? model,
    String? color,
    String? chassisNumber,
    String? plateNumber,
    String? image,
    List<String>? images,
    String? city,
    String? neighborhood,
    String? street,
    String? description,
    String? dateOfCarLoss,
    String? carTheftHistory,
    String? carSize,
    String? nameOwner,
    String? userId,
    String? tokinNotification,
    String? phone,
    String? note,
    bool? isWhatsapp,
    String? phone2,
    bool? isWhatsapp2,
    bool? stolen,
  }) {
    return PostCar(
      id: id ?? this.id,
      name: name ?? this.name,
      timestamp: timestamp ?? this.timestamp,
      typeCar: typeCar ?? this.typeCar,
      model: model ?? this.model,
      color: color ?? this.color,
      dateOfCarLoss: dateOfCarLoss ?? this.dateOfCarLoss,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      plateNumber: plateNumber ?? this.plateNumber,
      image: image ?? this.image,
      images: images ?? this.images,
      carSize: carSize ?? this.carSize,
      city: city ?? this.city,
      note: note ?? this.note,
      neighborhood: neighborhood ?? this.neighborhood,
      street: street ?? this.street,
      description: description ?? this.description,
      carTheftHistory: carTheftHistory ?? this.carTheftHistory,
      nameOwner: nameOwner ?? this.nameOwner,
      userId: userId ?? this.userId,
      tokinNotification: tokinNotification ?? this.tokinNotification,
      phone: phone ?? this.phone,
      isWhatsapp: isWhatsapp ?? this.isWhatsapp,
      phone2: phone2 ?? this.phone2,
      isWhatsapp2: isWhatsapp2 ?? this.isWhatsapp2,
      stolen: stolen ?? this.stolen,
    );
  }
}

// 🔹 **دالة `fromJson` لتحويل البيانات من JSON إلى كائن `PostCar`*
//
