// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:getincoffee/features/home/domain/model/home_model.dart';

class CartModel {
  String? id;
  List<ItemModel>? items;
  String? total;
  String? totalPrice;
  String? itemsCount;
  String? subTotal;
  String? deliveryCharge;
  bool? isDelivery;

  String? tax;
  String? descriptionText;

  int get totalQuantity {
    int total = 0;
    if (items != null) {
      for (var item in items!) {
        total += int.tryParse(item.quantity ?? "0") ?? 0;
      }
    }
    return total;
  }

  CartModel({
    this.id,
    this.items,
    this.total,
    this.itemsCount,
    this.isDelivery,
    this.totalPrice,
    this.subTotal,
    this.deliveryCharge,
    this.tax,
    this.descriptionText,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    var deliveryval = map['is_delivery'] ?? map['is_delivery '];
    bool? isDelivery = deliveryval == "1" ||
        deliveryval == 1 ||
        deliveryval == true ||
        deliveryval == "true" ||
        deliveryval == null;
    // isDelivery = true;
    return CartModel(
      id: map['id']?.toString() ?? "",
      items: map['items'] != null
          ? List<ItemModel>.from(
              (map['items']).map<ItemModel?>(
                (x) => ItemModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      total: map['total']?.toString() ?? "",
      totalPrice: (map['total_price'] ?? map['sub_total'])?.toString() ?? "",
      itemsCount: map['items_count']?.toString() ?? "",
      subTotal: map['sub_total']?.toString() ?? "",
      deliveryCharge: map['delivery_charge']?.toString() ?? "",
      tax: map['tax']?.toString() ?? "",
      isDelivery: isDelivery,
      descriptionText: map['description_text']?.toString(),
    );
  }

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ItemModel {
  String? id;
  String? cartId;
  String? branchId;
  String? productId;
  String? quantity;
  String? totalPrice;
  ProductModel? product;

  ItemModel({
    this.id,
    this.cartId,
    this.productId,
    this.branchId,
    this.quantity,
    this.totalPrice,
    this.product,
  });

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id']?.toString() ?? "",
      cartId: map['cart_id']?.toString() ?? "",
      branchId: map['branch_id']?.toString() ?? "",
      productId: map['product_id']?.toString() ?? "",
      quantity: map['quantity']?.toString() ?? "",
      totalPrice: map['total_price']?.toString() ?? "",
      product: map['product'] != null
          ? ProductModel.fromMap(map['product'] as Map<String, dynamic>)
          : null,
    );
  }

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
