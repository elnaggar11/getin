import 'package:flutter/material.dart';
import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';

class AuthTabSelector extends StatelessWidget {
  final TabController controller;
  final List<String> titles;
  final ValueChanged<int>? onTap;

  const AuthTabSelector({
    super.key,
    required this.controller,
    required this.titles,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: LightThemeColors.primary.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: controller,
        dividerHeight: 0,
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicator: BoxDecoration(
          color: LightThemeColors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: LightThemeColors.primary,
        unselectedLabelColor: LightThemeColors.lightgrey,
        labelStyle: TextStyles.font14BlackBold.copyWith(
          fontWeight: FontWeights.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyles.font14BlackMedium.copyWith(
          fontWeight: FontWeights.medium,
          fontSize: 14,
        ),
        tabs: titles.map((title) => Tab(text: title)).toList(),
      ),
    );
  }
}

