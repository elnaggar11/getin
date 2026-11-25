import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/utils/Locator.dart';
import 'package:getincoffee/features/cart/domain/repository/repository.dart';
import 'package:getincoffee/features/cart/qr_order/data/repository/repository.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';

part 'qr_state.dart';

class QrCubit extends Cubit<QrState> {
  QrCubit() : super(QrInitial());
  static QrCubit get(context) => BlocProvider.of(context);

  CartRepository cartRepository = locator<CartRepository>();

  final QrReaderRepository qrReaderRepository = locator<QrReaderRepository>();

  SingleOrderModel? orderItemModel;
  late String currentOrderId;

  getSinglCode({required String id}) async {
    emit(GetQrOrderLoading());
    currentOrderId = id;
    final response = await cartRepository.getSingleOrder(
      id: id,
    );
    
    if (response != null) {
      orderItemModel = response;
      emit(GetQrOrderSuccess(
        response,
      ));
    } else {
      emit(GetQrOrderError());
    }
  }

  void confirmOrder(
    String qrCodedata,
  ) async {
    emit(QrReaderLoading());
    final uri = Uri.parse(qrCodedata);
    final path = uri.path;
    final apiSegmentIndex = path.indexOf('/api/');
    String pathAfterApi = "";
    if (apiSegmentIndex != -1) {
      pathAfterApi = path.substring(apiSegmentIndex + '/api/'.length);
    }

    final token = uri.queryParameters['token'];
    final orderId = uri.queryParameters['order_id'];

    if (orderId == null || token == null) {
      Alerts.snack(
        text: LocalizationHelper.tr.qr_code_invalid,
        state: SnackState.failed,
      );
      emit(QrReaderError());
      return;
    }
    final response = await qrReaderRepository.confirmClientRecieveOrder(
      int.parse(orderId),
      token: token,
      url: pathAfterApi,
    );
    if (response != null) {
      emit(QrReaderSuccess(response));
    } else {
      emit(QrReaderError());
    }
  }
}
