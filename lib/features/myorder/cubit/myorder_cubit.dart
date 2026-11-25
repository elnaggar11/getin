import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/Locator.dart';
import '../domain/model/myorder_model.dart';
import '../domain/repository/repository.dart';
import 'myorder_states.dart';

class MyorderCubit extends Cubit<MyorderStates> {
  MyorderCubit() : super(MyorderInitial());
  static MyorderCubit get(context) => BlocProvider.of(context);

  MyorderRepository myorderRepository = locator<MyorderRepository>();
  final Set<String> _cancelingOrderIds = {};
  MyorderModel? myorderModel;
  String statusToBack = "pending";
  refresh() {
    getOrders();
  }

  getOrders() async {
    emit(MyorderLoadingState());

    final response = await myorderRepository.getorders(
      status: statusToBack,
    );
    if (response != null) {
      myorderModel = MyorderModel.allorders(response);
      emit(MyorderSuccessState(myorderModel: myorderModel));
    } else {
      emit(MyorderErrorState());
    }
  }

  cancelOrder(String id) async {
    if (!_cancelingOrderIds.add(id)) return;
    emit(CancelOrderLoadingState());
    try {
      final response = await myorderRepository.cancellOrder(id: id);
      if (response == true) {
        emit(CancelOrderSuccessState());
      } else {
        emit(CancelOrderFailedState());
      }
    } finally {
      _cancelingOrderIds.remove(id);
    }
  }

  reOrder(String id, {String? confirm}) async {
    emit(ReorderLoadingState());
    final response = await myorderRepository.reOrder(id: id, confirm: confirm);
    if (response is bool && response == true) {
      emit(ReorderSuccessState());
    } else if (response != null && response is Map) {
      emit(ReorderConfirmationRequiredState(
          unavailableItems: response['unavailable_items'], id: id));
    } else {
      emit(ReorderFailedState());
    }
  }
}
