import 'current_rank.dart';
import 'order.dart';

class MyStarModel {
  Rank? currentRank;
  Rank? nextRank;
  bool? isLastRank;
  String? userStars;
  String? currentRankName;
  int? progressPercent;
  List<StarOrder>? orders;

  MyStarModel({
    this.currentRank,
    this.nextRank,
    this.isLastRank,
    this.userStars,
    this.currentRankName,
    this.progressPercent,
    this.orders,
  });

  factory MyStarModel.fromJson(Map<String, dynamic> json) => MyStarModel(
        currentRank: json['current_rank'] == null
            ? null
            : Rank.fromJson(json['current_rank'] as Map<String, dynamic>),
        nextRank: json['next_rank'] == null
            ? null
            : Rank.fromJson(json['next_rank'] as Map<String, dynamic>),
        isLastRank: json['is_last_rank'] as bool?,
        userStars: json['user_stars'].toString(),
        currentRankName: json['current_rank_name'] as String?,
        progressPercent: int.parse(json['progress_percent'].toString()),
        orders: (json['orders'] as List<dynamic>?)
            ?.map((e) => StarOrder.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'current_rank': currentRank?.toJson(),
        'next_rank': nextRank?.toJson(),
        'is_last_rank': isLastRank,
        'user_stars': userStars,
        'current_rank_name': currentRankName,
        'progress_percent': progressPercent,
        'orders': orders?.map((e) => e.toJson()).toList(),
      };
}
