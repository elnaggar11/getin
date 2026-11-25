import 'package:flutter/material.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';

class ReorderConfirmationDialog extends StatelessWidget {
  final List<dynamic> unavailableItems;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ReorderConfirmationDialog({
    super.key,
    required this.unavailableItems,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 48,
            ),
            16.ph,
            Text(
              LocalizationHelper.tr.item_availability_update,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeights.bold,
                color: LightThemeColors.primary,
              ),
            ),
            12.ph,
            Text(
              LocalizationHelper.tr.items_unavailable_message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            16.ph,
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LightThemeColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: unavailableItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: Colors.red),
                          8.pw,
                          Expanded(
                            child: Text(
                              item['name'] ??
                                  LocalizationHelper.tr.unknown_item,
                              style: const TextStyle(
                                fontWeight: FontWeights.semiBold,
                                fontSize: 14,
                                color: LightThemeColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            24.ph,
            Text(
              LocalizationHelper.tr.proceed_with_remaining,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeights.medium,
              ),
            ),
            24.ph,
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    title: LocalizationHelper.tr.cancel,
                    onTap: onCancel,
                    buttonColor: Colors.white,
                    textColor: Colors.grey,
                    borderColor: Colors.grey.withOpacity(0.5),
                    withBorder: true,
                    height: 50,
                  ),
                ),
                12.pw,
                Expanded(
                  child: ButtonWidget(
                    title: LocalizationHelper.tr.proceed,
                    onTap: onConfirm,
                    buttonColor: LightThemeColors.primary,
                    textColor: Colors.white,
                    height: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
