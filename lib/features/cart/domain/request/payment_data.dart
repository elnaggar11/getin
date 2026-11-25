class PaymentData {
  String? clientSecret;
  String? orderId;
  String? stripeCustomerId;
  String? ephemeralKey;
  PaymentData(
      {this.clientSecret,
      this.orderId,
      this.stripeCustomerId,
      this.ephemeralKey});

  factory PaymentData.fromMap(Map<String, dynamic> map) {
    return PaymentData(
      clientSecret: map['client_secret']?.toString(),
      orderId: map['order']?['id']?.toString(),
      stripeCustomerId: map['stripe_customer_id']?.toString(),
      ephemeralKey: map['ephemeral_key']?.toString(),
    );
  }
}
