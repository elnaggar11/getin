import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/addresses/domain/request/addresses_request.dart';
import 'package:getincoffee/features/myorder/cubit/myorder_cubit.dart';
import 'package:getincoffee/features/myorder/cubit/myorder_states.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/localization/localization_helper.dart';

class CancelBottomSheet extends StatefulWidget {
  const CancelBottomSheet({
    super.key,
    this.delete,
  });
  final VoidCallback? delete;
  @override
  State<CancelBottomSheet> createState() => _CreateAddreessSheetBodyState();
}

class _CreateAddreessSheetBodyState extends State<CancelBottomSheet> {
  AddressRequest addressRequest = AddressRequest();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<MyorderCubit, MyorderStates>(
      listener: (context, state) {
        if (state is CancelOrderSuccessState) {
          Navigator.pop(context);
        }
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height * .5,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                61.ph,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationHelper.tr.order_deletion_notice,
                      style: TextStyles.font14BlackMedium.copyWith(
                        color: LightThemeColors.black,
                        fontWeight: FontWeights.extraBold,
                      ),
                    ),
                    SvgPicture.asset(
                      SvgAssets.cancel,
                    ),
                  ],
                ),
                20.ph,
                const Divider(
                  thickness: 1,
                  height: 0,
                  color: LightThemeColors.darkwhite,
                ),
                30.ph,
                Center(
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: LightThemeColors.error,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        width: 20,
                        height: 20,
                        SvgAssets.delete,
                        colorFilter: const ColorFilter.mode(
                          LightThemeColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                20.ph,
                Center(
                  child: SizedBox(
                    width: 350,
                    child: Text(
                      textAlign: TextAlign.center,
                      LocalizationHelper.tr.order_deletion_warning,
                      style: TextStyles.font22BlackBlack.copyWith(
                        color: LightThemeColors.black,
                        fontWeight: FontWeights.extraBold,
                      ),
                    ),
                  ),
                ),
                20.ph,
                Center(
                  child: Text(
                    LocalizationHelper.tr.irreversible_action,
                    textAlign: TextAlign.center,
                    style: TextStyles.font12BlackBold.copyWith(
                      fontWeight: FontWeight.bold,
                      color: LightThemeColors.lightgrey,
                    ),
                  ),
                ),
                30.ph,
                Row(
                  children: [
                    Expanded(
                        child: ButtonWidget(
                      onTap: widget.delete,
                      title: LocalizationHelper.tr.delete,
                      buttonColor: LightThemeColors.error,
                    )),
                    6.pw,
                    Expanded(
                        child: ButtonWidget(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      title: LocalizationHelper.tr.cancel,
                      buttonColor: LightThemeColors.black,
                    ))
                  ],
                ),
                37.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
