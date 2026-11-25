import 'dart:ui';

import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/extensions/widget_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/home/cubit/home_states.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/presentation/widgets/text_slider.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../slider_widgets.dart';

class BranchBottomSheet extends StatefulWidget {
  const BranchBottomSheet({
    super.key,
    this.branches,
    this.vsync,
    this.ontap,
    this.images,
    this.homeText,
    this.initialLocation,
  });
  final List<BranchModel>? branches;
  final List<String>? images;
  final List<String>? homeText;
  final TickerProviderStateMixin? vsync;
  final Function(BranchModel id)? ontap;
  final LatLng? initialLocation;

  @override
  State<BranchBottomSheet> createState() => _BranchBottomSheetState();
}

class _BranchBottomSheetState extends State<BranchBottomSheet> {
  List<BranchModel>? branches = [];
  List<String> images = [];
  List<String>? homeText;
  bool isSearch = false;

  @override
  void initState() {
    branches = widget.branches;
    images = widget.images ?? [];
    homeText = widget.homeText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  final size = MediaQuery.of(context).size;

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is UserBranchesSuccess) {
          branches = state.branches?.branches ?? [];
        }
      },
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return SizedBox(
          height: (context.height) * 0.85,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Header Row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocalizationHelper.tr.find_nearest_branches,
                        style: TextStyles.font14BlackBold.copyWith(
                          fontWeight: FontWeights.extraBold,
                          color: LightThemeColors.black,
                        ),
                      ),
                    ),
                    /*  SvgPicture.asset(
                      SvgAssets.cancel,
                    ), */
                  ],
                ),

                const SizedBox(height: 20),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: LightThemeColors.black.withOpacity(
                    .1,
                  ),
                ),
                25.ph,
                // Welcome & Search Actions
                isSearch == true
                    ? TextFormFieldWidget(
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty == true) {
                              branches = widget.branches;
                            }
                            branches = widget.branches
                                ?.where((element) =>
                                    element.name!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    element.description!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                .toList();
                            setState(() {});
                          });
                        },
                        hintText: LocalizationHelper.tr.search_input_hint,
                        contentPadding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 20),
                        suffixIcon: const Icon(Icons.cancel_rounded).onTap(() {
                          setState(() {
                            isSearch = false;
                            setState(() {});
                          });
                        }),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: "${LocalizationHelper.tr.welcome}\n",
                                style: TextStyles.font12BlackLight.copyWith(
                                  fontWeight: FontWeights.regular,
                                  color: LightThemeColors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: LocalizationHelper
                                        .tr.find_your_best_branch,
                                    style: TextStyles.font14BlackBold.copyWith(
                                      fontWeight: FontWeights.semiBold,
                                      color: LightThemeColors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (branches?.isEmpty == false)
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: LightThemeColors.orange,
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  SvgAssets.homeSheetSearch,
                                  width: 18,
                                ),
                              ),
                            ).onTap(() {
                              setState(() {
                                isSearch = true;
                                setState(() {});
                              });
                            }),
                          const SizedBox(width: 4),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: LightThemeColors.orange,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                SvgAssets.homeSheetLocation,
                                width: 18,
                              ),
                            ),
                          ).onTap(() async {
                            /// MARK: we need to pop the bottom sheet

                            /*   LatLng? targetLocation;
                            if (widget.initialLocation != null) {
                              targetLocation = widget.initialLocation;
                            } else if (branches?.isNotEmpty == true) {
                              final firstBranch = branches!.first;
                              final lat =
                                  double.tryParse(firstBranch.latitude ?? "");
                              final lng =
                                  double.tryParse(firstBranch.longitude ?? "");
                              if (lat != null && lng != null) {
                                targetLocation = LatLng(lat, lng);
                              }
                            } */

                            final response = await Navigator.pushNamed(
                              context,
                              Routes.BranchesMapScreen,
                              //  arguments: targetLocation,
                            );
                            if (response != null) {
                              NavigationHelper.pop();
                              cubit.setPrimaryBranch(response as BranchModel);
                            }
                          }),
                        ],
                      ),

                const SizedBox(height: 16),

                // Promo Banner
                if (homeText?.isNotEmpty ?? false)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // color: Colors.pink.shade400,
                      gradient: LinearGradient(
                        colors: LightThemeColors.gradientPrimary,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              SvgAssets.lineLeft,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                            )
                          ],
                        ),
                        AutoTextSlider(
                          texts: homeText ?? [],
                          //  style: const TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                            ),
                            SvgPicture.asset(
                              SvgAssets.lineRight,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                SliderWidgets(
                  radius: 20,
                  height: 120,
                  myaspecRatio: 410 / 120,
                  images: images,
                  withoutIcons: true,
                ),

                const SizedBox(height: 16),

                // Branches Header
                if (branches?.isEmpty == true) ...[
                  45.ph,
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: LightThemeColors.primary,
                    ),
                    child: const Center(
                      child: DefaultImageWidget(
                        SvgAssets.location,
                        color: LightThemeColors.white,
                      ),
                    ),
                  ),
                  25.ph,
                  Text(
                    LocalizationHelper.tr.no_branch_assigned_message,
                    style: TextStyles.font20WhiteSemiBold.copyWith(
                      fontWeight: FontWeights.bold,
                      fontSize: 24,
                      color: LightThemeColors.grey,
                    ),
                  ),
                  12.ph,
                  Text(
                    LocalizationHelper.tr.select_branch_prompt,
                    style: TextStyles.font16BlackSemiBold.copyWith(
                      color: LightThemeColors.grey,
                    ),
                  ),
                  25.ph,
                  ButtonWidget(
                    title: LocalizationHelper.tr.select_branch_action,
                    width: 200,
                    height: 48,
                    onTap: () async {
                      // cubit.pop();
                      await cubit.searchBranch(
                        ontap: widget.ontap,
                        context,
                        vsync: widget.vsync!,
                      );
                    },
                  )
                ],

                if (branches?.isNotEmpty == true) ...[
                  Row(
                    children: [
                      Text(
                        LocalizationHelper.tr.branch_list,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeights.bold,
                          color: LightThemeColors.primary,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          await cubit.searchBranch(context,
                              vsync: widget.vsync!);
                        },
                        child: Row(
                          children: [
                            Text(
                              LocalizationHelper.tr.view_all_items,
                              style: const TextStyle(
                                color: Color(0xFF343434),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            6.5.pw,
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: LightThemeColors.grey,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Branch List
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => 10.ph,
                      // padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: branches?.length ?? 0,
                      itemBuilder: (context, index) {
                        return BottobBranchWidget(
                          branch: branches![index],
                        ).onTap(() {
                          Navigator.pop(context, branches![index]);
                        });
                      },
                    ),
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

class BottobBranchWidget extends StatelessWidget {
  const BottobBranchWidget({
    super.key,
    this.branch,
  });
  final BranchModel? branch;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container(

        // ),
        Stack(
          children: [
            Container(
              height: 130,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(24),
                // image:
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    24,
                  ),
                  child: DefaultImageWidget(
                    branch?.image ?? LocalizationHelper.tr.unspecified_phrase,
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: LightThemeColors.black.withValues(
                  alpha: .65,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(17),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              32,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 0.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: LightThemeColors.white.withOpacity(
                    .1,
                  ),
                  borderRadius: BorderRadius.circular(
                    32,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      maxLines: 1,
                      text: TextSpan(
                        text:
                            "${branch?.name ?? LocalizationHelper.tr.unspecified_phrase} ( ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: (branch?.description ?? ""),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const TextSpan(
                            text: " )",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.yellow, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              "${branch?.averageRating ?? LocalizationHelper.tr.unspecified_phrase} ",
                              style: const TextStyle(color: Colors.white),
                            ),
                            Opacity(
                              opacity: 0.78,
                              child: Text(
                                "(${branch?.totalRating})",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${branch?.distance ?? ""}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        4.pw,
                        Container(
                          width: 1,
                          height: 10,
                          decoration: BoxDecoration(
                            color: LightThemeColors.white.withOpacity(
                              .1,
                            ),
                          ),
                        ),
                        4.pw,
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              overflow: TextOverflow.ellipsis,
                              "${DateFormat(' kk:mm a').format(DateTime.parse(branch?.openingDate ?? LocalizationHelper.tr.unspecified_phrase))} - ${DateFormat('kk:mm a').format(DateTime.parse(branch?.closeDate ?? LocalizationHelper.tr.unspecified_phrase))}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SvgAssets.wallet,
                          color: LightThemeColors.white,
                        ),
                        3.pw,
                        Text(
                            "+${branch?.totalOrders} • ID : ${branch?.code ?? LocalizationHelper.tr.unspecified_phrase}",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
