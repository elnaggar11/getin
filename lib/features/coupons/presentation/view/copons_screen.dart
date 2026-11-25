import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/coupons/domain/model/coupon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/light_theme.dart';
import '../../../../shared/back_widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/features/coupons/presentation/cubit/coupon_cubit.dart';
import 'package:getincoffee/features/coupons/presentation/cubit/coupon_states.dart';

class CoponsScreen extends StatefulWidget {
  const CoponsScreen({super.key});

  @override
  State<CoponsScreen> createState() => _CoponsScreenState();
}

class _CoponsScreenState extends State<CoponsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch coupons when the screen initializes
    // context.read<CouponCubit>().getCoupons();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CouponCubit()..getCoupons(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          centerTitle: false,
          title: Text(
            LocalizationHelper.tr.discount_coupons,
            style: const TextStyle(
              color: LightThemeColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocBuilder<CouponCubit, CouponState>(
          builder: (context, state) {
            if (state is CouponLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CouponError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is CouponLoaded) {
              final coupons = state.coupons;
              if (coupons.isEmpty) {
                return const Center(
                  child: Text('No coupons available'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  final coupon = coupons[index];
                  return CoponItem(
                    coupon: coupon,
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class CoponItem extends StatelessWidget {
  const CoponItem({super.key, required this.coupon});

  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 30,
      ),
      decoration: BoxDecoration(
        color: LightThemeColors.darkwhite,
        borderRadius: BorderRadius.circular(
          40,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    24,
                  ),
                  color: LightThemeColors.primary,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    SvgAssets.start,
                  ),
                ),
              ),
              10.pw,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.name ?? '',
                    style: TextStyles.font16BlackSemiBold.copyWith(
                      color: LightThemeColors.grey,
                    ),
                  ),
                  2.ph,
                  Row(
                    children: [
                      Text(
                        "₺${coupon.value}",
                        style: TextStyles.font12BlackBold.copyWith(
                          color: LightThemeColors.lightgrey,
                        ),
                      ),
                      16.pw,
                      Text(
                        "${coupon.code}",
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.regular,
                          color: LightThemeColors.grey,
                        ),
                      ),
                      16.pw,
                      Text(
                        "${coupon.used} Left",
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.regular,
                          color: LightThemeColors.grey,
                        ),
                      ),
                      16.pw
                    ],
                  ),
                ],
              )
            ],
          ),
          23.ph,
          Row(
            children: [
              Text(
                "Min.",
                style: TextStyles.font12BlackBold.copyWith(
                  color: LightThemeColors.lightgrey,
                ),
              ),
              16.pw,
              Text(
                "Order ${coupon.usageLimit} ₺",
                style: TextStyles.font12BlackBold.copyWith(
                  fontWeight: FontWeights.regular,
                  color: LightThemeColors.grey,
                ),
              ),
              16.pw,
              Text(
                "Expires on ${coupon.endDate}",
                style: TextStyles.font12BlackBold.copyWith(
                  fontWeight: FontWeights.semiBold,
                  color: LightThemeColors.error,
                ),
              ),
              16.pw
            ],
          ),
          23.ph,
          InkWell(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: coupon.code ?? ''));
              Alerts.snack(
                  text: LocalizationHelper.tr.coupon_code_copied,
                  state: SnackState.success);
              Navigator.of(context)
                  .pop({'id': coupon.id, 'branchId': coupon.branchId});
            },
            child: Row(
              children: [
                Text(
                  LocalizationHelper.tr.use_now,
                  style: TextStyles.font12BlackBold.copyWith(
                    color: LightThemeColors.primary,
                    fontWeight: FontWeights.semiBold,
                  ),
                ),
                12.pw,
                const Icon(
                  Icons.arrow_forward,
                  color: LightThemeColors.primary,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
