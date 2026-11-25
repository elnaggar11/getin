import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';

import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/domain/request/filter_request.dart';
import 'package:getincoffee/features/home/presentation/widgets/tab_bar_widget.dart';
import 'package:getincoffee/features/home/presentation/widgets/widgets.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import '../../../../core/localization/localization_helper.dart';
import '../../../../core/resources/font_manager.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen(
      {super.key,
      required this.categories,
      required this.productFilter,
      required this.values});
  final List<BranchCategory> categories;
  final RangeValues values;

  final ProductFilter productFilter;
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen>
    with TickerProviderStateMixin {
  late TabController secondtabController;
  late ProductFilter tempProductFilter;
  late RangeSliderController rangeSliderController;

  @override
  void initState() {
    int initialIndex = 0;
    if (widget.productFilter.categoryId != null) {
      int catIndex = widget.categories.indexWhere(
          (element) => element.id == widget.productFilter.categoryId);
      if (catIndex != -1) {
        initialIndex = catIndex + 1;
      }
    }
    secondtabController = TabController(
        initialIndex: initialIndex,
        length: widget.categories.length + 1,
        vsync: this);
    tempProductFilter = widget.productFilter.copy();
    rangeSliderController = RangeSliderController(RangeValues(
        tempProductFilter.minPrice ?? widget.values.start,
        tempProductFilter.maxPrice ?? widget.values.end));
    super.initState();
    final double minPrice = widget.values.start;
    final double maxPrice = widget.values.end;
    final double range = maxPrice - minPrice;
    final double step = range / 4;

    prices = List.generate(4, (index) {
      final double start = minPrice + index * step;
      final double end =
          (index == 3) ? maxPrice : minPrice + (index + 1) * step;
      return {"start": start.round(), "end": end.round()};
    });
  }

  String selectedPrice = "";
  List<Map<String, int>> prices = [];

  @override
  Widget build(BuildContext context) {
    List<FilterOption> sortOptions =
        FilterScreenData.getSortOptions(tempProductFilter, () {
      setState(() {});
    });
    List<FilterOption> filterOptions =
        FilterScreenData.getFilterOptions(tempProductFilter, () {
      setState(() {});
    });

    return Scaffold(
      backgroundColor: LightThemeColors.primary,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocalizationHelper.tr.filter,
              style: TextStyles.font20WhiteSemiBold.copyWith(
                color: LightThemeColors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  LocalizationHelper.tr.clear_all,
                  style: TextStyles.font14BlackMedium.copyWith(
                    color: LightThemeColors.error,
                    fontWeight: FontWeights.regular,
                  ),
                ),
                7.pw,
                SvgPicture.asset(
                  SvgAssets.delete,
                ),
              ],
            ).onTap(() {
              setState(() {
                tempProductFilter = ProductFilter();
                selectedPrice = "";
                secondtabController.index = 0;
                rangeSliderController.values =
                    RangeValues(widget.values.start, widget.values.end);
              });
            })
          ],
        ),
        toolbarHeight: 109,
        backgroundColor: LightThemeColors.primary,
        automaticallyImplyLeading: false,
        leading: const Icon(
          Icons.arrow_back_sharp,
          color: LightThemeColors.white,
        ).onTap(
          () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: LightThemeColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              40,
            ),
            topRight: Radius.circular(
              40,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              25.ph,
              Text(
                LocalizationHelper.tr.categories,
                style: TextStyles.font14BlackMedium.copyWith(
                  fontWeight: FontWeights.semiBold,
                  color: LightThemeColors.primary,
                  fontSize: 14,
                ),
              ),
              15.ph,
              TabBarWidget(
                onchange: (index) {
                  setState(() {
                    if (index == 0) {
                      tempProductFilter.categoryId = null;
                    } else {
                      tempProductFilter.categoryId =
                          widget.categories[index - 1].id;
                    }
                  });
                  print('Selected category: ${tempProductFilter.categoryId}');
                },
                showPopular: false,
                viewAll: (false),
                categories: widget.categories,
                secondtabController: secondtabController,
              ),
              15.ph,
              Text(
                LocalizationHelper.tr.sort_by,
                style: TextStyles.font14BlackMedium.copyWith(
                  fontWeight: FontWeights.semiBold,
                  color: LightThemeColors.primary,
                  fontSize: 14,
                ),
              ),
              15.ph,
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: sortOptions.length,
                separatorBuilder: (context, index) => Column(
                  children: [
                    12.ph,
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: LightThemeColors.darkwhite,
                    ),
                    12.ph,
                  ],
                ),
                itemBuilder: (context, index) {
                  return CHeckFilterItem(
                    title: sortOptions[index].title,
                    value: sortOptions[index].value,
                    onchange: sortOptions[index].onChanged,
                  );
                },
              ),
              15.ph,
              Text(
                LocalizationHelper.tr.filter,
                style: TextStyles.font14BlackMedium.copyWith(
                  fontWeight: FontWeights.semiBold,
                  color: LightThemeColors.primary,
                  fontSize: 14,
                ),
              ),
              15.ph,
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filterOptions.length,
                separatorBuilder: (context, index) => Column(
                  children: [
                    12.ph,
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: LightThemeColors.darkwhite,
                    ),
                    12.ph,
                  ],
                ),
                itemBuilder: (context, index) {
                  return CHeckFilterItem(
                    title: filterOptions[index].title,
                    value: filterOptions[index].value,
                    onchange: filterOptions[index].onChanged,
                  );
                },
              ),
              15.ph,
              Text(
                LocalizationHelper.tr.price_range,
                style: TextStyles.font14BlackMedium.copyWith(
                  fontWeight: FontWeights.semiBold,
                  color: LightThemeColors.primary,
                  fontSize: 14,
                ),
              ),
              30.ph,
              PriceFilterWidget(
                controller: rangeSliderController,
                start: widget.values.start,
                end: widget.values.end,
                onPriceChanged: (min, max) {
                  tempProductFilter.minPrice = min;
                  tempProductFilter.maxPrice = max;
                },
              ),
              12.ph,
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var priceString =
                          "${prices[index]["start"]} - ${prices[index]["end"]}";
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPrice = priceString;
                          });
                          tempProductFilter.minPrice =
                              prices[index]["start"]!.toDouble();
                          tempProductFilter.maxPrice =
                              prices[index]["end"]!.toDouble();
                          rangeSliderController.values = RangeValues(
                              prices[index]["start"]!.toDouble(),
                              prices[index]["end"]!.toDouble());
                        },
                        child: Container(
                          height: 40,
                          width: 90,
                          // padding: const EdgeInsets.symmetric(
                          //     vertical: 20, horizontal: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: selectedPrice == priceString
                                ? LightThemeColors.primary
                                : LightThemeColors.darkwhite,
                          ),
                          child: Center(
                              child: Text(
                            priceString,
                            style: TextStyles.font14BlackMedium.copyWith(
                              color: selectedPrice == priceString
                                  ? LightThemeColors.white
                                  : LightThemeColors.primary,
                            ),
                          )),
                        ),
                      );
                      // return null;
                    },
                    separatorBuilder: (context, index) {
                      return 8.pw;
                    },
                    itemCount: 4,
                  ),
                ),
              ),
              25.ph,
              ButtonWidget(
                title: LocalizationHelper.tr.apply,
                onTap: () {
                  Navigator.pop(
                    context,
                    tempProductFilter,
                  );
                },
              ),
              64.ph,
            ],
          ),
        ),
      ),
    );
  }
}

