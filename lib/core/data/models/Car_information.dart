// ignore_for_file: file_names

class PostCar {
  String? id;
  String? name;
  String? title;
  String? model;
  String? color;
  String? year;
  String? image;

  PostCar({this.id, this.name, this.title, this.model, this.color, this.year, this.image});

  PostCar.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    model = json['model'];
    color = json['color'];
    year = json['year'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['title'] = title;
    data['model'] = model;
    data['color'] = color;
    data['year'] = year;
    data['image'] = image;
    return data;
  }
}
