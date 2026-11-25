import 'dart:developer';

import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/core/general/cubit/general_cubit.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';

class DeliveryToggle extends StatefulWidget {
  const DeliveryToggle({super.key});

  @override
  State<DeliveryToggle> createState() => _DeliveryToggleState();
}

class _DeliveryToggleState extends State<DeliveryToggle> {
  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.get(context);
    log(cubit.currentBranch?.isDelivery.toString() ?? '',
        name: 'DeliveryToggle');

    return BlocBuilder<GeneralCubit, GeneralState>(
      builder: (context, state) {
        final generalCubit = GeneralCubit.get(context);
        log(generalCubit.deliveryType.toString(), name: 'DeliveryToggle');
        return Container(
          height: 48,
          margin: const EdgeInsetsDirectional.only(start: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: LightThemeColors.offwhite,
          ),
          padding: const EdgeInsets.all(5),
          child: IntrinsicWidth(
            child: Row(
              children: [
                if (cubit.currentBranch?.isDelivery == true)
                  _buildOption(LocalizationHelper.tr.delivery, 0, generalCubit),
                _buildOption(LocalizationHelper.tr.pickup, 1, generalCubit),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(String text, int index, GeneralCubit generalCubit) {
    final bool isSelected = generalCubit.deliveryType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => generalCubit.updateDeliveryType(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? LightThemeColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? LightThemeColors.white : Colors.black,
              fontWeight: FontWeights.medium,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
