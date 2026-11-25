import 'package:flutter/material.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/widgets/scan_button.dart';
import 'package:getincoffee/features/myorder/domain/model/myorder_model.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';

class SourceDataSection extends StatelessWidget {
  const SourceDataSection({super.key, this.orderItemModel});

  final SingleOrderModel? orderItemModel;

  bool get _isPickupOrder => orderItemModel?.userLocation == null;

  @override
  Widget build(BuildContext context) {
    if (_isPickupOrder) {
      return BranchInfoRow(orderItemModel: orderItemModel);
    }
    if (orderItemModel?.driver == null) {
      return const SizedBox.shrink();
    }
    return DriverInfoRow(orderItemModel: orderItemModel);
  }
}

class BranchInfoRow extends StatelessWidget {
  const BranchInfoRow({super.key, this.orderItemModel});

  final SingleOrderModel? orderItemModel;

  @override
  Widget build(BuildContext context) {
    final branch = orderItemModel?.branch;
    return SourceDataRow(
      image: branch?.image ?? "",
      title: branch?.name ?? "",
      subtitle: branch?.deliveryTime ?? "",
      onScanTap: () => Navigator.pop(context),
    );
  }
}

class DriverInfoRow extends StatelessWidget {
  const DriverInfoRow({super.key, this.orderItemModel});

  final SingleOrderModel? orderItemModel;

  @override
  Widget build(BuildContext context) {
    final driver = orderItemModel?.driver;
    return SourceDataRow(
      image: driver?.image ?? "",
      title: driver?.firstName ?? "",
      subtitle: LocalizationHelper.tr.delivery_man,
      onScanTap: () => Navigator.pop(context),
    );
  }
}

class SourceDataRow extends StatelessWidget {
  const SourceDataRow({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onScanTap,
  });

  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onScanTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SourceDataImage(image: image),
            10.pw,
            SourceDataText(title: title, subtitle: subtitle),
          ],
        ),
        ScanButton(onTap: onScanTap),
      ],
    );
  }
}

class SourceDataImage extends StatelessWidget {
  const SourceDataImage({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return DefaultImageWidget(
      image,
      width: 58,
      height: 58,
      radius: 29,
      fit: BoxFit.cover,
    );
  }
}

class SourceDataText extends StatelessWidget {
  const SourceDataText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.font14BlackBold.copyWith(
            fontWeight: FontWeights.semiBold,
            color: LightThemeColors.primary,
          ),
        ),
        3.ph,
        Text(
          subtitle,
          style: TextStyles.font12BlackLight.copyWith(
            fontWeight: FontWeights.regular,
            color: LightThemeColors.lightgrey,
          ),
        ),
      ],
    );
  }
}
