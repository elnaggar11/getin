import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/features/myorder/domain/model/single_order_status.dart';

import 'track_states.dart';

class TrackCubit extends Cubit<TrackStates> {
  TrackCubit() : super(TrackInitial());

  static TrackCubit get(context) => BlocProvider.of(context);

  /// The live order status for the current session.
  SingleOrderStatus? currentStatus;

  StreamSubscription<RemoteMessage>? _foregroundSub;
  StreamSubscription<RemoteMessage>? _backgroundOpenedSub;

  /// Call once after the cubit is created, passing the order's id.
  /// Safe to call multiple times — previous subscriptions are cancelled first.
  void listenToOrderStatusUpdates(String orderId) {
    _foregroundSub?.cancel();
    _backgroundOpenedSub?.cancel();

    _foregroundSub = FirebaseMessaging.onMessage.listen(
      (message) => _handleMessage(message, orderId),
    );

    _backgroundOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _handleMessage(message, orderId),
    );
  }

  void _handleMessage(RemoteMessage message, String orderId) {
    final data = message.data;
    final type = data['type']?.toString();
    final receivedOrderId = data['order_id']?.toString();
    final orderStatus = data['order_status']?.toString();
    final lastorderStatus = data['last_status']?.toString();

    log('FCM data: $data', name: 'TrackCubit');

    if (type == 'order' && receivedOrderId == orderId && orderStatus != null) {
      final newStatus = SingleOrderStatusMapper.fromApi(orderStatus);
      SingleOrderStatus? newLastStatus;
      if (lastorderStatus != null &&
          lastorderStatus.trim().isNotEmpty &&
          lastorderStatus != 'null') {
        newLastStatus = SingleOrderStatusMapper.fromApi(lastorderStatus);
      } else {
        newLastStatus = currentStatus;
      }
      currentStatus = newStatus;
      log('Order $orderId status → $newStatus', name: 'TrackCubit');

      emit(TrackStatusUpdatedState(
        orderId: orderId,
        newStatus: newStatus,
        lastStatus: newLastStatus,
      ));
    }
  }

  /// Apply a status received while the app was terminated (killed).
  void applyPendingStatus(SingleOrderStatus status, {String orderId = ''}) {
    currentStatus = status;
    emit(TrackStatusUpdatedState(
      orderId: orderId,
      newStatus: status,
    ));
  }

  @override
  Future<void> close() {
    _foregroundSub?.cancel();
    _backgroundOpenedSub?.cancel();
    return super.close();
  }
}
