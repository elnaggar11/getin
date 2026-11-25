import 'package:getincoffee/core/generated/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/core/utils/Locator.dart';
import 'package:getincoffee/features/profile/domain/repository/repository.dart';
import 'package:getincoffee/features/splash/domain/repository/splash_repository.dart';
import 'package:lottie/lottie.dart';

import '../../../cubit/splash_cubit.dart';
import '../../../cubit/splash_states.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(
        repository: locator<ProfileRepository>(),
        splashRepository: locator<SplashRepository>(),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 1, 46, 39),
        body: BlocConsumer<SplashCubit, SplashStates>(
          listener: (context, state) {},
          builder: (context, state) {
            final cubit = SplashCubit.get(context);
            return Center(
              child: Lottie.asset(
                JsonAssets.logoLottie,
                controller: _controller,
                fit: BoxFit.cover,
                // width: double.infinity,
                //height: double.infinity,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward().then((value) async {
                      if (context.mounted) {
                        final route = await cubit.checkLogin();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            route,
                            (r) => false,
                          );
                        }
                      }
                    });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
