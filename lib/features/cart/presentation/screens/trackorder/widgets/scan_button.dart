import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/theme/light_theme.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: LightThemeColors.primary,
        ),
        child: Center(
          child: SvgPicture.asset(SvgAssets.scanIcon),
        ),
      ),
    );
  }
}
