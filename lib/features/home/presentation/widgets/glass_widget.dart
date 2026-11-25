import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCircleButton extends StatelessWidget {
  final double size;
  final Widget child;
  final VoidCallback? onTap;

  const GlassCircleButton({
    super.key,
    this.size = 40,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final button = ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: .3),
                Colors.white.withValues(alpha: .1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: .4),
              width: 1.5,
            ),
            // Add a subtle shadow for contrast on light backgrounds
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );

    return onTap == null
        ? button
        : GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.translucent,
            child: button,
          );
  }
}
