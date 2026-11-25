// import 'dart:convert';

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// class PointModel {
//   String? points;
//   String? order_id;
//   String? created_at;
//   String? product_name;
//   ItemPointModel? item;
//   List<order>? orders;
//   PointModel({
//     this.order_id,
//     this.points,
//     this.orders,
//     this.created_at,
//     this.product_name,
//     this.item,
//   });

//   factory PointModel.fromMap(Map<String, dynamic> map) {
//     return PointModel(
//       order_id: map['order_id']?.toString() ?? "",
//       created_at:
//           map['created_at'] != null ? map['created_at'] as String : null,
//       product_name:
//           map['product_name'] != null ? map['product_name'] as String : null,
//       item: map['item'] != null
//           ? ItemPointModel.fromMap(map['item'] as Map<String, dynamic>)
//           : null,
//     );
//   }

//   PointModel.allpoints(Map<String, dynamic> map) {
//     orders = map['orders'] != null
//         ? List<PointModel>.from((map['orders'] as List)
//             .map((e) => PointModel.fromMap(e as Map<String, dynamic>)))
//         : null;
//     points = map['points'].toString();
//   }

//   factory PointModel.fromJson(String source) =>
//       PointModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }

// class ItemPointModel {
//   String? product_name;
//   String? quantity;
//   String? stars_total;
//   ItemPointModel({
//     this.product_name,
//     this.quantity,
//     this.stars_total,
//   });

//   factory ItemPointModel.fromMap(Map<String, dynamic> map) {
//     return ItemPointModel(
//       product_name:
//           map['product_name'] != null ? map['product_name'] as String : null,
//       quantity: map['quantity']?.toString(),
//       stars_total: map['stars_total']?.toString(),
//     );
//   }

//   factory ItemPointModel.fromJson(String source) =>
//       ItemPointModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }

import 'package:getincoffee/features/mypoints/domain/model/my_star_model/order.dart';

class Mypoints {
  int? points;
  List<StarOrder>? starpoints;

  Mypoints({
    this.points,
    this.starpoints,
  });

  Mypoints.fromJson(Map<String, dynamic> json) {
    points = json['points'] as int?;
    if (json['orders'] != null) {
      starpoints = <StarOrder>[];
      json['orders'].forEach((v) {
        starpoints!.add(StarOrder.frompoints(v));
      });
    }
  }
}
