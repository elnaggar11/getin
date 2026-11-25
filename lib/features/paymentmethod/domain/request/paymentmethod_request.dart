import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaymentmethodRequest {
  String? id;
  String? name;
  String? brand;
  String? displayBrand;
  String? last4;
  int? expMonth;
  int? expYear;
  List<PaymentmethodRequest>? cards;

  String? get cardNumber => last4 != null ? '**** **** **** $last4' : null;

  String? get expireDate =>
      expMonth != null && expYear != null ? '$expMonth/$expYear' : null;

  PaymentmethodRequest({
    this.name,
    this.brand,
    this.displayBrand,
    this.last4,
    this.expMonth,
    this.expYear,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'payment_method': id,
      'name': name,
      'brand': brand,
      'last4': last4,
      'exp_month': expMonth,
      'exp_year': expYear,
      'display_brand': displayBrand,
    };
  }

  factory PaymentmethodRequest.fromMap(Map<String, dynamic> map) {
    // Check if it's the old flat structure or new nested structure
    // The new structure has 'card' object
    final card = map['card'];
    final billingDetails = map['billing_details'];

    if (card != null) {
      return PaymentmethodRequest(
        id: map['id']?.toString(),
        name: billingDetails is Map ? billingDetails['name']?.toString() : null,
        brand: card is Map ? card['brand']?.toString() : null,
        last4: card is Map ? card['last4']?.toString() : null,
        expMonth: card is Map ? int.tryParse('${card['exp_month']}') : null,
        expYear: card is Map ? int.tryParse('${card['exp_year']}') : null,
        displayBrand: card is Map ? card['display_brand']?.toString() : null,
      );
    } else {
      // Fallback for old structure or manually created objects
      return PaymentmethodRequest(
        id: map['id']?.toString(),
        name: map['name']?.toString(),
        brand: map['brand']?.toString(),
        last4: map['last4']?.toString(),
        expMonth: int.tryParse('${map['exp_month']}'),
        expYear: int.tryParse('${map['exp_year']}'),
        displayBrand: map['display_brand']?.toString(),
      );
    }
  }

  PaymentmethodRequest.allCards(Map<String, dynamic> map) {
    // Handle both potential structures just in case, but prioritize the new one
    // map['data'] could be the list directly (old) or an object containing the list (new)
    var dataField = map['data'];
    List listToParse = [];

    if (dataField is Map) {
      // New structure: data -> data -> list
      if (dataField['data'] is List) {
        listToParse = dataField['data'];
      }
    } else if (dataField is List) {
      // Old structure: data -> list
      listToParse = dataField;
    }

    cards = List.from(
      listToParse.map((e) => PaymentmethodRequest.fromMap(e)).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentmethodRequest.fromJson(String source) =>
      PaymentmethodRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
