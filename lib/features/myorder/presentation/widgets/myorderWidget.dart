import 'dart:developer';

import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/domain/model/home_change_model.dart';
import 'package:getincoffee/features/layout/cubit/layout_cubit.dart';
import 'package:getincoffee/features/myorder/cubit/myorder_cubit.dart';
import 'package:getincoffee/features/myorder/presentation/widgets/cancel_bottom_sheet.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/Router/Router.dart';
import '../../domain/model/myorder_model.dart';

enum OrderStatus {
  ongoing,
  delivered,
  canceled;
}

class Myorderwidget extends StatefulWidget {
  const Myorderwidget({
    super.key,
    this.delete,
    this.reorder,
    // this.orderStatus =
    this.item,
  });
  final VoidCallback? reorder;
  final VoidCallback? delete;

  final MyorderModel? item;
  @override
  State<Myorderwidget> createState() => _MyorderwidgetState();
}

class _MyorderwidgetState extends State<Myorderwidget> {
  OrderStatus orderStatus = OrderStatus.ongoing;

  Color getColor() {
    switch (orderStatus) {
      case OrderStatus.ongoing:
        return LightThemeColors.secondary.withOpacity(.1);
      case OrderStatus.delivered:
        return LightThemeColors.green;
      case OrderStatus.canceled:
        return LightThemeColors.error;
    }
  }

  String getStatusttext() {
    switch (orderStatus) {
      case OrderStatus.ongoing:
        return LocalizationHelper.tr.preparing;
      case OrderStatus.delivered:
        return LocalizationHelper.tr.completed;
      case OrderStatus.canceled:
        return LocalizationHelper.tr.cancelled;
    }
  }

  Color getTextColor() {
    switch (orderStatus) {
      case OrderStatus.ongoing:
        return LightThemeColors.primary;
      case OrderStatus.delivered:
        return LightThemeColors.black;
      case OrderStatus.canceled:
        return LightThemeColors.white;
    }
  }

