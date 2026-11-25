class SupportModel {
  final int? id;
  final String? title;
  final String? description;
  final String? phoneNumber;

  SupportModel({
    this.id,
    this.title,
    this.description,
    this.phoneNumber,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      phoneNumber: json['phone_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'phone_number': phoneNumber,
    };
  }
}
