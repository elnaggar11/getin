import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

export 'package:flutter_stripe/flutter_stripe.dart' show StripeException;

class StripeService {
  StripeService._();

  static const String _publishableKey =
      'pk_test_51T1Agc9KqWKYskqR8Pg7d396s2iJYeVTr5FDo7wvJH40EQEVBHpTZ1AA9c5OsAcYEo6uwyni4zhUMfkV2I7HDtya001ADHUZai';

  static Future<void> init() async {
    Stripe.publishableKey = _publishableKey;
    await Stripe.instance.applySettings();
  }

  static Future<PaymentMethod> createCardPaymentMethod() async {
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(),
      ),
    );
    return paymentMethod;
  }

  static Future<void> presentPaymentSheet({
    required String clientSecret,
    required String ephemeralKey,
    required String stripeCustomerId,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          paymentIntentClientSecret: clientSecret,
          customerEphemeralKeySecret: ephemeralKey,
          customerId: stripeCustomerId,
          merchantDisplayName: "Getin Coffee",
          //   returnURL: '${ConstKeys.baseUrl}orders/stripe-payment/return-url',
          primaryButtonLabel: 'Pay now',
          style: ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw e;
    }
  }
}
