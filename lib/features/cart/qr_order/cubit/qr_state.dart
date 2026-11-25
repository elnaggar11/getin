part of 'qr_cubit.dart';

sealed class QrState extends Equatable {
  const QrState();

  @override
  List<Object> get props => [];
}

final class QrInitial extends QrState {}

class GetQrOrderLoading extends QrState {}

class GetQrOrderSuccess extends QrState {
  final SingleOrderModel orderItemModel;

  const GetQrOrderSuccess(this.orderItemModel);
}

class GetQrOrderError extends QrState {}


      class QrReaderLoading extends QrState {}
      
      class QrReaderError extends QrState {}
      
    class QrReaderSuccess extends QrState {
      final dynamic response;
    
      const QrReaderSuccess(this.response);
    }
    