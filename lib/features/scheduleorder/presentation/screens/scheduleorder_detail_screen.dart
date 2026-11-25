import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/presentation/widgets/delete_bottomsheet.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';
import 'package:getincoffee/features/scheduleorder/cubit/scheduleorder_cubit.dart';
import 'package:getincoffee/features/scheduleorder/cubit/scheduleorder_states.dart';
import 'package:getincoffee/features/scheduleorder/domain/model/scheduleorder_model.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:getincoffee/core/Router/Router.dart';

class ScheduleOrderDetailScreen extends StatelessWidget {
  const ScheduleOrderDetailScreen({super.key, required this.item});
  final ScheduleorderModel item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleorderCubit(),
      child: BlocConsumer<ScheduleorderCubit, ScheduleorderStates>(
        listener: (context, state) {
          if (state is DeleteScheduleorderSuccess) {
            Alerts.snack(
              text: LocalizationHelper.tr.operation_completed_successfully,
              state: SnackState.success,
            );
            Navigator.pop(context, "refresh");
          }
          if (state is DeleteScheduleorderFailed) {
            Alerts.snack(
              text: LocalizationHelper.tr.something_went_wrong,
              state: SnackState.failed,
            );
          }
        },
        builder: (context, state) {
          final cubit = ScheduleorderCubit.get(context);
          return LoadingAndError(
            isLoading: state is DeleteScheduleorderLoading,
            isError: false,
            child: Scaffold(
              appBar: AppBar(
                leading: const BackWidget(),
                centerTitle: false,
                title: Text(
                  LocalizationHelper.tr.order_details,
                  style: const TextStyle(
                    color: LightThemeColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Alerts.bottomSheet(
                        context,
                        child: ActionBottomSheet(
                          onConfirm: () {
                            cubit.deleteScheduleOrder(id: item.id ?? "");
                          },
                        ),
                      );
                    },
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: LightThemeColors.error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: LightThemeColors.error,
                        size: 20,
                      ),
                    ),
                  ),
                  8.pw,
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.QrScreen,
                        arguments: item.id,
                      );
                    },
                    icon: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: LightThemeColors.primary,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          SvgAssets.scanIcon,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.ph,
                    // Order Status Card
                    _buildStatusCard(),
                    20.ph,
                    // Branch Info Card
                    _buildBranchCard(),
                    20.ph,
                    // Order Info Card
                    _buildOrderInfoCard(),
                    20.ph,
                    // Items Section
                    if (item.items != null && item.items!.isNotEmpty) ...[
                      Text(
                        LocalizationHelper.tr.product,
                        style: TextStyles.font16BlackSemiBold.copyWith(
                          color: LightThemeColors.primary,
                        ),
                      ),
                      12.ph,
                      ...item.items!
                          .map((orderItem) => _buildProductItem(orderItem)),
                    ],
                    20.ph,
                    // Price Summary Card
                    _buildPriceSummaryCard(),
                    100.ph,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    switch (item.status?.toLowerCase()) {
      case 'completed':
        statusColor = LightThemeColors.primary;
        break;
      case 'cancelled':
      case 'canceled':
        statusColor = LightThemeColors.error;
        break;
      default:
        statusColor = const Color.fromARGB(255, 239, 166, 8);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: LightThemeColors.primary,
            ),
            child: Center(
              child: SvgPicture.asset(
                SvgAssets.sechdualOrderIcon,
              ),
            ),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${item.id ?? ""}",
                  style: TextStyles.font16BlackSemiBold.copyWith(
                    color: LightThemeColors.primary,
                  ),
                ),
                4.ph,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status ?? LocalizationHelper.tr.status_pending,
                    style: TextStyles.font12BlackBold.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: DefaultImageWidget(
              item.branch?.image ?? "",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.branch?.name ?? "",
                  style: TextStyles.font16BlackSemiBold.copyWith(
                    color: LightThemeColors.primary,
                  ),
                ),
                4.ph,
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: LightThemeColors.grey,
                    ),
                    4.pw,
                    Expanded(
                      child: Text(
                        item.branch?.description ?? "",
                        style: TextStyles.font12BlackBold.copyWith(
                          color: LightThemeColors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.access_time_rounded,
            label: LocalizationHelper.tr.order_receipt_time,
            value: item.orderReceiptTime ?? "",
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.calendar_today_rounded,
            label: LocalizationHelper.tr.order_date,
            value: item.createdAt ?? "",
          ),
          if (item.userLocation != null) ...[
            const Divider(height: 24),
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: LocalizationHelper.tr.location,
              value: item.userLocation?.name_address ?? "",
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: LightThemeColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: LightThemeColors.primary,
            size: 20,
          ),
        ),
        16.pw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyles.font12BlackBold.copyWith(
                  color: LightThemeColors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              4.ph,
              Text(
                value,
                style: TextStyles.font14BlackMedium.copyWith(
                  color: LightThemeColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(OrderItemModel orderItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: DefaultImageWidget(
              orderItem.image ?? "",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderItem.product_name ?? "",
                  style: TextStyles.font14BlackMedium.copyWith(
                    color: LightThemeColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                4.ph,
                Text(
                  "x${orderItem.quantity ?? "1"}",
                  style: TextStyles.font12BlackBold.copyWith(
                    color: LightThemeColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "₺${orderItem.total_price ?? "0.00"}",
            style: TextStyles.font14BlackMedium.copyWith(
              color: LightThemeColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow(
            label: LocalizationHelper.tr.subtotal,
            value: "₺${item.subTotal ?? "0.00"}",
          ),
          12.ph,
          const Divider(height: 24),
          _buildPriceRow(
            label: LocalizationHelper.tr.total,
            value: "₺${item.total_price ?? "0.00"}",
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyles.font14BlackMedium.copyWith(
            color: isBold ? LightThemeColors.primary : LightThemeColors.grey,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyles.font14BlackMedium.copyWith(
            color: LightThemeColors.primary,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
