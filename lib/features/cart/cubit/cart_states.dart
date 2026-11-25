import 'package:getincoffee/features/cart/domain/model/cart_model.dart';
import 'package:getincoffee/features/cart/domain/model/summary_model.dart';
import 'package:getincoffee/features/cart/domain/request/payment_data.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';

import '../../myorder/domain/model/myorder_model.dart';

abstract class CartStates {}

class CartInitial extends CartStates {}

class CartLoadingState extends CartStates {}

class CartSuccessState extends CartStates {
  CartModel cartModel;

  CartSuccessState(this.cartModel);
}

class CartFailedState extends CartStates {}

class CartProductsLoadingdState extends CartStates {}

class CartProductsSuccessState extends CartStates {
  PagedProducts products;

  CartProductsSuccessState(this.products);
}

class CartProductsFailedState extends CartStates {}

class UpdateLoading extends CartStates {}

class UpdateItemSuccess extends CartStates {}

class UpdateItemError extends CartStates {}

class DeleteItemLoading extends CartStates {}

class DeleteItemSuccess extends CartStates {}

class DeleteItemError extends CartStates {}

class ClearAllCartLoading extends CartStates {}

class ClearAllCartSuccess extends CartStates {}

class ClearAllCartError extends CartStates {}

class CheckoutLoading extends CartStates {}

class CheckoutSuccess extends CartStates {
  String? id;

  CheckoutSuccess({this.id});
}

class CheckoutError extends CartStates {}

class VerifyCoponLoading extends CartStates {}

class VerifyCoponSuccess extends CartStates {
  SummaryModel? summaryModel;

  VerifyCoponSuccess(this.summaryModel);
}

class VerifyCoponError extends CartStates {}

class ChooseAdreesState extends CartStates {}

class ChangeCardState extends CartStates {}

class GetSingleOrderSuccess extends CartStates {
  SingleOrderModel? orderItemModel;

  GetSingleOrderSuccess(this.orderItemModel);
}

class GetSingleOrderLoading extends CartStates {}

class GetSingleOrderError extends CartStates {}

class ChunckSuccessState extends CartStates {
  int length;
  ChunckSuccessState(this.length);
}
// class CheckoutError extends CartStates {}
// class CheckoutError extends CartStates {}
// class CheckoutError extends CartStates {}

class SummaryDataLoading extends CartStates {}

class SummaryDataSuccess extends CartStates {
  final dynamic summaryModel;

  SummaryDataSuccess(this.summaryModel);
}

class SummaryDataError extends CartStates {}

class StripeIdSuccess extends CartStates {
  final PaymentData data;

  StripeIdSuccess({required this.data});
}

class StripeIdError extends CartStates {}

class AddTocartLoading extends CartStates {}

class AddTocartSuccess extends CartStates {}

class AddTocartFailed extends CartStates {}
