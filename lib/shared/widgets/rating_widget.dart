import 'package:getincoffee/core/generated/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomRatingWidget extends StatefulWidget {
  final int starCount;
  final double initialValue;
  final void Function(double)? onChange;

  const CustomRatingWidget({
    super.key,
    this.starCount = 5,
    this.initialValue = 0,
    this.onChange,
  });

  @override
  State<CustomRatingWidget> createState() => _CustomRatingWidgetState();
}

class _CustomRatingWidgetState extends State<CustomRatingWidget> {
  double currentValue = 0;

  @override
  void initState() {
    super.initState();
    // خزن القيمة الأولية اللي جاية من الـ widget في الـ state الداخلي
    currentValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomRatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      currentValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // استخدم mainAxisAlignment عشان توزع المسافات بالتساوي لو حبيت
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.starCount, (index) {
        // ★★★★★ هنا الشرط الأساسي ★★★★★
        // النجمة تعتبر مختارة لو الـ index بتاعها أصغر من القيمة الحالية
        // مثال: لو القيمة 3، فالنجوم 0, 1, 2 هتبقى مختارة
        final bool isSelected = index < currentValue;

        return GestureDetector(
          onTap: () {
            setState(() {
              currentValue = index + 1.0;
              widget.onChange?.call(currentValue);
            });
          },
          child: Container(
            width: 70,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFFC107)
                  : const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: SvgPicture.asset(
                SvgAssets.ratingScreenStar,
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : const Color(0xFFBDBDBD),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
