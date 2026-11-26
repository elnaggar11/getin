import 'dart:developer';
import 'dart:ui';

import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/extensions/widget_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/edit_profile/presentation/widgets/logout_dialog.dart';
import 'package:getincoffee/features/edit_profile/presentation/widgets/delete_account_dialog.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/layout/cubit/layout_cubit.dart';
import 'package:getincoffee/features/profile/cubit/profile_cubit.dart';
import 'package:getincoffee/features/profile/cubit/profile_states.dart';
import 'package:getincoffee/features/profile/domain/model/setting_model.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

class ProfileDrawerWidget extends StatefulWidget {
  const ProfileDrawerWidget({super.key});

  @override
  State<ProfileDrawerWidget> createState() => _ProfileDrawerWidgetState();
}

class _ProfileDrawerWidgetState extends State<ProfileDrawerWidget> {
  List<MenuItemModel> items(context) => [
        MenuItemModel(
          title: LocalizationHelper.tr.my_points,
          icon: SvgAssets.points,
          route: Routes.MypointsScreen,
          endIcon: Text(
            Utils.userModel.totalPoints.toString() ??
                LocalizationHelper.tr.unspecified_phrase,
            style: TextStyles.font16BlackSemiBold.copyWith(
              fontWeight: FontWeights.semiBold,
              fontSize: 15,
              color: LightThemeColors.white,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, Routes.MypointsScreen).then((value) {
              if (value != null) {
                Utils.scaffoldKey.currentState?.closeDrawer();
                LayoutCubit.get(context).changeTab(0);
              }
            });
          },
        ),
        MenuItemModel(
          title: LocalizationHelper.tr.my_stars,
          icon: SvgAssets.start,
          route: Routes.MyStarsScreen,
          endIcon: Text(
            Utils.userModel.totalStars.toString() ??
                LocalizationHelper.tr.unspecified_phrase,
            style: TextStyles.font16BlackSemiBold.copyWith(
              fontWeight: FontWeights.semiBold,
              fontSize: 15,
              color: LightThemeColors.white,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, Routes.MyStarsScreen);
          },
        ),
        if (!Utils.userModel.shouldHideCardPayment)
          MenuItemModel(
            title: LocalizationHelper.tr.payment_method,
            icon: SvgAssets.cash,
            route: Routes.PaymentmethodScreen,
            onTap: () {
              Navigator.pushNamed(context, Routes.PaymentmethodScreen);
            },
          ),
        MenuItemModel(
          title: LocalizationHelper.tr.delivery_locations,
          icon: SvgAssets.moreLocation,
          route: Routes.AddressesScreen,
          onTap: () {
            Navigator.pushNamed(context, Routes.AddressesScreen);
          },
        ),
        MenuItemModel(
          title: LocalizationHelper.tr.schedule_order,
          icon: SvgAssets.calender,
          route: Routes.ScheduleorderScreen,
          onTap: () {
            Navigator.pushNamed(context, Routes.ScheduleorderScreen);
          },
        ),
        MenuItemModel(
          title: LocalizationHelper.tr.discount_coupons,
          icon: SvgAssets.discountCoponMore,
          route: Routes.CoponsScreen,
          onTap: () {
            Navigator.pushNamed(context, Routes.CoponsScreen).then((value) {
              if (value != null) {
                // {'id': coupon.id, 'branchId': coupon.branchId}
                if (value is Map<String, dynamic>) {
                  Navigator.pop(context);
                  LayoutCubit.get(context).changeTab(0);

                  if (value['branchId'] != null) {
                    HomeCubit.get(context)
                        .setBranchById(value['branchId'].toString());
                  }
                }
              }
            });
          },
        ),
        MenuItemModel(
          title: LocalizationHelper.tr.invite_friends,
          icon: SvgAssets.moreShare,
          onTap: () async {
            var res = await ProfileCubit.get(context).setting();
            if (res != null && context.mounted) {
              shareAppLinks(res, context);
            }
          },
        ),
        MenuItemModel(
          title: LocalizationHelper.tr.language,
          icon: SvgAssets.lang,
          route: Routes.ChangeLangScreen,
          onTap: () {
            Navigator.pushNamed(context, Routes.ChangeLangScreen);
          },
        ),
        MenuItemModel(
          title: LocalizationHelper.tr.terms_conditions,
          icon: SvgAssets.termsIcon,
          route: Routes.TermsScreen,
          onTap: () {
            Navigator.pushNamed(context, Routes.TermsScreen);
          },
        ),
        MenuItemModel(
          title: LocalizationHelper.tr.support,
          icon: SvgAssets.support,
          route: Routes.SupportScreen,
          onTap: () {
            Navigator.pushNamed(context, Routes.SupportScreen);
          },
        ),
        MenuItemModel(
          title: LocalizationHelper.tr.logout,
          icon: SvgAssets.logOut,
          onTap: () {
            Alerts.bottomSheet(
              context,
              child: BlocProvider.value(
                value: ProfileCubit.get(context),
                child: const LogoutDialog(),
              ),
            );
          },
        ),
        MenuItemModel(
          title: LocalizationHelper.tr.delete_account,
          icon: SvgAssets.delete,
          textColor: Colors.red,
          onTap: () {
            Alerts.bottomSheet(
              context,
              child: BlocProvider.value(
                value: ProfileCubit.get(context),
                child: const DeleteAccountDialog(),
              ),
            );
          },
        ),
      ];

