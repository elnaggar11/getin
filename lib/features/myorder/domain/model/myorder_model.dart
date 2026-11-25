import 'dart:convert';

import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/myorder/domain/model/single_order_status.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MyorderModel {
  String? id;
  String? user_id;
  String? user_name;
  String? price;
  String? quantity;
  String? total;
  UserLocation? user_location;
  BranchModel? branch;
  String? status;
  String? finance;
  String? createdAt;
  String? pointsIncreaseUser;
  String? orderReceiptTime;
  List<OrderItemModel>? items;
  String? subTotal;
  String? totalPrice;
  List<MyorderModel>? orders;
  String? qrUrl;
  String? qrDataUri;
  Driver? driver;
  bool? isRated;

  MyorderModel({
    this.id,
    this.user_id,
    this.user_name,
    this.price,
    this.quantity,
    this.total,
    this.isRated,
    this.branch,
    this.user_location,
    this.status,
    this.finance,
    this.createdAt,
    this.pointsIncreaseUser,
    this.orderReceiptTime,
    this.items,
    this.subTotal,
    this.totalPrice,
    this.orders,
    this.qrUrl,
    this.qrDataUri,
    this.driver,
  });

  factory MyorderModel.fromMap(Map<String, dynamic> map) {
    var isRated = (map['is_rated'] == "1" ||
        map['is_rated'] == true ||
        map['is_rated'] == 1);
    return MyorderModel(
      isRated: isRated,
      id: map['id']?.toString() ?? "",
      user_id: map['user_id']?.toString() ?? "",
      user_name: map['user_name']?.toString() ?? "",
      price: map['price']?.toString() ?? "",
      quantity: map['quantity']?.toString() ?? "",
      qrDataUri: map['qr_data_uri']?.toString() ?? "",
      qrUrl: map['qr_url']?.toString() ?? "",
      createdAt: map['created_at']?.toString() ?? "",
      pointsIncreaseUser: map['points_increase_user']?.toString() ?? "",
      orderReceiptTime: map['order_receipt_time']?.toString() ?? "",
      total: map['total']?.toString() ?? "",
      user_location: map['user_location'] != null
          ? UserLocation.fromMap(map['user_location'])
          : null,
      status: map['status']?.toString() ?? "",
      finance: map['finance']?.toString() ?? "",
      items: map['items'] != null
          ? List<OrderItemModel>.from(
              (map['items']).map<OrderItemModel?>(
                (x) => OrderItemModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      branch: map['branch'] != null ? BranchModel.fromMap(map['branch']) : null,
      subTotal: map['sub_total']?.toString() ?? "",
      totalPrice: map['total_price']?.toString() ?? "",
      driver: map['driver'] != null ? Driver.fromMap(map['driver']) : null,
    );
  }

  MyorderModel.allorders(Map<String, dynamic> map) {
    orders = List.from(
      (map["data"]).map((e) => MyorderModel.fromMap(e)).toList(),
    );
  }

  factory MyorderModel.fromJson(String source) =>
      MyorderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MyorderModel(id: $id, user_id: $user_id, user_name: $user_name, price: $price, quantity: $quantity, qrDataUri: $qrDataUri, qrUrl: $qrUrl, createdAt: $createdAt, pointsIncreaseUser: $pointsIncreaseUser, orderReceiptTime: $orderReceiptTime, total: $total, user_location: $user_location, status: $status, finance: $finance, items: $items, subTotal: $subTotal, totalPrice: $totalPrice, driver: $driver)';
  }
}

class SingleOrderModel {
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
  String? previousStatus;
  SingleOrderStatus? singleOrderStatus;
  String? finance;
  String? createdAt;
  List<OrderItemModel>? items;
  String? subTotal;
  String? total_price;
  BranchModel? branch;
  Driver? driver;

  List<MyorderModel>? orders;
  String? qr_url;
  String? qr_data_uri;
  SingleOrderModel({
    this.id,
    this.pointsIncreaseUser,
    this.orderReceiptTime,
    this.user_id,
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
    this.singleOrderStatus,
    this.total_price,
    this.orders,
    this.qr_url,
    this.previousStatus,
    this.qr_data_uri,
    this.driver,
    this.branch,
  });

  factory SingleOrderModel.fromMap(Map<String, dynamic> map) {
    final order = map["order"];
    return SingleOrderModel(
      id: order['id']?.toString() ?? "",
      user_id: order['user_id']?.toString() ?? "",
      user_name: order['user_name']?.toString() ?? "",
      price: order['price']?.toString() ?? "",
      quantity: order['quantity']?.toString() ?? "",
      qr_data_uri: map['qr_data_uri']?.toString() ?? "",
      qr_url: map['qr_url']?.toString() ?? "",
      total: order['total']?.toString() ?? "",
      userLocation: order['user_location'] != null
          ? UserLocation.fromMap(order['user_location'])
          : null,
      status: order['status']?.toString() ?? "",
      previousStatus: order['last_status']?.toString() ?? "",
      singleOrderStatus: SingleOrderStatusMapper.fromApi(order['status'] ?? ""),
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
      driver: order['driver'] != null ? Driver.fromMap(order['driver']) : null,
      branch:
          order['branch'] != null ? BranchModel.fromMap(order['branch']) : null,
    );
  }
  SingleOrderStatus? get lastStatus {
    if (previousStatus != null && previousStatus!.isNotEmpty) {
      return SingleOrderStatusMapper.fromApi(previousStatus!);
    }
    return null;
  }
}

class UserLocation {
  String? id;
  String? name_address;
  String? building_number;
  String? floor;
  String? apartment;
  String? address_description;
  String? address_title;
  String? latitude;
  String? longitude;
  String? first_name;
  String? last_name;
  String? phone_number;
  UserLocation({
    this.id,
    this.name_address,
    this.building_number,
    this.floor,
    this.apartment,
    this.address_description,
    this.address_title,
    this.latitude,
    this.longitude,
    this.first_name,
    this.last_name,
    this.phone_number,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name_address': name_address,
      'building_number': building_number,
      'floor': floor,
      'apartment': apartment,
      'address_description': address_description,
      'address_title': address_title,
      'latitude': latitude,
      'longitude': longitude,
      'first_name': first_name,
      'last_name': last_name,
      'phone_number': phone_number,
    };
  }

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      id: map['id']?.toString(),
      name_address: map['name_address']?.toString(),
      building_number: map['building_number']?.toString(),
      floor: map['floor'] != null ? map['floor'] as String : null,
      apartment: map['apartment'] != null ? map['apartment'] as String : null,
      address_description: map['address_description']?.toString(),
      address_title: map['address_title']?.toString(),
      latitude: map['latitude']?.toString(),
      longitude: map['longitude']?.toString(),
      first_name: map['first_name']?.toString(),
      last_name: map['last_name']?.toString(),
      phone_number: map['phone_number']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLocation.fromJson(String source) =>
      UserLocation.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OrderItemModel {
  String? id;
  String? product_id;
  String? product_name;
  String? product_image;
  String? product_desc;
  String? quantity;
  String? image;
  String? ratingAvg;
  String? total_price;
  double? userRate;
  List<OptionOrderItemModel>? options;
  OrderItemModel({
    this.id,
    this.product_id,
    this.image,
    this.product_name,
    this.quantity,
    this.total_price,
    this.product_image,
    this.product_desc,
    this.ratingAvg,
    this.options,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id']?.toString() ?? "",
      product_id: map['product_id']?.toString() ?? "",
      image: map["image"]?.toString(),
      product_name: map['product_name']?.toString() ?? "",
      quantity: map['quantity']?.toString() ?? "",
      ratingAvg: map['rating_avg']?.toString(),
      total_price: map['total_price']?.toString() ?? "",
      product_image: map['product_image']?.toString(),
      product_desc: map['product_desc']?.toString(),
      options: map['options'] != null
          ? List<OptionOrderItemModel>.from(
              (map['options']).map<OptionOrderItemModel?>(
                (x) => OptionOrderItemModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory OrderItemModel.fromJson(String source) =>
      OrderItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OptionOrderItemModel {
  String? id;
  String? value;
  String? extra_price;
  OptionOrderItemModel({
    this.id,
    this.value,
    this.extra_price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'value': value,
      'extra_price': extra_price,
    };
  }

  factory OptionOrderItemModel.fromMap(Map<String, dynamic> map) {
    return OptionOrderItemModel(
      id: map['id']?.toString(),
      value: map['value']?.toString(),
      extra_price: map['extra_price']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory OptionOrderItemModel.fromJson(String source) =>
      OptionOrderItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Driver {
  String? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? image;
  num? range;
  num? totalOrdersCompleted;
  num? totalPoints;
  num? totalStars;

  Driver({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.image,
    this.range,
    this.totalOrdersCompleted,
    this.totalPoints,
    this.totalStars,
  });

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id']?.toString(),
      firstName: map['first_name']?.toString(),
      lastName: map['last_name']?.toString(),
      phoneNumber: map['phone_number']?.toString(),
      image: map['image']?.toString(),
      range: map['range'],
      totalOrdersCompleted: map['total_orders_completed'],
      totalPoints: map['total_points'],
      totalStars: map['total_stars'],
    );
  }

  factory Driver.fromJson(String source) =>
      Driver.fromMap(json.decode(source) as Map<String, dynamic>);
}
