// ignore_for_file: public_member_api_docs, sort_constructors_first

class ScheduleorderRequest {
  String? orderType;
  String? branchId;
  String? scheduleTime;
  String? userLocationId;
  String? userPaymentId;
  String? payWith; // 'points' or 'money'
  List<String>? productIds;
  List<String>? productsQuantity;
  List<List<String>>? productOptionValues;

  ScheduleorderRequest({
    this.orderType,
    this.branchId,
    this.scheduleTime,
    this.userLocationId,
    this.userPaymentId,
    this.payWith = 'money',
    this.productIds,
    this.productsQuantity,
    this.productOptionValues,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'order_type': orderType,
      'branch_id': branchId,
      'schedual_date':
          // "2025-11-20",
          scheduleTime,
      'user_location_id': userLocationId,
      'payment_method': userPaymentId,
      'pay_with': payWith ?? 'money',
    };
    final ids = productIds ?? [];
    final quantities = productsQuantity ?? [];
    // final optionValues = ProductsoptionValues ?? [];

    for (int i = 0; i < ids.length; i++) {
      data['products[$i][id]'] = ids[i];
      if (i < quantities.length) {
        data['products[$i][quantity]'] = quantities[i];
      }
      if (productOptionValues?[i] != null) {
        for (int index = 0; index < productOptionValues![i].length; index++) {
          data['products[$i][option_value_ids][$index]'] =
              productOptionValues![i][index];
        }
      }
    }

    return data;
  }

  ScheduleorderRequest copyWith({
    String? orderType,
    String? branchId,
    String? scheduleTime,
    String? userLocationId,
    String? userPaymentId,
    String? payWith,
    List<String>? productIds,
    List<String>? productsQuantity,
    List<List<String>>? productOptionValues,
  }) {
    return ScheduleorderRequest(
      orderType: orderType ?? this.orderType,
      branchId: branchId ?? this.branchId,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      userLocationId: userLocationId ?? this.userLocationId,
      userPaymentId: userPaymentId ?? this.userPaymentId,
      payWith: payWith ?? this.payWith,
      productIds: productIds ?? this.productIds,
      productsQuantity: productsQuantity ?? this.productsQuantity,
      productOptionValues: productOptionValues ?? this.productOptionValues,
    );
  }
}
