import 'item.dart';

class StarOrder {
  int? orderId;
  String? createdAt;
  String? productName;
//  List<Item>? items;
  Item? item;
  StarOrder({
    this.orderId,
    this.createdAt,
    this.productName,
    // this.items,
    this.item,
  });

  factory StarOrder.fromJson(Map<String, dynamic> json) => StarOrder(
        orderId: json['order_id'] as int?,
        createdAt: json['created_at'] as String?,
        productName: json['product_name'] as String?,
        item: json['item'] != null
            ? Item.fromJson(json['item'] as Map<String, dynamic>)
            : null,
        /*     items: (json['items'] as List<dynamic>?)
            ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
            .toList(), */
      );
  factory StarOrder.frompoints(Map<String, dynamic> json) => StarOrder(
        orderId: json['order_id'] as int?,
        createdAt:
            json['created_at'] != null ? json['created_at'] as String : null,
        productName: json['product_name'] != null
            ? json['product_name'] as String
            : null,
        item: json['item'] != null
            ? Item.fromJson(json['item'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        'created_at': createdAt,
        'product_name': productName,
        // 'items': items?.map((e) => e.toJson()).toList(),
      };
}
