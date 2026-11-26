class EditProfileModel {
  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String countryKey;
  int totalPoints;
  int totalStars;
  String image;
  bool? isReviewAccount;
  List<String>? allowedPaymentMethods;

  EditProfileModel({
    required this.id,
    required this.firstName,
    required this.countryKey,
    required this.lastName,
    required this.phoneNumber,
    required this.totalPoints,
    required this.totalStars,
    required this.image,
    this.isReviewAccount,
    this.allowedPaymentMethods,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    final rawReviewFlag = json['is_review_account'];
    final methods = json['allowed_payment_methods'];
    return EditProfileModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      countryKey: json['country_key'],
      phoneNumber: json['phone_number'],
      totalPoints: json['total_points'],
      totalStars: json['total_stars'],
      image: json['image'],
      isReviewAccount: rawReviewFlag == null
          ? null
          : rawReviewFlag is bool
              ? rawReviewFlag
              : rawReviewFlag == 1 ||
                  rawReviewFlag == '1' ||
                  rawReviewFlag.toString().toLowerCase() == 'true',
      allowedPaymentMethods: methods is List
          ? methods.map((method) => method.toString()).toList()
          : null,
    );
  }
}
