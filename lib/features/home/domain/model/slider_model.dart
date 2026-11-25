import 'package:getincoffee/core/general/generalmodel.dart';

class HomeAdsModel {
  final List<GeneralModel> sliders;
  final List<GeneralModel> texts;
  HomeAdsModel({required this.sliders, required this.texts});
  factory HomeAdsModel.fromMap(Map<String, dynamic> map) {
    return HomeAdsModel(
      sliders: List<GeneralModel>.from(
        map['image_ads'].map((x) => GeneralModel.fromMap(x)),
      ),
      texts: List<GeneralModel>.from(
        map['text_ads'].map((x) => GeneralModel.fromMap(x)),
      ),
    );
  }
}
