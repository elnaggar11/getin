import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';

class PagedProducts {
  List<ProductModel>? products;
  int? branchId;
  int? lastPage;
  PagedProducts({
    this.products,
    this.branchId,
    this.lastPage,
  });

  factory PagedProducts.fromMap(Map<String, dynamic> map) {
    return PagedProducts(
      products: map["data"]["products"] != null
          ? List<ProductModel>.from(
              (map["data"]["products"]).map<ProductModel?>(
                (x) => ProductModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      branchId: map["data"]["branch_id"] != null
          ? map["data"]["branch_id"] as int
          : null,
      lastPage: map["pagination"]['last_page'] != null
          ? map["pagination"]['last_page'] as int
          : 1,
    );
  }
  factory PagedProducts.fromOneMap(Map<String, dynamic> map) {
    return PagedProducts(
      products: map["data"] != null
          ? List<ProductModel>.from(
              (map["data"]).map<ProductModel?>(
                (x) => ProductModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      branchId: null,
      lastPage: map["pagination"]?["lastPage"] ?? 1,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BranchModel {
  String? id;
  String? name;
  String? description;
  String? code;
  String? distance;
  String? image;
  List<String>? images;
  String? openingDate;
  String? closeDate;
  String? scopeWork;
  String? latitude;
  String? longitude;
  String? phoneNumber;
  String? totalRating;
  String? reationCounts;
  String? totalOrders;
  String? deliveryTime;
  String? averageRating;
  bool? isDelivery;

  List<BranchModel>? branches;
  bool? followed;
  BranchModel({
    this.id,
    this.name,
    this.description,
    this.code,
    this.distance,
    this.image,
    this.images,
    this.openingDate,
    this.closeDate,
    this.scopeWork,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.totalRating,
    this.reationCounts,
    this.totalOrders,
    this.deliveryTime,
    this.branches,
    this.followed,
    this.isDelivery,
    this.averageRating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'distance': distance,
      'image': image,
      'opening_date': openingDate,
      'close_date': closeDate,
      'scope_work': scopeWork,
      'latitude': latitude,
      'longitude': longitude,
      'phone_number': phoneNumber,
      'total_rating': totalRating,
      'reation_counts': reationCounts,
      'total_orders': totalOrders,
      'followed': followed,
      'is_delivery': isDelivery,
      'delivery_time': deliveryTime,
      'average_rating': averageRating,
    };
  }

  String get workOrScopeDistance {
    late String tempDistance;
    if (distance?.isNotEmpty ?? false) {
      tempDistance = distance ?? "";
    } else {
      tempDistance = scopeWork ?? '';
    }
    if (tempDistance.toLowerCase().contains("m")) {
      return tempDistance;
    }
    return "${tempDistance}km";
  }

  Widget workingTime({double spacing = 10}) {
    return Row(
      children: [
        SvgPicture.asset(
          SvgAssets.clock,
        ),
        spacing.pw,
        Text(
          openingDate == null
              ? LocalizationHelper.tr.unspecified_phrase
              : DateTime.parse(
                      openingDate ?? LocalizationHelper.tr.unspecified_phrase)
                  .formatedTime,
          style: TextStyles.font12BlackBold.copyWith(
            fontWeight: FontWeights.regular,
          ),
        ),
        spacing.pw,
        Container(
          width: 1,
          height: 10,
          decoration: const BoxDecoration(
            color: LightThemeColors.lightgrey,
            // shape: BoxShape.circle,
          ),
        ),
        spacing.pw,
        Text(
          closeDate == null
              ? LocalizationHelper.tr.unspecified_phrase
              : DateTime.parse(
                      closeDate ?? LocalizationHelper.tr.unspecified_phrase)
                  .formatedTime,
          style: TextStyles.font12BlackBold.copyWith(
            fontWeight: FontWeights.regular,
          ),
        ),
      ],
    );
  }

  factory BranchModel.fromMap(Map<String, dynamic> map) {
    final followedval = map['is_follow'] ?? map['followed'];
    final deliveryval = map['is_delivery'] ?? map['is_delivery '];

    final followed = followedval == true ||
        followedval == 1 ||
        followedval == "1" ||
        followedval == "true";
    final isDelivery = deliveryval == 1 ||
        deliveryval == true ||
        deliveryval == "true" ||
        deliveryval == "1";
    log(map.toString(), name: 'BranchModel');
    log(map['is_delivery '].toString(), name: 'BranchModel');
    return BranchModel(
      id: map['id']?.toString() ?? '',
      distance: map['distance']?.toString() ?? '',
      deliveryTime: map['delivery_time']?.toString() ?? '',
      name: map['name']?.toString() ?? "",
      images: (map['images'] is List)
          ? (map['images'] as List).map((e) => e.toString()).toList()
          : null,
      description: map['description']?.toString() ?? "",
      code: map['code']?.toString() ?? "",
      image: map['image']?.toString() ?? "",
      averageRating: map['average_rating']?.toString() ?? "",
      openingDate: map['opening_date']?.toString() ?? "",
      closeDate: map['close_date']?.toString() ?? "",
      scopeWork: map['scope_work']?.toString() ?? "",
      latitude: map['latitude']?.toString(),
      longitude: map['longitude']?.toString() ?? "",
      phoneNumber: map['phone_number']?.toString() ?? "",
      totalRating: map['total_rating']?.toString() ?? "",
      reationCounts: map['reation_counts']?.toString() ?? "",
      totalOrders: map['total_orders']?.toString() ?? '',
      followed: followed,
      isDelivery: isDelivery,
    );
  }

  BranchModel.getall(Map<String, dynamic> map) {
    branches = map['data'] != null
        ? List<BranchModel>.from((map['data'])
            .map((x) => BranchModel.fromMap(x as Map<String, dynamic>)))
        : null;
  }

  String toJson() => json.encode(toMap());

  factory BranchModel.fromJson(String source) =>
      BranchModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class BranchCategory {
  String? id;
  String? name;
  String? image;
  List<ProductModel>? products;
  List<BranchCategory>? categories;

  BranchCategory({
    this.id,
    this.categories,
    this.name,
    this.image,
    this.products,
  });
  List<ProductModel>? filterproducts(String search) {
    return products
        ?.where((element) =>
            element.name!.toLowerCase().contains(search.toLowerCase()))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory BranchCategory.fromMap(Map<String, dynamic> map) {
    return BranchCategory(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      image: map['image']?.toString(),
      products: map['products'] != null
          ? List<ProductModel>.from((map['products'])
              .map((x) => ProductModel.fromMap(x as Map<String, dynamic>)))
          : null,
    );
  }

  BranchCategory.getall(Map<String, dynamic> map) {
    categories = map['data'] != null
        ? List<BranchCategory>.from((map['data'])
            .map((x) => BranchCategory.fromMap(x as Map<String, dynamic>)))
        : null;
  }

  String toJson() => json.encode(toMap());

  factory BranchCategory.fromJson(String source) =>
      BranchCategory.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductModel {
  String? id;
  String? productId;
  String? favourite_id;
  String? branchId;
  String? cartId;
  String? name;
  String? quantity;
  String? choosenNumber;
  List<String>? images;
  bool? hasOptions;
  String? mainImage;
  String? title;
  String? description;
  String? price;
  String? price_after_coupon;
  String? points;
  String? stars;
  String? rating_avg;
  String? revies_count;
  String? delivery_time;
  String? total_sales;
  String? remaining_quantity;
  BranchCategory? category;
  List<OptionModel>? options;
  bool? isLiked;

  ProductModel({
    this.id,
    this.branchId,
    this.cartId,
    this.options,
    this.quantity,
    this.name,
    this.favourite_id,
    this.hasOptions,
    this.mainImage,
    this.images,
    this.title,
    this.description,
    this.price,
    this.isLiked,
    this.choosenNumber,
    this.price_after_coupon,
    this.points,
    this.stars,
    this.rating_avg,
    this.revies_count,
    this.delivery_time,
    this.total_sales,
    this.remaining_quantity,
    this.category,
    this.productId,
  });
  String getPrice() {
    if (price_after_coupon != null && price_after_coupon!.isNotEmpty) {
      return price_after_coupon!;
    }
    return price ?? "0";
  }

  String? getOriginalPrice() {
    return price_after_coupon == null ? null : price!;
  }

  bool showReviewsCount() {
    if (revies_count == null) {
      return false;
    }
    return (int.parse(revies_count ?? "0") > 0);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'images': images,
      'title': title,
      'description': description,
      'price': price,
      'price_after_coupon': price_after_coupon,
      'points': points,
      'stars': stars,
      'rating_avg': rating_avg,
      'revies_count': revies_count,
      'delivery_time': delivery_time,
      'total_sales': total_sales,
      'remaining_quantity': remaining_quantity,
      'category': category?.toMap(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    List<String>? images,
    String? title,
    String? description,
    String? price,
    String? price_after_coupon,
    String? points,
    String? stars,
    String? rating_avg,
    String? revies_count,
    String? delivery_time,
    String? total_sales,
    String? remaining_quantity,
    String? mainImage,
    BranchCategory? category,
    bool? hasOptions,
  }) {
    return ProductModel(
      id: id ?? this.id,
      mainImage: mainImage ?? this.mainImage,
      hasOptions: hasOptions ?? this.hasOptions,
      name: name ?? this.name,
      images: images ?? this.images,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      price_after_coupon: price_after_coupon ?? this.price_after_coupon,
      points: points ?? this.points,
      stars: stars ?? this.stars,
      rating_avg: rating_avg ?? this.rating_avg,
      revies_count: revies_count ?? this.revies_count,
      delivery_time: delivery_time ?? this.delivery_time,
      total_sales: total_sales ?? this.total_sales,
      remaining_quantity: remaining_quantity ?? this.remaining_quantity,
      category: category ?? this.category,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    String mainImage = map['main_image']?.toString() ??
        (((map['images'] as List?)?.isNotEmpty ?? false)
            ? (map['images'] as List).first?.toString() ?? ""
            : "");
    return ProductModel(
      id: map['id']?.toString() ?? "",
      mainImage: mainImage,
      hasOptions: map['is_options'] == true || map['is_options'] == 1,
      productId: map['product_id']?.toString() ?? "",
      name: map['name']?.toString() ?? "",
      favourite_id: map['favourite_id']?.toString() ?? "",
      images: List.from((map['images'] as List).map((e) => e).toList()),
      title: map['title']?.toString() ?? "",
      quantity: map['quantity']?.toString() ?? "",
      description: map['description']?.toString() ?? "",
      price: map['price']?.toString() ?? "",
      price_after_coupon: map['price_after_coupon']?.toString(),
      points: map['points']?.toString() ?? "",
      stars: map['stars']?.toString() ?? "",
      cartId: map['cart_id']?.toString() ?? "",
      rating_avg: map['rating_avg']?.toString() ?? "",
      revies_count: map['revies_count']?.toString() ?? "",
      delivery_time: map['delivery_time']?.toString() ?? "",
      isLiked: map['is_favourite'],
      total_sales: map['total_sales']?.toString() ?? "",
      remaining_quantity: map['remaining_quantity']?.toString() ?? "0",
      category: map['category'] != null
          ? BranchCategory.fromMap(map['category'] as Map<String, dynamic>)
          : null,
      options: map['options'] != null
          ? List.from(map['options'])
              .map((x) => OptionModel.fromMap(x as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class HomeModel {
  BranchModel? branch;
  List<ProductModel>? newproducts;
  List<ProductModel>? popularproducts;
  List<BranchCategory>? category;
  num? maxPrice;
  num? minPrice;

  HomeModel(
      {this.branch,
      this.newproducts,
      this.popularproducts,
      this.category,
      this.maxPrice,
      this.minPrice});
  List<ProductModel>? filternewproducts(String title) {
    return newproducts
        ?.where((element) =>
            element.title?.toLowerCase().contains(title.toLowerCase()) ?? false)
        .toList();
  }

  List<ProductModel>? filterpopularproducts(String title) {
    return popularproducts
        ?.where((element) =>
            element.title?.toLowerCase().contains(title.toLowerCase()) ?? false)
        .toList();
  }

  factory HomeModel.fromMap(Map<String, dynamic> map) {
    return HomeModel(
        branch: map['branch'] != null
            ? BranchModel.fromMap(map['branch'] as Map<String, dynamic>)
            : null,
        newproducts: map['new'] != null
            ? List<ProductModel>.from(
                (map['new']).map<ProductModel?>(
                  (x) => ProductModel.fromMap(x as Map<String, dynamic>),
                ),
              )
            : null,
        popularproducts: map['popular'] != null
            ? List<ProductModel>.from(
                (map['popular']).map<ProductModel?>(
                  (x) => ProductModel.fromMap(x as Map<String, dynamic>),
                ),
              )
            : null,
        category: map['categories'] != null
            ? List<BranchCategory>.from(
                (map['categories']).map<BranchCategory?>(
                  (x) => BranchCategory.fromMap(x as Map<String, dynamic>),
                ),
              )
            : null,
        maxPrice: num.parse(map['max_price']?.toString() ?? "100"),
        minPrice: num.parse(map['min_price']?.toString() ?? "0"));
  }

  List<ProductCategoryList> getproductcategorylist({String title = ""}) {
    List<ProductCategoryList> list = [];

    if (category != null) {
      for (var element in category!) {
        var products = element.products
            ?.where((element) =>
                element.title?.toLowerCase().contains(title.toLowerCase()) ??
                false)
            .toList();
        if (products!.isNotEmpty) {
          list.add(ProductCategoryList(
              item: element, type: ProductCategoryListenum.category));
          for (var product in products) {
            list.add(ProductCategoryList(
                item: product, type: ProductCategoryListenum.product));
          }
        }
      }
    }
    return list;
  }

  factory HomeModel.fromJson(String source) =>
      HomeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum OptionType {
  singleChoice,
  multipleChoice;

  String get value {
    switch (this) {
      case OptionType.singleChoice:
        return 'single_choice';
      case OptionType.multipleChoice:
        return 'multiple_choice';
    }
  }

  factory OptionType.fromString(String? value) {
    if (value == 'multiple_choice') {
      return OptionType.multipleChoice;
    }
    return OptionType.singleChoice;
  }
}

class OptionModel {
  String? id;
  String? name;
  String? productId;
  OptionType type;

  List<ValueOptionModel>? values;

  OptionModel({
    this.id,
    this.name,
    this.productId,
    this.type = OptionType.singleChoice,
    this.values,
  });

  factory OptionModel.fromMap(Map<String, dynamic> map) {
    return OptionModel(
      id: map['id']?.toString() ?? "",
      name: map['name']?.toString() ?? "",
      productId: map['product_id']?.toString() ?? "",
      type: OptionType.fromString(map['type']?.toString()),
      values: map['values'] != null
          ? List<ValueOptionModel>.from(
              (map['values']).map<ValueOptionModel?>(
                (x) => ValueOptionModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  factory OptionModel.fromJson(String source) =>
      OptionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ValueOptionModel extends Equatable {
  final String? id;
  final String? productOptionId;
  final String? value;
  final String? optionId;
  final String? extraPrice;
  final bool? isRecommended;
  final bool? status;

  const ValueOptionModel({
    this.id,
    this.productOptionId,
    this.value,
    this.optionId,
    this.extraPrice,
    this.status,
    this.isRecommended,
  });

  factory ValueOptionModel.fromMap(Map<String, dynamic> map) {
    return ValueOptionModel(
      id: map['id']?.toString() ?? "",
      productOptionId: map['product_option_id']?.toString() ?? "",
      value: map['value']?.toString() ?? "",
      optionId: map['optionId']?.toString() ?? "",
      extraPrice: map['extra_price']?.toString() ?? "",
      isRecommended: map['is_recommended'] == 1 ||
          map['is_recommended'] == true ||
          map['is_recommended'] == "1",
      status:
          map['status'] == 1 || map['status'] == true || map['status'] == "1",
    );
  }
  String recommendedtext() {
    return 'Recommended';
    // return 'Recommended ${num.tryParse(extraPrice ?? "") != null && num.tryParse(extraPrice ?? "")! > 0 ? '+ $extraPrice ₺' : ''}';
  }

  ValueOptionModel copyWith({
    String? id,
    String? productOptionId,
    String? value,
    String? optionId,
    String? extraPrice,
    bool? isRecommended,
    bool? status,
  }) {
    return ValueOptionModel(
      id: id ?? this.id,
      productOptionId: productOptionId ?? this.productOptionId,
      value: value ?? this.value,
      optionId: optionId ?? this.optionId,
      extraPrice: extraPrice ?? this.extraPrice,
      isRecommended: isRecommended ?? this.isRecommended,
      status: status ?? this.status,
    );
  }

  factory ValueOptionModel.fromJson(String source) =>
      ValueOptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [
        id,
        productOptionId,
        value,
        status,
        isRecommended,
      ];
}

class ProductCategoryList {
  final dynamic item;
  final ProductCategoryListenum type;
  const ProductCategoryList({required this.item, required this.type});
}

enum ProductCategoryListenum { category, product }
