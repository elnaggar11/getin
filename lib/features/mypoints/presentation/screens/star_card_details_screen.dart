import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/mypoints/domain/model/my_star_model/current_rank.dart';
import 'package:getincoffee/features/mypoints/domain/model/ranks_list_model.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:flutter/material.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:flutter_html/flutter_html.dart' as html;

class StarCardDetailsScreen extends StatefulWidget {
  const StarCardDetailsScreen({super.key, required this.ranksListModel});

  final RanksListModel ranksListModel;

  @override
  State<StarCardDetailsScreen> createState() => _StarCardDetailsScreenState();
}

class _StarCardDetailsScreenState extends State<StarCardDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController secondtabController;
  late Rank rank;
  int index = 0;

  @override
  void initState() {
    index = widget.ranksListModel.ranks?.indexWhere(
            (element) => element.id == widget.ranksListModel.currentRankId) ??
        0;
    secondtabController = TabController(
      initialIndex: index,
      length: widget.ranksListModel.ranks?.length ?? 0,
      vsync: this,
    );
    print(widget.ranksListModel.currentRankId);
    print(widget.ranksListModel.ranks?.length);

    rank = widget.ranksListModel.ranks?[index] ??
        Rank(
          name: LocalizationHelper.tr.unspecified_phrase,
          description: LocalizationHelper.tr.unspecified_phrase,
          minStars: LocalizationHelper.tr.unspecified_phrase,
          maxStars: LocalizationHelper.tr.unspecified_phrase,
          pointsIncrement: LocalizationHelper.tr.unspecified_phrase,
          starsIncrement: LocalizationHelper.tr.unspecified_phrase,
          badgeColor: LocalizationHelper.tr.unspecified_phrase,
          id: 4,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightThemeColors.white,
      appBar: AppBar(
        leading: const BackWidget(),
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 6,
              child: Text(
                rank.name ?? LocalizationHelper.tr.unspecified_phrase,
                style: const TextStyle(
                  color: LightThemeColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Expanded(
            //   flex: 2,
            //   child: ButtonWidget(
            //     fontSize: 12,
            //     height: 34,
            //     title: "Buy points",
            //     buttonColor: LightThemeColors.black,
            //   ),
            // )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              12.ph,
              Container(
                height: 38,
                alignment: Alignment.bottomLeft,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerHeight: 0,
                  controller: secondtabController,
                  // indicatorColor: LightThemeColors.grey,
                  indicator: BoxDecoration(
                    color: LightThemeColors.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),

                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: LightThemeColors.white,
                  unselectedLabelColor: Colors.black,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 19,
                  ),
                  onTap: (index) {
                    setState(() {
                      this.index = index;
                      rank = widget.ranksListModel.ranks?[index] ?? Rank();
                    });
                  },

                  labelStyle: const TextStyle(
                    color: LightThemeColors.grey,
                    fontWeight: FontWeights.medium,
                    fontSize: 12,
                  ),
                  tabs: List.generate(
                    widget.ranksListModel.ranks?.length ?? 0,
                    (index) => Tab(
                      text: widget.ranksListModel.ranks?[index].name,
                    ),
                  ),
                ),
              ),
              15.ph,
              Container(
                //  height: 218,
                constraints: BoxConstraints(
                  maxHeight: 218,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16,
                  ),
                ),
                child: DefaultImageWidget(
                  rank.image ?? "",
                  width: double.infinity,
                  // height: 218,
                  isCircle: false,
                  radius: 16,
                ),
              ),
              15.ph,
              Text(
                rank.title ??
                    LocalizationHelper.tr
                        .rank_winning_conditions(rank.name ?? ''),
                style: TextStyles.font16BlackSemiBold.copyWith(
                  color: LightThemeColors.grey,
                ),
              ),
              15.ph,
              html.Html(
                data: rank.description ??
                    LocalizationHelper.tr.unspecified_phrase,
              ),
              15.ph,
              /*  Text(
                textAlign: TextAlign.justify,
                LocalizationHelper.tr.unspecified_phrase"
Become a Miles&Smiles Elite member for the most exclusive flying experience on domestic and international flights.LocalizationHelper.tr.unspecified_phrase",
                style: TextStyles.font12BlackBold.copyWith(
                  color: LightThemeColors.grey,
                  fontWeight: FontWeights.regular,
                  height: 1.5,
                ),
              ),
              15.ph,
              Text(
                textAlign: TextAlign.justify,
                LocalizationHelper.tr.unspecified_phrase"
Become a Miles&Smiles Elite member for the most exclusive flying experience on domestic and international flights.LocalizationHelper.tr.unspecified_phrase",
                style: TextStyles.font12BlackBold.copyWith(
                  color: LightThemeColors.grey,
                  fontWeight: FontWeights.regular,
                  height: 1.5,
                ),
              ),
              15.ph,
              Text(
                textAlign: TextAlign.justify,
                LocalizationHelper.tr.unspecified_phrase"
Become a Miles&Smiles Elite member for the most exclusive flying experience on domestic and international flights.LocalizationHelper.tr.unspecified_phrase",
                style: TextStyles.font12BlackBold.copyWith(
                  color: LightThemeColors.grey,
                  fontWeight: FontWeights.regular,
                  height: 1.5,
                ),
              ),
              15.ph,
              Text(
                textAlign: TextAlign.justify,
                LocalizationHelper.tr.unspecified_phrase"
Become a Miles&Smiles Elite member for the most exclusive flying experience on domestic and international flights.LocalizationHelper.tr.unspecified_phrase",
                style: TextStyles.font12BlackBold.copyWith(
                  color: LightThemeColors.grey,
                  fontWeight: FontWeights.regular,
                  height: 1.5,
                ),
              ),
              15.ph,
              Text(
                textAlign: TextAlign.justify,
                LocalizationHelper.tr.unspecified_phrase"
Become a Miles&Smiles Elite member for the most exclusive flying experience on domestic and international flights.LocalizationHelper.tr.unspecified_phrase",
                style: TextStyles.font12BlackBold.copyWith(
                  color: LightThemeColors.grey,
                  fontWeight: FontWeights.regular,
                  height: 1.5,
                ),
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
