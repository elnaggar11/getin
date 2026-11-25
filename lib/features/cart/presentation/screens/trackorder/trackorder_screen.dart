import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/core/utils/firebase_message.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/cubit/track_cubit.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/cubit/track_states.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/widgets/order_tracking_card.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/widgets/source_data_section.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';
import 'package:getincoffee/features/myorder/domain/model/single_order_status.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';

class TrackorderScreen extends StatefulWidget {
  const TrackorderScreen({super.key, this.orderItemModel});

  final SingleOrderModel? orderItemModel;

  @override
  State<TrackorderScreen> createState() => _TrackorderScreenState();
}

class _TrackorderScreenState extends State<TrackorderScreen> {
  late final TrackCubit _cubit;
  bool _ownsCubit = false;

  @override
  void initState() {
    super.initState();

    // Try to reuse the cubit provided by PaymentScreen via BlocProvider.value.
    // If not present (e.g. opened from MyOrders), create a local one.
    try {
      _cubit = TrackCubit.get(context);
    } catch (_) {
      _cubit = TrackCubit();
      _ownsCubit = true;
    }

    final orderId = widget.orderItemModel?.id;
    if (orderId != null && orderId.isNotEmpty) {
      _cubit.listenToOrderStatusUpdates(orderId);

      // Terminated-state: app was killed, user tapped notification.
      final pending = FBMessaging.pendingOrderUpdate;
      if (pending != null &&
          pending.orderId == orderId &&
          pending.orderStatus != null) {
        FBMessaging.pendingOrderUpdate = null; // consume once
        final newStatus = SingleOrderStatusMapper.fromApi(pending.orderStatus!);
        _cubit.applyPendingStatus(newStatus, orderId: orderId);
        log('Applied terminated-state status: $orderId → ${pending.orderStatus}',
            name: 'TrackorderScreen');
      }
    }

    _logFcmToken();
  }

  @override
  void dispose() {
    // Only close the cubit if this screen created it (not the PaymentScreen).
    if (_ownsCubit) _cubit.close();
    super.dispose();
  }

  Future<void> _logFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    log(token ?? 'No FCM token', name: 'FCM Token');
  }

  @override
  Widget build(BuildContext context) {
    log(Utils.FCMToken.toString(), name: 'FCM Token');
    // If we own the cubit (no PaymentScreen parent), provide it ourselves.
    final scaffold = Scaffold(
      backgroundColor: LightThemeColors.primary,
      appBar: const TrackOrderAppBar(),
      body: TrackOrderBody(orderItemModel: widget.orderItemModel),
    );

    if (_ownsCubit) {
      return BlocProvider.value(value: _cubit, child: scaffold);
    }
    return scaffold;
  }
}

class TrackOrderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TrackOrderAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(109);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        LocalizationHelper.tr.track_order,
        style: TextStyles.font20WhiteSemiBold.copyWith(
          color: LightThemeColors.white,
        ),
      ),
      toolbarHeight: 109,
      backgroundColor: LightThemeColors.primary,
      automaticallyImplyLeading: false,
      leading: const Icon(
        Icons.arrow_back_sharp,
        color: LightThemeColors.white,
      ).onTap(() => Navigator.pop(context)),
    );
  }
}

class TrackOrderBody extends StatelessWidget {
  const TrackOrderBody({super.key, this.orderItemModel});

  final SingleOrderModel? orderItemModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: LightThemeColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            25.ph,
            SourceDataSection(orderItemModel: orderItemModel),
            25.ph,
            const OrderDetailsHeader(),
            15.ph,
            OrderTrackingCard(orderItemModel: orderItemModel),
            22.ph,
            QrCodeButton(orderItemModel: orderItemModel),
            12.ph,
          ],
        ),
      ),
    );
  }
}

class OrderDetailsHeader extends StatelessWidget {
  const OrderDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        LocalizationHelper.tr.order_details,
        style: TextStyles.font14BlackBold.copyWith(
          fontWeight: FontWeights.semiBold,
          color: LightThemeColors.black,
        ),
      ),
    );
  }
}

class QrCodeButton extends StatelessWidget {
  const QrCodeButton({super.key, this.orderItemModel});

  final SingleOrderModel? orderItemModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackCubit, TrackStates>(
      builder: (context, state) {
        final cubit = TrackCubit.get(context);
        final currentStatus = state is TrackStatusUpdatedState
            ? state.newStatus
            : orderItemModel?.singleOrderStatus;
        final isComplete = currentStatus == SingleOrderStatus.completed;

        return ButtonWidget(
          title: isComplete
              ? LocalizationHelper.tr.go_to_home
              : LocalizationHelper.tr.open_qr_code,
          onTap: () {
            if (isComplete) {
              NavigationHelper.popUntilRoute(
                Routes.layoutScreen,
                result: 1,
              );
            } else {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }
}
