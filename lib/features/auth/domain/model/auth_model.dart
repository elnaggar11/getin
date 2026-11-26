import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? image;
  String? totalPoints;
  String? totalStars;
  String? typeDelivery;
  String? accessToken;
  bool? isReviewAccount;
  List<String>? allowedPaymentMethods;

  bool get shouldHideCardPayment =>
      isReviewAccount == true ||
      (allowedPaymentMethods != null &&
          !allowedPaymentMethods!.contains('money'));

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.image,
    this.totalPoints,
    this.totalStars,
    this.typeDelivery,
    this.accessToken,
    this.isReviewAccount,
    this.allowedPaymentMethods,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phone,
      'image': image,
      'type_delivery': typeDelivery,
      'total_points': totalPoints,
      'total_stars': totalStars,
      'access_token': accessToken,
      'is_review_account': isReviewAccount,
      'allowed_payment_methods': allowedPaymentMethods,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final userData = map['user'] is Map
        ? Map<String, dynamic>.from(map['user'] as Map)
        : map;
    final methods =
        userData['allowed_payment_methods'] ?? map['allowed_payment_methods'];
    final rawReviewFlag =
        userData['is_review_account'] ?? map['is_review_account'];
    return UserModel(
      id: userData['id']?.toString() ?? '',
      typeDelivery: userData['type_delivery']?.toString() ?? "",
      firstName: userData['first_name']?.toString() ?? '',
      lastName: userData['last_name']?.toString() ?? '',
      phone: userData['phone_number']?.toString() ?? '',
      image: userData['image']?.toString() ?? "",
      totalPoints: userData['total_points']?.toString() ?? "",
      totalStars: userData['total_stars']?.toString() ?? "",
      accessToken: map['access_token']?.toString() ??
          userData['access_token']?.toString() ??
          "",
      isReviewAccount: rawReviewFlag is bool
          ? rawReviewFlag
          : rawReviewFlag == 1 ||
              rawReviewFlag == '1' ||
              rawReviewFlag?.toString().toLowerCase() == 'true',
      allowedPaymentMethods: methods is List
          ? methods.map((method) => method.toString()).toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
