import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget(
      {super.key,
      this.secondtabController,
      this.categories,
      this.onchange,
      this.showPopular = true,
      this.viewAll = true});
  final TabController? secondtabController;
  final List<BranchCategory>? categories;

  final bool viewAll;
  final bool showPopular;
  final Function(int index)? onchange;

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  var inittab = 0;
  @override
  void initState() {
    super.initState();
    widget.secondtabController?.addListener(_handleTabChange);
    inittab = 1;

    if (widget.showPopular == true) {
      inittab += 1;
    }
  }

  void _handleTabChange() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant TabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondtabController != oldWidget.secondtabController) {
      oldWidget.secondtabController?.removeListener(_handleTabChange);
      widget.secondtabController?.addListener(_handleTabChange);
    }
  }

  @override
  void dispose() {
    widget.secondtabController?.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,

      alignment: AlignmentDirectional.bottomStart,
      child: TabBar(
        onTap: (value) {
          widget.onchange?.call(value);
        },
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerHeight: 0,
        controller: widget.secondtabController,
        // indicatorColor: LightThemeColors.grey,
        indicator: const BoxDecoration(),

        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: LightThemeColors.white,
        unselectedLabelColor: Colors.black,

        labelPadding: const EdgeInsets.symmetric(
            // vertical: 8,
            // horizontal: 19,
            ),
        // indicator
        // indicatorPadding: const EdgeInsets.symmetric(
        //   vertical: 8,
        //   horizontal: 19,
        // ),
        labelStyle: const TextStyle(
          color: LightThemeColors.grey,
          fontWeight: FontWeights.medium,
          fontSize: 12,
        ),
        tabs: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 40,
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                40,
              ),
              color: widget.secondtabController?.index == 0
                  ? LightThemeColors.primary
                  : const Color(0xFFDED2B9),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Center(
                child: Tab(
                  icon: Row(
                    children: [
                      Text(
                        LocalizationHelper.tr.all,
                        style: TextStyles.font12BlackBold.copyWith(
                          color: widget.secondtabController?.index == 0
                              ? LightThemeColors.white
                              : LightThemeColors.primary,
                          fontWeight: FontWeights.regular,
                        ),
                      ),
                      5.pw,
                      if (widget.viewAll)
                        Container(
                          //  width: 35,
                          height: 20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              40,
                            ),
                            color: widget.secondtabController?.index == 0
                                ? LightThemeColors.white
                                : LightThemeColors.primary,
                          ),
                          child: Center(
                            child: Text(
                              LocalizationHelper.tr.new_entry,
                              style: TextStyles.font12BlackBold.copyWith(
                                color: widget.secondtabController?.index == 0
                                    ? LightThemeColors.primary
                                    : LightThemeColors.white,
                                fontWeight: FontWeights.regular,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (widget.showPopular)
            AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                constraints: const BoxConstraints(
                  minWidth: 84,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(
                  horizontal: 2, // vertical: 4
                ),
                decoration: ShapeDecoration(
                  color: (widget.secondtabController?.index == 1
                      ? LightThemeColors.primary
                      : const Color(0xFFDED2B9)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Tab(text: LocalizationHelper.tr.popular)),
          ...widget.categories?.asMap().entries.map((entry) {
                final index = entry.key; // 👈 index
                final e = entry.value;
                return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    constraints: const BoxConstraints(
                      minWidth: 84,
                      minHeight: 34,
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2, // vertical: 4
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: ShapeDecoration(
                      color:
                          (widget.secondtabController?.index == index + inittab
                              ? LightThemeColors.primary
                              : const Color(0xFFDED2B9)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Tab(text: e.name));
              }).toList() ??
              []
        ],
      ),
    );
  }
}
