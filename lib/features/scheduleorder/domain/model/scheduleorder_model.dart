// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';

class ScheduleorderModel {
  String? id;
  String? user_id;
  String? user_name;

  String? price;
  String? quantity;
  String? total;
  UserLocation? userLocation;
  String? pointsIncreaseUser;
  String? orderReceiptTime;
  String? status;
  String? finance;
  String? createdAt;
  List<OrderItemModel>? items;
  String? subTotal;
  String? total_price;

  List<MyorderModel>? orders;
  String? qr_url;
  String? qr_data_uri;
  BranchModel? branch;
  ScheduleorderModel({
    this.id,
    this.pointsIncreaseUser,
    this.orderReceiptTime,
    this.user_id,
    this.branch,
    this.user_name,
    this.price,
    this.quantity,
    this.total,
    this.userLocation,
    this.status,
    this.finance,
    this.createdAt,
    this.items,
    this.subTotal,
    this.total_price,
    this.orders,
    this.qr_url,
    this.qr_data_uri,
  });

  factory ScheduleorderModel.fromMap(Map<String, dynamic> order) {
    // final order = map["order"];
    return ScheduleorderModel(
      id: order['id']?.toString() ?? "",
      user_id: order['user_id']?.toString() ?? "",
      user_name: order['user_name']?.toString() ?? "",
      price: order['price']?.toString() ?? "",
      quantity: order['quantity']?.toString() ?? "",
      qr_data_uri: order['qr_data_uri']?.toString() ?? "",
      qr_url: order['qr_url']?.toString() ?? "",
      total: order['total']?.toString() ?? "",
      branch: BranchModel.fromMap(order['branch']),
      userLocation: order['user_location'] != null
          ? UserLocation.fromMap(order['user_location'])
          : null,
      status: order['status']?.toString() ?? "",
      finance: order['finance']?.toString() ?? "",
      createdAt: order['created_at']?.toString() ?? "",
      items: order['items'] != null
          ? List<OrderItemModel>.from(
              (order['items']).map<OrderItemModel?>(
                (x) => OrderItemModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      subTotal: order['sub_total']?.toString() ?? "",
      pointsIncreaseUser: order['points_increase_user']?.toString() ?? "",
      orderReceiptTime: order['order_receipt_time']?.toString() ?? "",
      total_price: order['total_price']?.toString() ?? "",
    );
  }
}

class PagingScheduleorderModel {
  int? page;

  List<ScheduleorderModel>? data;

  PagingScheduleorderModel({this.page, this.data});

  factory PagingScheduleorderModel.fromMap(Map<String, dynamic> map) {
    return PagingScheduleorderModel(
      page: map["pagination"]['lastPage'] != null
          ? map['pagination']["lastPage"] as int
          : null,
      data: map['data'] != null
          ? List<ScheduleorderModel>.from(
              (map['data'] as List).map<ScheduleorderModel?>(
                (x) => ScheduleorderModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory PagingScheduleorderModel.fromJson(String source) =>
      PagingScheduleorderModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
