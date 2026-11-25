// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';

class RatingRequest {
  String? orderId;
  String? reviewableId;
  String? rating;
  String? comment;
  List<OrderItemModel>? productratings;
/*   List<String>? productids;
  List<String>? productratings;
  List<String>? productcomments; */
  RatingRequest({
    this.orderId,
    this.reviewableId,
    this.rating,
    this.comment,
    //this.productids,
    this.productratings,
    // this.productcomments,
  });
  bool checkEmptyRating() {
    var check =
        productratings?.any((element) => element.userRate == null) ?? false;
    return check;
  }

  String? checkOrderRate() {
    bool check = checkEmptyRating();
    if (check) {
      return "Please rate all products";
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{
      'order_id': orderId,
      'reviewable_id': reviewableId,
      'rating': rating,
      'comment': comment,
    };

    final ids = productratings?.map((e) => e).toList() ?? [];
    final ratings = productratings?.map((e) => e.userRate).toList() ?? [];

    for (int i = 0; i < (productratings?.length ?? 0); i++) {
      data['products[$i][id]'] = ids[i].product_id;
      data['products[$i][rating]'] = ratings[i];
      data['products[$i][comment]'] = comment;
    }
    // 'productids': productids,
    //   'productratings': productratings,
    //   'productcomments': productcomments,
    return data;
  }
}
