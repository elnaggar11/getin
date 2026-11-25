import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({
    super.key,
    this.branches,
    this.onBranchSelected,
  });

  final List<BranchModel>? branches;
  final Function(BranchModel branch)? onBranchSelected;

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  List<BranchModel> _filteredBranches = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredBranches = widget.branches ?? [];
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBranches = widget.branches ?? [];
      } else {
        _filteredBranches = (widget.branches ?? [])
            .where(
                (branch) => branch.name?.toLowerCase().contains(query) ?? false)
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterList);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocalizationHelper.tr.recommended_branches,
                  style: TextStyles.font14BlackBold.copyWith(
                    fontWeight: FontWeights.extraBold,
                    color: LightThemeColors.black,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(SvgAssets.cancel),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(
                height: 0,
                thickness: 1,
                color: LightThemeColors.black.withValues(alpha: .1)),
            const SizedBox(height: 30),
            TextFormFieldWidget(
              controller: _searchController,
              hintText: LocalizationHelper.tr.search_branches,
              prefixWidget: SvgAssets.sheetSearch.toSvg(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: _filteredBranches.length,
                itemBuilder: (context, index) {
                  final branch = _filteredBranches[index];
                  return SearchProductWidget(
                    branch: branch,
                  ).onTap(() {
                    widget.onBranchSelected?.call(branch) ??
                        Navigator.pop(context, branch);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchProductWidget extends StatelessWidget {
  const SearchProductWidget({
    super.key,
    required this.branch, // خليناها required عشان نضمن إنها مش null
  });

  // ★★★★★ النوع هنا BranchModel وليس BranchModel? ★★★★★
  final BranchModel branch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: LightThemeColors.darkwhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- الجزء الأيسر: الصورة والبيانات ---
          Expanded(
            // استخدم Expanded عشان تمنع أي overflow لو النص طويل
            child: Row(
              children: [
                const SizedBox(width: 8),
                // الصورة
                SizedBox(
                  width: 75,
                  height: 75,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: DefaultImageWidget(
                      branch.image ??
                          LocalizationHelper
                              .tr.unspecified_phrase, // استخدم branch مباشرة
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // البيانات (الاسم والتقييم والمسافة)
                Expanded(
                  // استخدم Expanded هنا كمان عشان النص ياخد راحته
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الاسم
                      Text(
                        branch.name ?? "No Name", // حماية من الـ null
                        style: TextStyles.font12BlackBold.copyWith(
                          color: LightThemeColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeights.extraBold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      // الوصف
                      Text(
                        branch.description ??
                            "No Description", // حماية من الـ null
                        style: TextStyles.font12BlackBold.copyWith(
                          fontWeight: FontWeights.regular,
                          color: LightThemeColors.lightgrey,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      // التقييم والمسافة
                      Row(
                        children: [
                          SvgPicture.asset(SvgAssets.Star),
                          const SizedBox(width: 2),
                          Text(
                            branch.averageRating ?? "1.0",
                            style: TextStyles.font12BlackBold.copyWith(
                              fontWeight: FontWeights.regular,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "(${branch.totalRating ?? "0"}+)",
                            style: TextStyles.font12BlackBold.copyWith(
                              fontWeight: FontWeights.regular,
                              color: LightThemeColors.grey,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if ((branch.workOrScopeDistance).isNotEmpty) ...[
                            Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: LightThemeColors.lightgrey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${branch.workOrScopeDistance} ",
                              style: TextStyles.font12BlackBold.copyWith(
                                fontWeight: FontWeights.regular,
                              ),
                            ),
                          ],
                          const SizedBox(
                            width: 8,
                          ),
                          branch?.workingTime(spacing: 5) ??
                              const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- الجزء الأيمن: زرار السهم ---
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: LightThemeColors.white,
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: LightThemeColors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
    );
  }
}
