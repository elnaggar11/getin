// ignore_for_file: public_member_api_docs, sort_constructors_first
class CartRequest {}

class CheckOutRequest {
  String? coupon_code;
  String? user_location_id;
  String? user_payment_id;
  String? type;
  CheckOutRequest({
    this.coupon_code,
    this.user_location_id,
    this.user_payment_id,
    this.type,
  });

  Map<String, dynamic> toMap({String payWith = 'money'}) {
    final normalizedType = switch (type?.toLowerCase()) {
      'pickup' || 'pick-up' || 'pick_up' => 'pick_up',
      _ => type,
    };
    return <String, dynamic>{
      if (coupon_code?.isNotEmpty == true) 'coupon_code': coupon_code,
      if (user_location_id?.isNotEmpty == true)
        'user_location_id': user_location_id,
      if (payWith == 'money' && user_payment_id?.isNotEmpty == true)
        'payment_method': user_payment_id,
      'type': normalizedType,
      'pay_with': payWith,
    };
  }

  Map<String, dynamic> toMapPoints() {
    final normalizedType = switch (type?.toLowerCase()) {
      'pickup' || 'pick-up' || 'pick_up' => 'pick_up',
      _ => type,
    };
    return <String, dynamic>{
      if (coupon_code?.isNotEmpty == true) 'coupon_code': coupon_code,
      if (user_location_id?.isNotEmpty == true)
        'user_location_id': user_location_id,
      'type': normalizedType,
      'pay_with': 'points'
    };
  }
}
