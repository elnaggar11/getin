import 'package:equatable/equatable.dart';

class CouponModel extends Equatable {
  final int? id;
  final String? name;
  final String? code;
  final String? type;
  final String? value;
  final String? startDate;
  final String? endDate;
  final int? usageLimit;
  final int? used;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? branchId;

  const CouponModel({
    this.id,
    this.name,
    this.code,
    this.type,
    this.value,
    this.startDate,
    this.endDate,
    this.usageLimit,
    this.used,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.branchId,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      code: json['code'] as String?,
      type: json['type'] as String?,
      value: json['value']?.toString(),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      usageLimit: json['usage_limit'] as int?,
      used: json['used'] as int?,
      isActive: json['is_active'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      branchId: json['branch_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'type': type,
        'value': value,
        'start_date': startDate,
        'end_date': endDate,
        'usage_limit': usageLimit,
        'used': used,
        'is_active': isActive,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'branch_id': branchId,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        type,
        value,
        startDate,
        endDate,
        usageLimit,
        used,
        isActive,
        createdAt,
        updatedAt,
      ];
}

class CouponsResponse {
  final bool status;
  final String message;
  final List<CouponModel> data;

  const CouponsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CouponsResponse.fromJson(Map<String, dynamic> json) {
    return CouponsResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => CouponModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
