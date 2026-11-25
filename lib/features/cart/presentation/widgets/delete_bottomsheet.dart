import 'package:flutter/material.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';

class ActionBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconBackgroundColor;
  final String? confirmText;
  final String? cancelText;
  final Color? confirmButtonColor;
  final VoidCallback? onConfirm;

  const ActionBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.iconBackgroundColor,
    this.confirmText,
    this.cancelText,
    this.confirmButtonColor,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    // Use localization defaults if values are null
    final title1 = title ?? LocalizationHelper.tr.are_you_sure;
    final subtitle1 =
        subtitle ?? LocalizationHelper.tr.action_reversible_message;
    final icon1 = icon ?? Icons.warning;
    final iconBg = iconBackgroundColor ?? Colors.red;
    final confirmText1 = confirmText ?? LocalizationHelper.tr.confirm;
    final cancelText1 = cancelText ?? LocalizationHelper.tr.cancel;
    final confirmColor1 = confirmButtonColor ?? Colors.red;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, color: Colors.grey, size: 24),
            ),
          ),
          const SizedBox(height: 16),

          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon1, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            title1,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            subtitle1,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor1,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    confirmText1,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    cancelText1,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
