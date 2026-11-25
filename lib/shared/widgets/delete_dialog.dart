import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:getincoffee/core/resources/text_style_manager.dart';

class DeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String title;
  final String subTitle;

  const DeleteDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 80,
              width: 80,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: LightThemeColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                SvgAssets.delete,
                colorFilter: const ColorFilter.mode(
                  LightThemeColors.error,
                  BlendMode.srcIn,
                ),
              ),
            ),
            24.ph,
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStylesManager.aristaBold.copyWith(
                fontSize: 20,
                color: LightThemeColors.textPrimary,
              ),
            ),
            12.ph,
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStylesManager.aristaRegular.copyWith(
                fontSize: 16,
                color: LightThemeColors.textSecondary,
                height: 1.5,
              ),
            ),
            32.ph,
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(
                          color: LightThemeColors.dividercolor,
                        ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStylesManager.aristaBold.copyWith(
                        fontSize: 16,
                        color: LightThemeColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                16.pw,
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: LightThemeColors.error,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStylesManager.aristaBold.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
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
