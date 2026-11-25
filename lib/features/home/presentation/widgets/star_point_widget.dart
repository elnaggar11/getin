import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StarPointWidget extends StatelessWidget {
  const StarPointWidget({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 30,
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: LightThemeColors.primary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '+',
            style: TextStyle(
              color: Color(0xFFFFDC17),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            '$count',
            style: const TextStyle(
              color: Color(0xFFFFDC17),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 3),
          SvgPicture.asset(
            SvgAssets.Star,
            width: 12,
            height: 12,
          ),
        ],
      ),
    );
  }
}