  Widget getIcon() {
    switch (orderStatus) {
      case OrderStatus.ongoing:
        return SvgPicture.asset(
          SvgAssets.cannerIcon,
        ).onTap(
          () {
            Navigator.pushNamed(
              context,
              Routes.QrScreen,
              arguments:
                  widget.item?.id ?? LocalizationHelper.tr.unspecified_phrase,
            ).then((e) {
              log(e.runtimeType.toString(), name: "typeOfE");
              if (e is HomeChangeModel && context.mounted) {
                LayoutCubit.get(context).changeTab(0);
              } else if (e is String && context.mounted) {
                MyorderCubit.get(context).refresh();
              } else if (e is int && context.mounted) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  LayoutCubit.get(context).changeTab(0);
                });
              }
            });
          },
        );
      case OrderStatus.delivered:
        // return const Icon(Icons.star).onTap(() {
        //   Navigator.pushNamed(context, Routes.RatingScreen);
        // });
        return widget.item?.isRated == true
            ? const SizedBox(
                width: 0,
                // width: 30,
              )
            : SvgPicture.asset(
                SvgAssets.rateOrderIcon,
              ).onTap(() {
                Navigator.pushNamed(context, Routes.RatingScreen,
                        arguments: widget.item)
                    .then((e) {
                  if (mounted) {
                    MyorderCubit.get(context).refresh();
                  }
                });
              });
      case OrderStatus.canceled:
        return const SizedBox();
    }
  }

  Widget getButton() {
    switch (orderStatus) {
      case OrderStatus.ongoing:
        return const SizedBox();
      case OrderStatus.delivered:
        return Column(
          children: [
            10.ph,
            ButtonWidget(
              onTap: widget.reorder,
              height: 46,
              title: LocalizationHelper.tr.reorder,
            ),
          ],
        );
      case OrderStatus.canceled:
        return const SizedBox();
    }
  }

  OrderStatus getStatus(String status) {
    switch (status) {
      case "pending":
      case "new":
        return OrderStatus.ongoing;
      case "completed":
        return OrderStatus.delivered;
      case "canceled":
        return OrderStatus.canceled;
      default:
        return OrderStatus.ongoing;
    }
  }

  @override
  void initState() {
    orderStatus = getStatus(
        widget.item?.status ?? LocalizationHelper.tr.unspecified_phrase);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: orderStatus != OrderStatus.ongoing
          ? null
          : () {
              if (orderStatus == OrderStatus.ongoing) {
                Navigator.pushNamed(
                  context,
                  Routes.QrScreen,
                  arguments: widget.item?.id ??
                      LocalizationHelper.tr.unspecified_phrase,
                ).then((e) {
                  print(e);
                  log(e.runtimeType.toString(), name: "typeOfE");
                  if (e is HomeChangeModel && context.mounted) {
                    LayoutCubit.get(context).changeTab(0);
                  } else if (e is String && context.mounted) {
                    MyorderCubit.get(context).refresh();
                  } else if (e is int && context.mounted) {
                    Future.delayed(const Duration(milliseconds: 10), () {
                      LayoutCubit.get(context).changeTab(0);
                    });
                  }
                });
              }
            },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(
              15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                20,
              ),
              color: LightThemeColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: LightThemeColors.black.withValues(alpha: .1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      26,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      26,
                    ),
                    child: DefaultImageWidget(
                      widget.item?.items?.isNotEmpty ?? false
                          ? widget.item?.items?.first.image ?? ""
                          : "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                7.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 7.5,
                                  horizontal: 16.5,
                                ),
                                decoration: BoxDecoration(
                                  color: getColor(),
                                  borderRadius: BorderRadius.circular(
                                    40,
                                  ),
                                ),
                                child: Text(
                                  getStatusttext(),
                                  style: TextStyles.font12BlackBold.copyWith(
                                    fontWeight: FontWeights.medium,
                                    color: getTextColor(),
                                  ),
                                ),
                              ),
                              //   27.pw,
                            ],
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.item?.createdAt == null
                                        ? LocalizationHelper
                                            .tr.unspecified_phrase
                                        : DateTime.parse(
                                                widget.item?.createdAt ??
                                                    LocalizationHelper
                                                        .tr.unspecified_phrase)
                                            .formatedDateTime,
                                    textAlign: TextAlign.end,
                                    style: TextStyles.font12BlackBold.copyWith(
                                      fontWeight: FontWeights.regular,
                                      color: LightThemeColors.grey,
                                    ),
                                  ),
                                ),
                                8.5.pw,
                                getIcon(),
                              ],
                            ),
                          )
                        ],
                      ),
                      2.ph,
                      Text(
                        "${widget.item?.items?.isNotEmpty ?? false ? (widget.item?.items?[0].product_name ?? '') : ''}"
                        " ${((widget.item?.items?.length ?? 0) > 1) ? "(+${widget.item?.items?.length ?? 0})" : ""}",
                        style: TextStyles.font14BlackBold.copyWith(
                          fontWeight: FontWeights.semiBold,
                          color: LightThemeColors.primary,
                        ),
                      ),
                      2.ph,
                      Row(
                        children: [
                          Text(
                            "#${widget.item?.id ?? ""}",
                            style: TextStyles.font12BlackBold.copyWith(
                              fontWeight: FontWeights.regular,
                              color: LightThemeColors.grey,
                            ),
                          ),
                          16.pw,
                          if ((widget.item?.user_location == null))
                            Text(
                              LocalizationHelper.tr.pickup_from_branch,
                              style: TextStyles.font12BlackBold.copyWith(
                                fontWeight: FontWeights.regular,
                                color: LightThemeColors.grey,
                              ),
                            ),
                        ],
                      ),
                      2.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₺${widget.item?.totalPrice ?? LocalizationHelper.tr.unspecified_phrase}",
                            style: TextStyles.font14BlackBold.copyWith(
                              fontWeight: FontWeights.semiBold,
                              color: LightThemeColors.primary,
                            ),
                          ),
                          if (orderStatus == OrderStatus.ongoing &&
                              (widget.item?.status == "pending" ||
                                  widget.item?.status == "new") &&
                              widget.item?.finance == "points" &&
                              widget.item?.user_location == null)
                            Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 30.0,
                                ),
                                child: SvgPicture.asset(
                                  SvgAssets.delete,
                                  width: 20,
                                )).onTap(() {
                              Alerts.bottomSheet(
                                context,
                                child: BlocProvider.value(
                                  value: MyorderCubit.get(context),
                                  child: CancelBottomSheet(
                                    delete: widget.delete,
                                  ),
                                ),
                              );
                            }),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          getButton(),
        ],
      ),
    );
  }
}
