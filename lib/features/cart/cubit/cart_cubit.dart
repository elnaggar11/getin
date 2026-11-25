import 'dart:developer';

import 'package:getincoffee/features/addresses/domain/model/addresses_model/datum.dart';
import 'package:getincoffee/features/addresses/domain/repository/repository.dart';
import 'package:getincoffee/features/cart/domain/model/cart_model.dart';
import 'package:getincoffee/features/cart/domain/model/summary_model.dart';
import 'package:getincoffee/features/cart/domain/request/cart_request.dart';
import 'package:getincoffee/core/general/cubit/general_cubit.dart';
import 'package:getincoffee/features/cart/presentation/widgets/bottomsheets.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/paymentmethod/domain/request/paymentmethod_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/services/alerts.dart';
import '../../../core/utils/Locator.dart';
import '../../myorder/domain/model/myorder_model.dart';
import '../domain/repository/repository.dart';
import 'cart_states.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitial());
  static CartCubit get(context) => BlocProvider.of(context);

  CartRepository cartRepository = locator<CartRepository>();
  AddressesRepository addressesRepository = locator<AddressesRepository>();
  AddresseData addresseData = AddresseData();
  final pagingController = PagingController<int, List<ProductModel>>(
    firstPageKey: 1,
  );

  int length = 0;

  void addPageListener() {
    pagingController.addPageRequestListener((pageKey) {
      getAllCartProducts(pageKey);
    });
  }

  int? branchId;
  Future<void> getAllCartProducts(int page) async {
    emit(CartProductsLoadingdState());

    final response = await cartRepository.getCartProducts(page: page);

    if (response != null) {
      branchId = response.branchId;

      final chunks = _chunkProducts(response.products ?? [], 3);

      bool isLastPage = response.lastPage == page;

      if (isLastPage) {
        pagingController.appendLastPage(chunks);
      } else {
        pagingController.appendPage(chunks, page + 1);
      }

      length = response.lastPage ?? 0;
      emit(ChunckSuccessState(length));
    } else {
      pagingController.error = "error";
      emit(CartProductsFailedState());
    }
  }

  List<List<ProductModel>> _chunkProducts(
      List<ProductModel> products, int size) {
    final chunks = <List<ProductModel>>[];
    for (var i = 0; i < products.length; i += size) {
      chunks.add(products.sublist(
        i,
        i + size > products.length ? products.length : i + size,
      ));
    }
    return chunks;
  }

  chooseAddress(BuildContext context) async {
    Alerts.bottomSheet(
      close: (val) async {
        log(val.toString());
        if (val != null) {
          addresseData = val;
          emit(ChooseAdreesState());
        }
        return true;
      },
      context,
      child: const AddressesSheetBodyWidget(),
    );
  }

  CartModel cartModel = CartModel();
  getallcart() async {
    emit(CartLoadingState());
    final response = await cartRepository.getAllcart();
    if (response != null) {
      if (response is List) {
        cartModel = CartModel(
          items: [],
        );
        locator<GeneralCubit>().updateCartCount(0);
      } else {
        cartModel = CartModel.fromMap(response);
        locator<GeneralCubit>().updateCartCount(cartModel.totalQuantity);
      }

      emit(CartSuccessState(cartModel));
    } else {
      emit(CartFailedState());
    }
  }

  clearAlldata() async {
    emit(ClearAllCartLoading());
    final response = await cartRepository.deleteAllItems();
    if (response != null) {
      // cartModel = CartModel.fromMap(response);
      locator<GeneralCubit>().updateCartCount(0);
      emit(ClearAllCartSuccess());
    } else {
      emit(ClearAllCartError());
    }
  }

  deleteItem({String? id}) async {
    emit(DeleteItemLoading());
    log(id.toString() ?? 'dd', name: "ddddddd");
    final response = await cartRepository.deleteItem(id: id);
    if (response != null) {
      cartModel.items!.removeWhere((element) => element.id == id);
      getallcart();
      // cartModel = CartModel.fromMap(response);
      emit(DeleteItemSuccess());
    } else {
      emit(DeleteItemError());
    }
  }

  // String quantity = "";
  Future<bool> updateQuantity({
    String? id,
    String? quantity,
  }) async {
    emit(UpdateLoading());
    final response = await cartRepository.updateQuan(
      id: id,
      quantity: quantity,
    );
    if (response != null) {
      cartModel.subTotal = response["subtotal"].toString();
      cartModel.totalPrice = response["total"].toString();
      cartModel.total = response["total"].toString();
      cartModel.deliveryCharge = response["delivery_charge"].toString();
      cartModel.tax = response["tax"].toString();
      cartModel.descriptionText = response["description_text"].toString();

      final itemIndex =
          cartModel.items?.indexWhere((element) => element.id == id);
      if (itemIndex != null && itemIndex >= 0) {
        cartModel.items![itemIndex].quantity = quantity;
      }
      locator<GeneralCubit>().updateCartCount(cartModel.totalQuantity);

      emit(UpdateItemSuccess());
      return true;
    } else {
      emit(UpdateItemError());
      return false;
    }
  }

  CheckOutRequest request = CheckOutRequest();
  bool _checkoutInProgress = false;

  checkout({String? type}) async {
    if (_checkoutInProgress) return;
    _checkoutInProgress = true;
    emit(CheckoutLoading());
    try {
      final response = await cartRepository.checkout(
        request: request
          ..user_location_id = addresseData.id?.toString() ?? ""
          ..user_payment_id = null
          ..type = type,
      );
      if (response != null) {
        emit(StripeIdSuccess(data: response));
      } else {
        emit(StripeIdError());
      }
    } finally {
      _checkoutInProgress = false;
    }
  }

  Future<void> payWithPoints({String? type}) async {
    if (_checkoutInProgress) return;
    _checkoutInProgress = true;
    emit(CheckoutLoading());
    try {
      final response = await cartRepository.payWithPoints(
        request: request
          ..user_location_id = addresseData.id?.toString() ?? ""
          ..user_payment_id = null
          ..type = type,
      );
      response.fold(
        (error) {
          Alerts.snack(text: error, state: SnackState.failed);
          emit(CheckoutError());
        },
        (id) => id.isNotEmpty
            ? emit(CheckoutSuccess(id: id))
            : emit(CheckoutError()),
      );
    } finally {
      _checkoutInProgress = false;
    }
  }

  String? copon = "";
  SummaryModel? summaryModel;
  verifyCopon() async {
    emit(VerifyCoponLoading());
    final response = await cartRepository.verifyCopon(
      copon: copon,
    );
    if (response != null) {
      summaryModel = response;
      print(summaryModel?.discount);

      emit(VerifyCoponSuccess(summaryModel));
    } else {
      emit(VerifyCoponError());
    }
  }

  PaymentmethodRequest paymentmethodRequest = PaymentmethodRequest();
  chooseCard(BuildContext context) async {
    Alerts.bottomSheet(
      close: (val) async {
        paymentmethodRequest = val;
        emit(ChangeCardState());
        return true;
      },
      context,
      child: const PaymentshetBody(),
    );
  }

  SingleOrderModel? orderItemModel;
  getSinglCode({String? id}) async {
    emit(GetSingleOrderLoading());
    final response = await cartRepository.getSingleOrder(
      id: id,
    );
    if (response != null) {
      orderItemModel = response;
      emit(GetSingleOrderSuccess(
        response,
      ));
    } else {
      emit(GetSingleOrderError());
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }

  //   void reset() {
  //   emit(AddressesInitial());
  //   _getAddresses();
  // }

  // Future<void> addAddress(AddressRequest addressRequest) async {
  //   emit(AddAddressLoading());
  //   try {
  //     final response = await addressesRepository.addAddress(addressRequest);
  //     if (response != null) {
  //       _getAddresses();
  //       emit(AddAddressSuccess(addressesModel));
  //     } else {
  //       emit(AddAddressFailure("Failed to save address"));
  //     }
  //   } catch (e) {
  //     emit(AddAddressFailure(e.toString()));
  //   }
  // }

  // AddressesModel? addressesModel;
  // Future<void> _getAddresses() async {
  //   emit(GetAddressesLoading());
  //   try {
  //     final response = await addressesRepository.getAddresses();
  //     if (response != null) {
  //       addressesModel = response;
  //       emit(GetAddressesSuccess(response));
  //     } else {
  //       emit(GetAddressesFailure("Failed to get addresses"));
  //     }
  //   } catch (e) {
  //     emit(GetAddressesFailure(e.toString()));
  //   }
  // }
}
