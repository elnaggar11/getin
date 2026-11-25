class HomeRequest {}

class ProductParams {
  String? name;
  String? category_id;
  String? is_new;
  String? is_top_rated;
  String? min_price;
  String? max_price;

  ProductParams({
    this.name,
    this.category_id,
    this.is_new,
    this.is_top_rated,
    this.min_price,
    this.max_price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'category_id': category_id,
      'is_new': is_new,
      'is_top_rated': is_top_rated,
      'min_price': min_price,
      'max_price': max_price,
    }..removeWhere((s, val) {
        return val == null;
      });
  }
}
