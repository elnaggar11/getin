class EditProfileModel {
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String countryKey;
  int totalPoints;
  int totalStars;
  String image;

  EditProfileModel({
    required this.id,
    required this.firstName,
    required this.countryKey,
    required this.lastName,
    required this.phoneNumber,
    required this.totalPoints,
    required this.totalStars,
    required this.image,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      countryKey: json['country_key'],
      phoneNumber: json['phone_number'],
      totalPoints: json['total_points'],
      totalStars: json['total_stars'],
      image: json['image'],
    );
  }
}
