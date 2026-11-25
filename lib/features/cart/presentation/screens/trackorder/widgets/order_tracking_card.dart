import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/cubit/track_cubit.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/cubit/track_states.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/widgets/track_item.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';
import 'package:getincoffee/features/myorder/domain/model/single_order_status.dart';

class OrderTrackingCard extends StatelessWidget {
  const OrderTrackingCard({super.key, required this.orderItemModel});

  final SingleOrderModel? orderItemModel;

  bool get _isDeliveryOrder => orderItemModel?.userLocation != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: LightThemeColors.cardBackground,
      ),
      child: BlocBuilder<TrackCubit, TrackStates>(
        builder: (context, state) {
          // Prefer the live FCM status; fall back to the model's initial status.
          final liveStatus = state is TrackStatusUpdatedState
              ? state.newStatus
              : orderItemModel?.singleOrderStatus;
          final lastStatus = state is TrackStatusUpdatedState
              ? state.lastStatus ?? orderItemModel?.singleOrderStatus
              : orderItemModel?.lastStatus;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.ph,
              OrderItemHeader(orderItemModel: orderItemModel),
              40.ph,
              if (_isDeliveryOrder)
                DeliveryTrackingSteps(
                  orderStatus: liveStatus,
                  lastStatus: lastStatus,
                )
              else
                PickupTrackingSteps(
                  orderStatus: liveStatus,
                  lastStatus: lastStatus,
                ),
            ],
          );
        },
      ),
    );
  }
}

class OrderItemHeader extends StatelessWidget {
  const OrderItemHeader({super.key, required this.orderItemModel});

  final SingleOrderModel? orderItemModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const OrderIconContainer(),
            10.pw,
            OrderInfoText(orderItemModel: orderItemModel),
          ],
        ),
        //  SvgPicture.asset(SvgAssets.settings),
      ],
    );
  }
}

class OrderIconContainer extends StatelessWidget {
  const OrderIconContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        color: LightThemeColors.primary,
      ),
      child: Center(
        child: SvgPicture.asset(SvgAssets.emptyCart),
      ),
    );
  }
}

class OrderInfoText extends StatelessWidget {
  const OrderInfoText({super.key, required this.orderItemModel});

  final SingleOrderModel? orderItemModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          orderItemModel?.items?.first.product_name ?? '',
          style: TextStyles.font14BlackMedium.copyWith(
            color: LightThemeColors.primary,
          ),
        ),
        Text(
          "ID : #${orderItemModel?.id ?? ''}",
          style: TextStyles.font12BlackLight.copyWith(
            color: LightThemeColors.grey,
            fontWeight: FontWeights.regular,
          ),
        ),
      ],
    );
  }
}

class DeliveryTrackingSteps extends StatelessWidget {
  const DeliveryTrackingSteps({
    super.key,
    required this.orderStatus,
    this.lastStatus,
  });

  final SingleOrderStatus? orderStatus;
  final SingleOrderStatus? lastStatus;

  @override
  Widget build(BuildContext context) {
    final status = orderStatus?.driverStatus ?? 0;
    final isCanceled = orderStatus == SingleOrderStatus.canceled;
    final showAll = !isCanceled || lastStatus == null;
    final lastDriverStatus = lastStatus?.driverStatus ?? 4;

    return Column(
      children: [
        TrackItem(
          icon: SvgAssets.done,
          title: LocalizationHelper.tr.order_received,
          isDone: true,
          isLast: false,
        ),
        8.ph,
        if (showAll || lastDriverStatus >= 2) ...[
          TrackItem(
            icon: SvgAssets.preparing,
            title: LocalizationHelper.tr.preparing,
            isDone: showAll ? status >= 2 : true,
            isLast: false,
          ),
          8.ph,
        ],
        if (showAll || lastDriverStatus >= 3) ...[
          TrackItem(
            icon: SvgAssets.ready,
            title: LocalizationHelper.tr.on_the_way,
            isDone: showAll ? status >= 3 : true,
            isLast: false,
          ),
          8.ph,
        ],
        TrackItem(
          icon: isCanceled ? SvgAssets.cancel : SvgAssets.complete,
          title: isCanceled
              ? LocalizationHelper.tr.cancelled
              : LocalizationHelper.tr.completed,
          isDone: status >= 4,
          isCanceled: isCanceled,
          isLast: true,
        ),
      ],
    );
  }
}

class PickupTrackingSteps extends StatelessWidget {
  const PickupTrackingSteps({
    super.key,
    required this.orderStatus,
    this.lastStatus,
  });

  final SingleOrderStatus? orderStatus;
  final SingleOrderStatus? lastStatus;

  @override
  Widget build(BuildContext context) {
    final status = orderStatus?.pickupStatus ?? 0;
    final isCanceled = orderStatus == SingleOrderStatus.canceled;
    final showAll = !isCanceled || lastStatus == null;
    final lastPickupStatus = lastStatus?.pickupStatus ?? 4;

    return Column(
      children: [
        TrackItem(
          icon: SvgAssets.done,
          title: LocalizationHelper.tr.order_received,
          isDone: showAll ? status >= 1 : true,
          isLast: false,
        ),
        8.ph,
        if (showAll || lastPickupStatus >= 2) ...[
          TrackItem(
            icon: SvgAssets.preparing,
            title: LocalizationHelper.tr.preparing,
            isDone: showAll ? status >= 2 : true,
            isLast: false,
          ),
          8.ph,
        ],
        if (showAll || lastPickupStatus >= 3) ...[
          TrackItem(
            icon: SvgAssets.ready,
            title: LocalizationHelper.tr.ready_to_pick_up,
            isDone: showAll ? status >= 3 : true,
            isLast: false,
          ),
          8.ph,
        ],
        TrackItem(
          icon: isCanceled ? SvgAssets.cancel : SvgAssets.complete,
          title: isCanceled
              ? LocalizationHelper.tr.cancelled
              : LocalizationHelper.tr.completed,
          isDone: status >= 4,
          isCanceled: isCanceled,
          isLast: true,
        ),
      ],
    );
  }
}