  Future<void> shareAppLinks(SiteSettingData data, BuildContext context) async {
    // You can adjust the share text dynamically
    final String message = '''
${data.title}

${data.description}

Download now:
📱 Google Play: ${data.appLinkGooglePlay.isNotEmpty ? data.appLinkGooglePlay : 'Coming soon'}
🍎 App Store: ${data.appLinkAppStore.isNotEmpty ? data.appLinkAppStore : 'Coming soon'}
''';

    final box = context.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(ShareParams(text: message));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfile(),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is LogoutSuccess || state is DeleteAccountSuccess) {
            NavigationHelper.pushNamedReplaceAll(
              Routes.LoginSignupToggleScreen,
            );
          }
        },
        builder: (context, state) {
          log(Utils.userModel.image ?? "", name: "Utils.userModel.image");
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 40.0,
              sigmaY: 40.0,
            ),
            child: Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width * .9,
              decoration: BoxDecoration(
                color: LightThemeColors.black.withOpacity(
                  .1,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    height: 70 + MediaQuery.of(context).padding.top,
                    decoration: const BoxDecoration(
                      color: LightThemeColors.primary,
                    ),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (1 + MediaQuery.of(context).padding.top).ph,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: ClipOval(
                                    child: DefaultImageWidget(
                                      Utils.userModel.image ??
                                          LocalizationHelper
                                              .tr.unspecified_phrase,
                                      width: 50,
                                      height: 50,
                                      radius: 50,
                                      isCircle: true,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                15.pw,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${Utils.userModel.firstName ?? LocalizationHelper.tr.unspecified_phrase} ${Utils.userModel.lastName ?? LocalizationHelper.tr.unspecified_phrase}",
                                      style:
                                          TextStyles.font14BlackBold.copyWith(
                                        color: LightThemeColors.white,
                                        fontWeight: FontWeights.extraBold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    4.ph,
                                    Text(
                                      Utils.userModel.phone ??
                                          LocalizationHelper
                                              .tr.unspecified_phrase,
                                      style:
                                          TextStyles.font14BlackBold.copyWith(
                                        color: LightThemeColors.white,
                                        fontWeight: FontWeights.medium,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Utils.scaffoldKey.currentState?.closeDrawer();
                              },
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: LightThemeColors.white,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (state is GetProfileLoading)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: LightThemeColors.white,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(items(context).length, (i) {
                            return DrawerItem(
                              title: items(context)[i].title,
                              endIcon: items(context)[i].endIcon,
                              textColor: items(context)[i].textColor,
                              icon: items(context)[i].icon,
                              route: items(context)[i].route,
                              onTap: items(context)[i].onTap,
                            );
                          }),
                        ),
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

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    this.icon,
    this.title,
    this.endIcon,
    this.route,
    this.logout,
    this.onTap,
    this.textColor,
  });
  final String? icon;
  final String? title;
  final String? route;
  final Widget? endIcon;
  final VoidCallback? logout;
  final VoidCallback? onTap;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                (icon ?? LocalizationHelper.tr.unspecified_phrase),
              ),
              10.pw,
              Text(
                title ?? LocalizationHelper.tr.unspecified_phrase,
                style: TextStyles.font14BlackMedium.copyWith(
                    fontWeight: FontWeights.regular,
                    fontSize: 14,
                    color: textColor ?? LightThemeColors.white),
              )
            ],
          ),
          endIcon == null
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: textColor ?? LightThemeColors.white,
                  size: 16,
                )
              : endIcon ?? const SizedBox(),
        ],
      ),
    ).onTap(
      onTap ??
          logout ??
          () {
            Navigator.pushNamed(
              context,
              route ?? LocalizationHelper.tr.unspecified_phrase,
            );
          },
    );
  }
}

class MenuItemModel {
  final String title;
  final String icon;
  final String? route;
  final Widget? endIcon;
  final VoidCallback? onTap;
  final Color? textColor;

  MenuItemModel({
    required this.title,
    required this.icon,
    this.route,
    this.endIcon,
    this.onTap,
    this.textColor,
  });
}
