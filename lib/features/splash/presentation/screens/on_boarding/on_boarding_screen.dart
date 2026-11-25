import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart'; // ^ flutter_html: ^3.0.0-beta.2

import '../../../../../core/Router/Router.dart';
import '../../../../../core/localization/localization_helper.dart';
import '../../../../../core/resources/font_manager.dart' hide FontSize;
import '../../../../../core/theme/light_theme.dart';
import '../../../../../core/utils/Locator.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../../profile/domain/model/setting_model.dart';
import '../../../../profile/domain/repository/repository.dart';
import '../../../cubit/splash_cubit.dart';
import '../../../cubit/splash_states.dart';
import '../../../domain/repository/splash_repository.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(
        repository: locator<ProfileRepository>(),
        splashRepository: locator<SplashRepository>(),
      )
        ..controller = PageController(initialPage: 0)
        ..getSettings(), // load features on creation
      child: BlocConsumer<SplashCubit, SplashStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = SplashCubit.get(context);
          final features = cubit.onboardingFeatures;
          final isLoading = state is GetSettingsLoading;

          return Scaffold(
            backgroundColor: LightThemeColors.white,
            body: SafeArea(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : features.isEmpty
                      ? _buildFallback(context, cubit)
                      : _OnboardingPager(cubit: cubit, features: features),
            ),
          );
        },
      ),
    );
  }

  /// Shown when settings failed to load or returned no features.
  Widget _buildFallback(BuildContext context, SplashCubit cubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          53.ph,
          Image.asset("assets/images/onboarding_image.png"),
          20.ph,
          SizedBox(
            width: double.infinity,
            child: Text(
              LocalizationHelper.tr.its_time_for_getin,
              style: TextStyles.font22BlackBlack.copyWith(
                fontSize: 34,
                fontWeight: FontWeights.medium,
                color: LightThemeColors.primary,
              ),
            ),
          ),
          5.ph,
          Text(
            LocalizationHelper.tr.coffee_experience,
            style: TextStyles.font22BlackBlack.copyWith(
              fontSize: 34,
              fontWeight: FontWeights.medium,
              color: LightThemeColors.primary,
              letterSpacing: 6,
            ),
          ),
          20.ph,
          SizedBox(
            width: 370,
            child: Text(
              LocalizationHelper.tr.onboarding_description,
              textAlign: TextAlign.center,
              style: TextStyles.font14BlackMedium.copyWith(
                height: 1.5,
                color: LightThemeColors.grey,
              ),
            ),
          ),
          const Spacer(),
          _GetStartedButton(),
          20.ph,
          if (Platform.isAndroid)
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).padding.bottom,
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pager — one page per FeaturesModel
// ---------------------------------------------------------------------------

class _OnboardingPager extends StatelessWidget {
  const _OnboardingPager({
    required this.cubit,
    required this.features,
  });

  final SplashCubit cubit;
  final List<FeaturesModel> features;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: cubit.controller,
            onPageChanged: cubit.updateSliderIndex,
            itemCount: features.length,
            itemBuilder: (context, index) =>
                _OnboardingPage(feature: features[index]),
          ),
        ),

        // Dot indicators
        _DotIndicator(
          count: features.length,
          activeIndex: cubit.sliderIndex,
        ),

        24.ph,

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<SplashCubit, SplashStates>(
            buildWhen: (_, s) => s is ChangeIntroState,
            builder: (context, _) {
              final isLast = cubit.sliderIndex == features.length - 1;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLast
                    ? _GetStartedButton(key: const ValueKey('get_started'))
                    : _NextButton(
                        key: const ValueKey('next'),
                        onTap: () {
                          cubit.controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
              );
            },
          ),
        ),

        20.ph,
        if (Platform.isAndroid)
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).padding.bottom,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Single onboarding page
// ---------------------------------------------------------------------------

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.feature});

  final FeaturesModel feature;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            53.ph,

            // Feature image (network URL from API)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                feature.image,
                // height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  "assets/images/onboarding_image.png",
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            24.ph,

            // HTML title
            Html(
              data: feature.title,
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.start,
                ),
                "*": Style(
                  fontSize: FontSize(34),
                  fontWeight: FontWeight.w500,
                  color: LightThemeColors.primary,
                ),
              },
            ),

            12.ph,

            // HTML description
            Html(
              data: feature.description,
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.center,
                ),
                "*": Style(
                  fontSize: FontSize(14),
                  color: LightThemeColors.grey,
                  lineHeight: LineHeight(1.5),
                ),
              },
            ),

            24.ph,
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dot indicator
// ---------------------------------------------------------------------------

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashStates>(
      buildWhen: (_, s) => s is ChangeIntroState,
      builder: (context, _) {
        final current = SplashCubit.get(context).sliderIndex;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (i) {
            final isActive = i == current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isActive
                    ? LightThemeColors.primary
                    : LightThemeColors.primary.withOpacity(0.25),
              ),
            );
          }),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Buttons
// ---------------------------------------------------------------------------

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      onTap: () async {
        await Utils.dataManager.setOnboardingSeen();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.LoginSignupToggleScreen,
            (r) => false,
          );
        }
      },
      witharrows: true,
      title: LocalizationHelper.tr.get_started,
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      onTap: onTap,
      witharrows: true,
      title: LocalizationHelper.tr.next, // add 'next' key to your l10n
    );
  }
}
