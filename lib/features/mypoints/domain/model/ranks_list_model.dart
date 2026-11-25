import 'package:getincoffee/features/mypoints/domain/model/my_star_model/current_rank.dart';

class RanksListModel {
  List<Rank>? ranks;
  int? currentRankId;
  RanksListModel({
    this.ranks,
    this.currentRankId,
  });
  factory RanksListModel.fromJson(Map<String, dynamic> json) => RanksListModel(
        ranks: (json["data"] as List<dynamic>?)
            ?.map((e) => Rank.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
  Map<String, dynamic> toJson() => {
        'ranks': ranks?.map((e) => e.toJson()).toList(),
      };
}
