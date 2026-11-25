import 'package:getincoffee/core/data_source/dio_helper.dart';
import 'package:getincoffee/features/cart/presentation/widgets/bottomsheets.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/domain/repository/repository.dart';
import 'package:getincoffee/features/productdetails/domain/request/productdetails_request.dart';
import 'package:getincoffee/features/cart/domain/request/payment_data.dart';
import 'package:getincoffee/features/scheduleorder/domain/model/scheduleorder_model.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/services/alerts.dart';
import '../../../core/utils/Locator.dart';
import '../../paymentmethod/domain/request/paymentmethod_request.dart';
import '../domain/repository/repository.dart';
import '../domain/request/scheduleorder_request.dart';
import 'scheduleorder_states.dart';

class ScheduleorderCubit extends Cubit<ScheduleorderStates> {
  ScheduleorderCubit() : super(ScheduleorderInitial());
  static ScheduleorderCubit get(context) => BlocProvider.of(context);

  PagingController<int, ScheduleorderModel> paginationController =
      PagingController<int, ScheduleorderModel>(firstPageKey: 1);

  ScheduleorderRepository scheduleorderRepository =
      locator<ScheduleorderRepository>();

  ScheduleorderRequest scheduleorderRequest = ScheduleorderRequest();
  HomeRepository homeRepository = HomeRepository(locator<DioService>());

  List<AddtoCartRequest?> cartproducts = [];

  addpageListener() {
    paginationController.addPageRequestListener((page) {
      getScheduleOrders(page);
    });
  }

  addScheduleOrder() async {
    emit(ScheduleorderLoading());

    List<List<String>> tempProductOptionValues = [];
    for (var element in cartproducts) {
      tempProductOptionValues.add(element?.optionValueIds ?? []);
    }

    scheduleorderRequest = scheduleorderRequest.copyWith(
      productIds: cartproducts.map((val) => val?.product?.id ?? "").toList(),
      productsQuantity: cartproducts.map((val) => val?.quantity ?? "").toList(),
      productOptionValues: tempProductOptionValues,
      userPaymentId: paymentmethodRequest.id,
    );

    PaymentData? result =
        await scheduleorderRepository.addScheduleOrder(scheduleorderRequest);
    if (result != null) {
      emit(ScheduleorderSuccess(data: result));
    } else {
      emit(ScheduleorderFailed());
    }
  }

  List<BranchModel>? branchModel;
  Future<BranchModel?> getBranches({String? name}) async {
    emit(SearchBranchLoading());
    final response = await homeRepository.getBranches(
      name: name,
    );
    if (response != null) {
      branchModel = response.branches;
      emit(BranchesLoadedSuccess(branches: response.branches ?? []));
      return response;
    } else {
      emit(BrancheesLoadedError());
      return null;
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

  getScheduleOrders(int page) async {
    // emit(GetScheduleorderLoading());
    final response =
        await scheduleorderRepository.getScheduleOrders(page: page);
    if (response != null) {
      if (response.page == page) {
        paginationController.appendLastPage(
          response.data ?? [],
        );
      } else {
        paginationController.appendPage(response.data ?? [], page);
      }
      // emit(GetScheduleorderSuccess());
    } else {
      paginationController.error = "error";
      // emit(GetScheduleorderFailed());
    }
  }

  deleteScheduleOrder({required String id}) async {
    emit(DeleteScheduleorderLoading());
    final response = await scheduleorderRepository.deleteScheduleOrder(id: id);
    if (response) {
      emit(DeleteScheduleorderSuccess());
    } else {
      emit(DeleteScheduleorderFailed());
    }
  }
}
