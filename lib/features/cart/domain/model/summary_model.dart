class SummaryModel {
  final num itemTotal;
  final num subtotal;
  final num discount;
  final num deliveryCharge;
  final num tax;
  final num total;
  final num totalPriceWithPoints;
  final String descriptionDelivery;
  final bool allowPointsPayment;

  SummaryModel({
    required this.itemTotal,
    required this.discount,
    required this.deliveryCharge,
    required this.tax,
    required this.total,
    required this.totalPriceWithPoints,
    required this.descriptionDelivery,
    required this.subtotal,
    required this.allowPointsPayment,
  });

  factory SummaryModel.fromMap(Map<String, dynamic> map) {
    double asDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    var allowPointsPayment = map['allow_points_payment'] == 1 ||
        map['allow_points_payment'] == '1' ||
        map['allow_points_payment'] == true;
    return SummaryModel(
      itemTotal: asDouble(map['item_total']),
      discount: asDouble(map['discount']),
      deliveryCharge: asDouble(map['delivery_charge']),
      tax: asDouble(map['tax']),
      total: asDouble(map['total']),
      totalPriceWithPoints: asDouble(map['total_price_with_points']),
      descriptionDelivery: map['description_delivery'] ?? "",
      subtotal: asDouble(map['subtotal']),
      allowPointsPayment: allowPointsPayment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_total': itemTotal,
      'discount': discount,
      'delivery_charge': deliveryCharge,
      'tax': tax,
      'total': total,
    };
  }

  SummaryModel copyWith({
    num? itemTotal,
    num? discount,
    num? deliveryCharge,
    num? tax,
    num? total,
    num? totalPriceWithPoints,
    String? descriptionDelivery,
    num? subtotal,
    bool? allowPointsPayment,
  }) {
    num currentDiscount = (discount ?? 0) + this.discount;
    return SummaryModel(
      itemTotal: itemTotal ?? this.itemTotal,
      discount: discount ?? this.discount,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      tax: tax ?? this.tax,
      allowPointsPayment: allowPointsPayment ?? this.allowPointsPayment,
      total: total != null
          ? (total - currentDiscount)
          : (this.total - currentDiscount),
      totalPriceWithPoints: totalPriceWithPoints ?? this.totalPriceWithPoints,
      descriptionDelivery: descriptionDelivery ?? this.descriptionDelivery,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
