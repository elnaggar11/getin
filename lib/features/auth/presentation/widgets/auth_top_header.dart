import 'package:flutter/material.dart';
import '../../../../core/generated/images.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../core/utils/extentions.dart';

class AuthTopHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showLogo;
  final bool showBack;
  final VoidCallback? onBackTap;
  final Widget? customIcon;

  const AuthTopHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = true,
    this.showBack = false,
    this.onBackTap,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: LightThemeColors.primary,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Subtle luxury ambient decorative circle
          PositionedDirectional(
            top: -40,
            end: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LightThemeColors.white.withOpacity(0.04),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LightThemeColors.white.withOpacity(0.03),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showBack)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: InkWell(
                      onTap: onBackTap ?? () => Navigator.maybePop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: LightThemeColors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: LightThemeColors.white.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: LightThemeColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                if (showLogo) ...[
                  Image.asset(
                    ImgAssets.primaryLogo,
                    width: 160,
                    height: 44,
                    fit: BoxFit.contain,
                  ),
                  12.ph,
                ],
                if (customIcon != null) ...[
                  customIcon!,
                  14.ph,
                ],
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    title,
                    key: ValueKey<String>(title),
                    textAlign: TextAlign.center,
                    style: TextStyles.font18BlackBold.copyWith(
                      color: LightThemeColors.white,
                      fontSize: 24,
                      fontWeight: FontWeights.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                6.ph,
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    subtitle,
                    key: ValueKey<String>(subtitle),
                    textAlign: TextAlign.center,
                    style: TextStyles.font16BlackRegular.copyWith(
                      color: LightThemeColors.white.withOpacity(0.82),
                      fontSize: 14,
                      height: 1.4,
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
}

