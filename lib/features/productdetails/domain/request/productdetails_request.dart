import 'dart:convert';

import 'package:getincoffee/features/home/domain/model/home_model.dart';

class ProductdetailsRequest {}

class AddtoCartRequest {
  String? productId;
  String? quantity;
  String? branchId;
  ProductModel? product;

  List<String>? optionValueIds;
  AddtoCartRequest({
    this.productId,
    this.quantity,
    this.branchId,
    this.optionValueIds,
    this.product,
  });

  Map<String, dynamic> toMap() {
    print(optionValueIds?.length ?? 0);
    var temp = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
      'branch_id': branchId,
    };
    int index = 0;
    for (int i = 0; i < (optionValueIds?.length ?? 0); i++) {
      if (optionValueIds![i].isNotEmpty) {
        temp['option_value_ids[$index]'] = optionValueIds![i];
        index++;
      }
    }
    return temp;
  }

  num get totalPrice {
    final basePrice = double.tryParse(product?.getPrice() ?? '0') ?? 0;
    return basePrice + extraTotal;
  }

  num getOriginalPrice() {
    final basePrice = double.tryParse(product?.getOriginalPrice() ?? '0') ?? 0;
    return basePrice + extraTotal;
  }

  num get extraTotal {
    num extraTotal = 0;

    final allValues =
        product?.options?.expand((option) => option.values ?? []).toList() ??
            [];

    for (final id in optionValueIds ?? []) {
      if (id.isEmpty) continue;
      final matched = allValues.where((v) => v.id == id).firstOrNull;
      if (matched != null) {
        extraTotal += double.tryParse(matched.extraPrice ?? '0') ?? 0;
      }
    }

    return extraTotal;
  }

  String toJson() => json.encode(toMap());
}
