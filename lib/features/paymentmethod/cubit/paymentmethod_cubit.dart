import 'package:getincoffee/core/services/stripe_service.dart';
import 'package:getincoffee/features/paymentmethod/domain/request/paymentmethod_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'paymentmethod_states.dart';

class PaymentmethodCubit extends Cubit<PaymentmethodStates> {
  PaymentmethodCubit() : super(PaymentmethodInitial()) {
    getAllpaymentMethods();
  }
  static PaymentmethodCubit get(context) => BlocProvider.of(context);

  PaymentmethodRepository paymentmethodRepository =
      locator<PaymentmethodRepository>();

  PaymentmethodRequest? cards;
  getAllpaymentMethods() async {
    emit(PaymentmethodLoadingState());
    var response = await paymentmethodRepository.getAllpaymentmethod();
    if (response == null) {
      emit(PaymentmethodErrorState());
    } else {
      cards = PaymentmethodRequest.allCards(response);
      emit(PaymentmethodSuccessState(
        cards: cards,
      ));
    }
  }

  savePaymentMethod({PaymentmethodRequest? request}) async {
    emit(SavePaymentMethodLoading());
    var response = await paymentmethodRepository.savePaymentmethod(
      request: request,
    );
    if (response == true) {
      emit(SavePaymentMethodSuccess());
    } else {
      emit(SavePaymentMethodError(message: 'Could not save payment method.'));
    }
  }

  Future<void> addCardWithStripe() async {
    try {
      emit(SavePaymentMethodLoading());
      final paymentMethod = await StripeService.createCardPaymentMethod();
      final card = paymentMethod.card;
      final request = PaymentmethodRequest(
        name: paymentMethod.billingDetails.name,
        brand: card.brand,
        last4: card.last4,
        expMonth: card.expMonth,
        expYear: card.expYear,
        id: paymentMethod.id,
      );
      final response = await paymentmethodRepository.savePaymentmethod(
        request: request,
      );
      if (response == true) {
        emit(SavePaymentMethodSuccess());
        getAllpaymentMethods();
      } else {
        emit(SavePaymentMethodError());
      }
    } on StripeException catch (e) {
      emit(SavePaymentMethodError(
        message: e.error.localizedMessage ?? 'Card creation failed',
      ));
    } catch (e) {
      emit(SavePaymentMethodError(message: e.toString()));
    }
  }

  deletePaymentMethod(String paymentMethodId) async {
    emit(DeletePaymentMethodLoading());
    var response = await paymentmethodRepository.detachPaymentMethod(
      paymentMethodId: paymentMethodId,
    );
    if (response == true) {
      emit(DeletePaymentMethodSuccess());
      getAllpaymentMethods();
    } else {
      emit(DeletePaymentMethodError());
    }
  }
}
