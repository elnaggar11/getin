import 'package:flutter/material.dart';
import 'package:getincoffee/features/auth/presentation/screens/login/login_screen.dart';
import 'package:getincoffee/features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import 'package:getincoffee/features/auth/presentation/widgets/auth_tab_selector.dart';
import 'package:getincoffee/features/auth/presentation/widgets/auth_top_header.dart';
import '../../../../../core/localization/localization_helper.dart';
import '../../../../../core/theme/light_theme.dart';
import '../../../../../core/utils/extentions.dart';

class LoginSignupToggleScreen extends StatefulWidget {
  const LoginSignupToggleScreen({super.key});

  @override
  State<LoginSignupToggleScreen> createState() =>
      _LoginSignupToggleScreenState();
}

class _LoginSignupToggleScreenState extends State<LoginSignupToggleScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLogin = tabController.index == 0;

    return Scaffold(
      backgroundColor: LightThemeColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AuthTopHeader(
              title: isLogin
                  ? LocalizationHelper.tr.welcome_back_message
                  : LocalizationHelper.tr.welcome_back_message_register,
              subtitle: isLogin
                  ? LocalizationHelper.tr.registered_info_prompt
                  : LocalizationHelper.tr.register_info_prompt,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: const BoxDecoration(
                  color: LightThemeColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 20,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    16.ph,
                    AuthTabSelector(
                      controller: tabController,
                      titles: [
                        LocalizationHelper.tr.login,
                        LocalizationHelper.tr.sign_up,
                      ],
                    ),
                    14.ph,
                    Expanded(
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        controller: tabController,
                        children: const [
                          LoginScreen(),
                          SignUpScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
