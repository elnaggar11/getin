import 'dart:async';
import 'package:flutter/material.dart';

class AutoTextSlider extends StatefulWidget {
  final List<String> texts;
  final Duration duration;

  const AutoTextSlider({
    super.key,
    required this.texts,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AutoTextSlider> createState() => _AutoTextSliderState();
}

class _AutoTextSliderState extends State<AutoTextSlider> {
  int currentIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(widget.duration, (t) {
      setState(() {
        currentIndex = (currentIndex + 1) % widget.texts.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.texts);

    if (widget.texts.isEmpty) {
      return const SizedBox();
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Text(
        widget.texts[currentIndex],
        key: ValueKey(currentIndex),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
