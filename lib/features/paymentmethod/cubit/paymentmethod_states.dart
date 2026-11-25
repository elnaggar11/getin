import '../domain/request/paymentmethod_request.dart';

abstract class PaymentmethodStates {}

class PaymentmethodInitial extends PaymentmethodStates {}

class PaymentmethodLoadingState extends PaymentmethodStates {}

class PaymentmethodErrorState extends PaymentmethodStates {}

class PaymentmethodSuccessState extends PaymentmethodStates {
  PaymentmethodRequest? cards;

  PaymentmethodSuccessState({this.cards});
}

class SavePaymentMethodLoading extends PaymentmethodStates {}

class SavePaymentMethodSuccess extends PaymentmethodStates {}

class SavePaymentMethodError extends PaymentmethodStates {
  final String? message;
  SavePaymentMethodError({this.message});
}

class DeletePaymentMethodLoading extends PaymentmethodStates {}

class DeletePaymentMethodSuccess extends PaymentmethodStates {}

class DeletePaymentMethodError extends PaymentmethodStates {
  final String? message;
  DeletePaymentMethodError({this.message});
}
