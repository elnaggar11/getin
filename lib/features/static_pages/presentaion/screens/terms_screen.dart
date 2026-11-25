import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/static_pages/cubit/staticpage_cubit.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  String content = "";
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StaticpageCubit()..getTermsScreen(),
      child: BlocConsumer<StaticpageCubit, StaticpageState>(
        listener: (context, state) {
          if (state is GetTermsSucess) {
            content = state.content ?? "";
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackWidget(),
              centerTitle: false,
              title: Text(
                LocalizationHelper.tr.terms_and_conditions,
                style: const TextStyle(
                  color: LightThemeColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  40.ph,
                  Text(
                    content,
                    style: const TextStyle(
                      color: LightThemeColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
