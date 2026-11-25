import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/extensions/all_extensions.dart';
import '../../core/services/alerts.dart';

class SnackDesgin extends StatelessWidget {
  const SnackDesgin(
      {super.key,
      required this.text,
      this.state = SnackState.success,
      this.align});

  final String text;
  final SnackState state;
  final AlignmentGeometry? align;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align ?? Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 250,
            child: text.text(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start,
              fontSize: 14,
            ),
          ),
          10.width,
          state == SnackState.success
              ? SvgPicture.asset(
                  SvgAssets.like,
                )
              : SvgPicture.asset(
                  SvgAssets.dislike,
                ),
        ],
      ).setContainerToView(
        borderRadius: BorderRadius.circular(40),
        width: 320,
        color: state == SnackState.success
            ? LightThemeColors.primary
            : LightThemeColors.error,
        margin: 20,
        marginGeometry:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        radius: 8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
