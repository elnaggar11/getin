class Item {
  String? productName;
  int? quantity;
  String? starsTotal;

  Item({this.productName, this.quantity, this.starsTotal});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productName: json['product_name'] as String?,
        quantity: json['quantity'] as int?,
        starsTotal: json['stars_total']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'product_name': productName,
        'quantity': quantity,
        'stars_total': starsTotal,
      };
}
