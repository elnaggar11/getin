import 'package:getincoffee/core/generated/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

class MyLoading {
  static bool shown = false;

  static show({
    bool fullScreen = false,
  }) {
    if (shown == false) {
      SmartDialog.show(
          clickMaskDismiss: false,
          animationType: SmartAnimationType.scale,
          animationTime: const Duration(milliseconds: 100),
          keepSingle: true,
          builder: (context) => fullScreen
              ? const SmoothLoadingLogo()
              : Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.transparent,
                      child: const SmoothLoadingLogo())));

      shown = true;
    }
  }

  static Center loadingWidget() =>
      const Center(child: CircularProgressIndicator());
  static Center loadingWidget2() =>
      const Center(child: CircularProgressIndicator());

  static dismis() {
    if (shown) {
      SmartDialog.dismiss();
      shown = false;
    } else {}
  }
}

class MySuccess {
  static bool shown = false;

  static show({
    bool fullScreen = false,
  }) {
    if (shown == false) {
      SmartDialog.show(
          clickMaskDismiss: false,
          animationType: SmartAnimationType.scale,
          animationTime: const Duration(milliseconds: 100),
          keepSingle: true,
          builder: (context) => fullScreen
              ? const SuccessWidget()
              : const Dialog(
                  child: SizedBox(
                      width: 200, height: 200, child: SuccessWidget())));

      shown = true;
    }
  }

  // static Center SuccessWidget() =>  Center(child: Lottie.asset(JsonAssets.success));

  static dismis() {
    if (shown) {
      SmartDialog.dismiss();
      shown = false;
    } else {}
  }
}

class SuccessWidget extends StatefulWidget {
  const SuccessWidget({super.key});

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      MySuccess.dismis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(JsonAssets.success));
  }
}

class SmoothLoadingLogo extends StatefulWidget {
  const SmoothLoadingLogo({super.key});

  @override
  State<SmoothLoadingLogo> createState() => _SmoothLoadingLogoState();
}

class _SmoothLoadingLogoState extends State<SmoothLoadingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // smoother
    )..repeat(reverse: true);

    _opacity = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _opacity,
        child: Image.asset(
          ImgAssets.primaryLogo,
        ),
      ),
    );
  }
}
