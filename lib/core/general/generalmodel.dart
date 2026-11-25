import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GeneralModel {
  String? id;
  String? image;
  String? name;
  GeneralModel({
    this.id,
    this.image,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
    };
  }

  factory GeneralModel.fromMap(Map<String, dynamic> map) {
    return GeneralModel(
      id: map['id']?.toString() ?? "",
      image: map['image']?.toString() ?? "",
      name: map['name']?.toString() ?? map['title']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory GeneralModel.fromJson(String source) =>
      GeneralModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
