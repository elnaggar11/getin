import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:flutter/material.dart';

class SelectableItem extends StatefulWidget {
  final ValueOptionModel value;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableItem({
    super.key,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SelectableItem> createState() => _SelectableItemState();
}

class _SelectableItemState extends State<SelectableItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(SelectableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value.status == false) {
      return Opacity(
        opacity: 0.25,
        child: Container(
          // width: 215,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: ShapeDecoration(
            color: const Color(0xFFF8F8F8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.value.value ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF343434),
                  fontSize: 12,
                  fontWeight: FontWeights.regular,
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (widget.value.isRecommended == true) {
      return GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.bottomStart,
              children: [
                SelectedWidget(
                    scaleAnimation: _scaleAnimation,
                    widget: widget,
                    isSelected: widget.isSelected,
                    withMargin: true,
                    marginEnd: 45),
                PositionedDirectional(
                    end: 2,
                    top: 0,
                    child: Container(
                      width: 80,
                      // height: 26,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      decoration: const ShapeDecoration(
                        color: LightThemeColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.circular(13),
                            topEnd: Radius.circular(24),
                            bottomStart: Radius.circular(2),
                            bottomEnd: Radius.circular(24),
                          ),
                        ),
                      ),
                      alignment: Alignment.center, // centers the text
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.value.recommendedtext(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            );
          },
        ),
      );
    }
    if (widget.value.extraPrice != null &&
        widget.value.extraPrice!.isNotEmpty &&
        num.tryParse(widget.value.extraPrice!) != null &&
        num.tryParse(widget.value.extraPrice!)! > 0) {
      return GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.bottomStart,
              children: [
                SelectedWidget(
                    scaleAnimation: _scaleAnimation,
                    widget: widget,
                    marginEnd: 40,
                    isSelected: widget.isSelected,
                    withMargin: true),
                PositionedDirectional(
                    end: 2,
                    top: 0,
                    child: Container(
                      width: 50,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      decoration: const ShapeDecoration(
                        color: LightThemeColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.circular(13),
                            topEnd: Radius.circular(24),
                            bottomStart: Radius.circular(2),
                            bottomEnd: Radius.circular(24),
                          ),
                          side: BorderSide(
                            color: LightThemeColors.offwhite,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '+ ${widget.value.extraPrice} ₺',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            );
          },
        ),
      );
    }
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Center(
            child: SelectedWidget(
                scaleAnimation: _scaleAnimation,
                widget: widget,
                isSelected: widget.isSelected,
                withMargin: false),
          );
        },
      ),
    );
  }
}

class SelectedWidget extends StatelessWidget {
  const SelectedWidget(
      {super.key,
      required Animation<double> scaleAnimation,
      required this.widget,
      required this.isSelected,
      required this.withMargin,
      this.marginEnd});

  final double? marginEnd;
  final SelectableItem widget;
  final bool isSelected;
  final bool withMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: withMargin
          ? EdgeInsetsDirectional.only(end: marginEnd ?? 68)
          : EdgeInsets.zero,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      // height: 32,
      // width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: widget.isSelected
            ? const Color(0x190C3B33) // Change to your selected color
            : LightThemeColors.cardBackground,
        border: widget.isSelected
            ? Border.all(
                color: LightThemeColors.primary,
                width: 1,
              )
            : null,
      ),
      child: Center(
        child: Text(
          widget.value.value ?? "",
          textAlign: TextAlign.center,
          style: TextStyles.font12BlackBold.copyWith(
            fontSize: 12,
            color: widget.isSelected
                ? LightThemeColors.primary
                : LightThemeColors.grey,
            fontWeight:
                widget.isSelected ? FontWeights.bold : FontWeights.regular,
          ),
        ),
      ),
    );
  }
}

class CupSizeSelector extends StatefulWidget {
  const CupSizeSelector({
    super.key,
    this.values,
    this.onChange,
    this.onMultipleChange,
    this.type = OptionType.singleChoice,
  });

  final List<ValueOptionModel>? values;
  final OptionType type;
  final Function(ValueOptionModel?)? onChange;
  final Function(List<ValueOptionModel>)? onMultipleChange;

  @override
  State<CupSizeSelector> createState() => _CupSizeSelectorState();
}

class _CupSizeSelectorState extends State<CupSizeSelector> {
  ValueOptionModel? selectedSize;
  final List<ValueOptionModel> selectedSizes = [];

  @override
  void initState() {
    super.initState();
    if (widget.type == OptionType.singleChoice) {
      if (widget.values != null && widget.values!.isNotEmpty) {
        selectedSize = widget.values!.first;
        widget.onChange?.call(selectedSize);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final values = widget.values ?? [];

    return SizedBox(
      height: 50, // adjust to fit your item height
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final size = values[index];
          final isSelected = widget.type == OptionType.singleChoice
              ? selectedSize == size
              : selectedSizes.contains(size);
              
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: SelectableItem(
              value: size,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (widget.type == OptionType.singleChoice) {
                    selectedSize = size;
                    widget.onChange?.call(selectedSize);
                  } else {
                    if (selectedSizes.contains(size)) {
                      selectedSizes.remove(size);
                    } else {
                      selectedSizes.add(size);
                    }
                    widget.onMultipleChange?.call(selectedSizes);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }
}
