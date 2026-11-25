import 'package:getincoffee/features/myorder/domain/model/single_order_status.dart';

abstract class TrackStates {}

class TrackInitial extends TrackStates {}

class TrackStatusUpdatedState extends TrackStates {
  final String orderId;
  final SingleOrderStatus newStatus;
  final SingleOrderStatus? lastStatus;

  TrackStatusUpdatedState({
    required this.orderId,
    required this.newStatus,
    this.lastStatus,
  });
}
