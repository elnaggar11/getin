import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/support/cubit/support_cubit.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportCubit()..getSupport(),
      child: const _SupportScreenContent(),
    );
  }
}

class _SupportScreenContent extends StatelessWidget {
  const _SupportScreenContent();

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      log(phoneUri.toString());
      await launchUrl(phoneUri);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        centerTitle: false,
        title: Text(
          LocalizationHelper.tr.support,
          style: const TextStyle(
            color: LightThemeColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          if (state is SupportLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: LightThemeColors.primary,
              ),
            );
          }

          if (state is SupportFailed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  16.ph,
                  Text(
                    LocalizationHelper.tr.something_went_wrong,
                    style: const TextStyle(
                      color: LightThemeColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  16.ph,
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ButtonWidget(
                      title: LocalizationHelper.tr.refresh,
                      onTap: () {
                        context.read<SupportCubit>().getSupport();
                      },
                      radius: 12,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is SupportSuccess) {
            final support = state.supportModel;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  40.ph,
                  // Big support icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: LightThemeColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      size: 60,
                      color: LightThemeColors.primary,
                    ),
                  ),
                  24.ph,
                  if (support.title != null) ...[
                    Text(
                      support.title!,
                      style: const TextStyle(
                        color: LightThemeColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    16.ph,
                  ],
                  if (support.description != null) ...[
                    Text(
                      support.description!,
                      style: const TextStyle(
                        color: LightThemeColors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    32.ph,
                  ],
                  if (support.phoneNumber != null) ...[
                    _PhoneWidget(
                      phoneNumber: support.phoneNumber!,
                      onTap: () => _launchPhone(support.phoneNumber!),
                    ),
                  ],
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PhoneWidget extends StatelessWidget {
  const _PhoneWidget({
    required this.phoneNumber,
    required this.onTap,
  });

  final String phoneNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: LightThemeColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: LightThemeColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: LightThemeColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.phone,
              color: Colors.white,
              size: 24,
            ),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationHelper.tr.contact_support,
                  style: const TextStyle(
                    color: LightThemeColors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                4.ph,
                Text(
                  phoneNumber,
                  style: const TextStyle(
                    color: LightThemeColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.call,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
