class ProductFilter {
  String? categoryId;
  String? isTopRated;
  double? minPrice;
  double? maxPrice;
  String? heightsPoints;
  String? lowestFirst;
  String? search;
  String? isRecommended;
  String? heightsStars;
  String? fastDelivery;

  ProductFilter({
    this.categoryId,
    this.isTopRated,
    this.minPrice,
    this.maxPrice,
    this.heightsPoints,
    this.lowestFirst,
    this.isRecommended,
    this.heightsStars,
    this.search,
    this.fastDelivery,
  });
  bool isAllNull() {
    return categoryId == null &&
        isTopRated != "1" &&
        minPrice == null &&
        maxPrice == null &&
        heightsPoints != "1" &&
        lowestFirst != "1" &&
        isRecommended != "1" &&
        heightsStars != "1" &&
        fastDelivery != "1" &&
        (search?.trim().isEmpty ?? true);
  }

  Map<String, dynamic> toQuery({required int page}) {
    final map = <String, dynamic>{
      "page": page,
    };

    if (search != null) map['name'] = search.toString();
    if (categoryId != null) map['category_id'] = categoryId.toString();
    if (isTopRated != null) map['is_top_rated'] = isTopRated.toString();
    if (minPrice != null) map['min_price'] = minPrice.toString();
    if (maxPrice != null) map['max_price'] = maxPrice.toString();
    if (lowestFirst != null) map['lowest_first'] = lowestFirst.toString();
    if (heightsPoints != null) map['heights_points'] = heightsPoints.toString();
    if (heightsStars != null) map['heights_stars'] = heightsStars.toString();
    if (fastDelivery != null) map['fast_delivery'] = fastDelivery.toString();
    if (isRecommended != null) map['is_recommended'] = isRecommended.toString();

    return map;
  }

  ProductFilter copy() {
    return ProductFilter(
      categoryId: categoryId,
      isTopRated: isTopRated,
      minPrice: minPrice,
      maxPrice: maxPrice,
      heightsPoints: heightsPoints,
      heightsStars: heightsStars,
      fastDelivery: fastDelivery,
      lowestFirst: lowestFirst,
      isRecommended: isRecommended,
      search: search,
    );
  }

  String toQueryString({required int page}) {
    return toQuery(page: page)
        .entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
  }
}