class FilterOption {
  final String title;
  final String value;
  final Function(String?)? onChanged;

  FilterOption({
    required this.title,
    required this.value,
    this.onChanged,
  });
}

class FilterScreenData {
  static List<FilterOption> getSortOptions(
      ProductFilter filter, VoidCallback refresh) {
    return [
      FilterOption(
        title: LocalizationHelper.tr.top_rated,
        value: filter.isTopRated ?? "0",
        onChanged: (val) {
          filter.isTopRated = val == "1" ? "1" : "0";
          refresh();
        },
      ),
      FilterOption(
        title: LocalizationHelper.tr.lowest_first,
        value: filter.lowestFirst ?? "0",
        onChanged: (val) {
          filter.lowestFirst = val == "1" ? "1" : "0";
          refresh();
        },
      ),
      FilterOption(
        title: LocalizationHelper.tr.hights_points,
        value: filter.heightsPoints ?? "0",
        onChanged: (val) {
          filter.heightsPoints = val == "1" ? "1" : "0";
          refresh();
        },
      ),
      FilterOption(
        title: LocalizationHelper.tr.hights_stars,
        value: filter.heightsStars ?? "0",
        onChanged: (val) {
          filter.heightsStars = val == "1" ? "1" : "0";
          refresh();
        },
      ),
    ];
  }

  static List<FilterOption> getFilterOptions(
      ProductFilter filter, VoidCallback refresh) {
    return [
      FilterOption(
        title: LocalizationHelper.tr.recommended,
        value: filter.isRecommended ?? "0",
        onChanged: (val) {
          filter.isRecommended = val == "1" ? "1" : "0";
          refresh();
        },
      ),
      FilterOption(
        title: LocalizationHelper.tr.fastest_delivery,
        value: filter.fastDelivery ?? "0",
        onChanged: (val) {
          filter.fastDelivery = val == "1" ? "1" : "0";
          refresh();
        },
      ),
    ];
  }
}
