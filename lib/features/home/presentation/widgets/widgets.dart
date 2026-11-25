import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';

class CHeckFilterItem extends StatefulWidget {
  const CHeckFilterItem({super.key, this.title, this.value, this.onchange});
  final String? title;
  final String? value;
  final Function(String?)? onchange;

  @override
  State<CHeckFilterItem> createState() => _CHeckFilterItemState();
}

class _CHeckFilterItemState extends State<CHeckFilterItem> {
  String? value;
  @override
  initState() {
    super.initState();

    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (value == "1") {
            value = "0";
          } else {
            value = "1";
          }
        });
        widget.onchange?.call(value ?? '');
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 0,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  width: value == "1" ? 0 : 1,
                  color: value == "1"
                      ? LightThemeColors.white
                      : LightThemeColors.primary,
                ),
                borderRadius: BorderRadius.circular(6),
                color: value == "1"
                    ? LightThemeColors.primary
                    : Colors.transparent,
              ),
              child: Center(
                child: value == "1"
                    ? const Icon(
                        Icons.check,
                        color: LightThemeColors.white,
                        size: 15,
                      )
                    : const SizedBox(),
              ),
            ),
            10.pw,
            Text(
              widget.title ?? LocalizationHelper.tr.sort_lowest_first,
              style: TextStyles.font16BlackRegular.copyWith(
                color: LightThemeColors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RangeSliderController {
  RangeValues values;
  RangeSliderController(this.values);
}

class PriceFilterWidget extends StatefulWidget {
  const PriceFilterWidget(
      {super.key,
      this.onPriceChanged,
      required this.controller,
      required this.start,
      required this.end});
  final Function(double, double)? onPriceChanged;
  final RangeSliderController controller;
  final double start;
  final double end;

  @override
  State<PriceFilterWidget> createState() => _PriceFilterWidgetState();
}

class _PriceFilterWidgetState extends State<PriceFilterWidget> {
  @override
  Widget build(BuildContext context) {
    double safeMin = widget.start;
    double safeMax = widget.end;
    if (safeMin >= safeMax) {
      safeMax = safeMin + 1;
    }
    double valStart = widget.controller.values.start.clamp(safeMin, safeMax);
    double valEnd = widget.controller.values.end.clamp(safeMin, safeMax);
    if (valStart > valEnd) {
      valStart = valEnd;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 22),
      child: RangeSliderFlutter(
        values: [valStart, valEnd],
        rangeSlider: true,
        // rtl: Utils.lang != "en",
        min: safeMin,
        max: safeMax,
        fontSize: 14,
        textColor: LightThemeColors.black,
        textPositionBottom: 16,
        tooltip: RangeSliderFlutterTooltip(
          alwaysShowTooltip: true,
          boxStyle: const RangeSliderFlutterTooltipBox(
            decoration: BoxDecoration(color: Colors.transparent),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            color: LightThemeColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        trackBar: RangeSliderFlutterTrackBar(
          activeTrackBarHeight: 4,
          inactiveTrackBarHeight: 4,
          activeTrackBar: BoxDecoration(
            color: LightThemeColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          inactiveTrackBar: BoxDecoration(
            color: LightThemeColors.offwhite,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        handler: RangeSliderFlutterHandler(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: LightThemeColors.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.chevron_left,
            color: LightThemeColors.white,
            size: 20,
          ),
        ),
        rightHandler: RangeSliderFlutterHandler(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF11332B),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.chevron_right,
            color: LightThemeColors.white,
            size: 20,
          ),
        ),
        onDragging: (handlerIndex, lowerValue, upperValue) {
          widget.onPriceChanged?.call(lowerValue, upperValue);
          setState(() {
            widget.controller.values = RangeValues(lowerValue, upperValue);
          });
        },
        onDragCompleted: (index, min, max) {},
      ),
    );
  }
}
