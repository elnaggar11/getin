import 'datum.dart';

class AddressesModel {
  bool? status;
  String? message;
  List<AddresseData>? data;

  AddressesModel({this.status, this.message, this.data});

  factory AddressesModel.fromJson(Map<String, dynamic> json) {
    return AddressesModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AddresseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
