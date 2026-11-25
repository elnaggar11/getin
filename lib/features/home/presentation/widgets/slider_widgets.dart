import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/utils/launcher.dart';
import 'package:getincoffee/features/home/cubit/home_cubit.dart';
import 'package:getincoffee/features/home/cubit/home_states.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/presentation/widgets/glass_widget.dart';
import 'package:getincoffee/shared/widgets/default_image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SliderWidgets extends StatefulWidget {
  const SliderWidgets({
    super.key,
    this.images,
    this.radius = 0,
    this.withoutIcons = false,
    this.withleading = false,
    this.height,
    required this.myaspecRatio,
  });
  final List<String>? images;
  final double myaspecRatio;
  final bool withoutIcons;
  final bool withleading;
  final double radius;
  final double? height;

  @override
  State<SliderWidgets> createState() => _SliderWidgetsState();
}

class _SliderWidgetsState extends State<SliderWidgets> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    print(widget.images);
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.images?.length ?? 0,
          itemBuilder: (context, index, realIndex) {
            return AspectRatio(
              aspectRatio: widget.myaspecRatio,
              child: Container(
                  //height: widget.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                    widget.radius,
                  )),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.radius),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Your image
                        DefaultImageWidget(
                          widget.images?[index] ??
                              LocalizationHelper.tr.unspecified_phrase,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),

                        // Dark overlay
                        Container(
                          color: Colors.black
                              .withValues(alpha: 0.14), // adjust opacity here
                        ),
                      ],
                    ),
                  )),
            );
          },
          options: CarouselOptions(
            aspectRatio: widget.myaspecRatio,

            //  height: widget.height,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              currentIndex = index;
              setState(
                () {},
              );
              // print(currentIndex);
            },
          ),
        ),

        // Indicator
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: SliderDots(
            currentIndex: currentIndex,
            length: widget.images?.length ?? 0,
          ),
        ),

        // Back Button
        if (widget.withleading == true)
          Positioned(
            top: 40,
            left: LocalizationHelper.isRTL ? null : 16,
            right: LocalizationHelper.isRTL ? 16 : null,
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.4),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ).onTap(() {
              Navigator.pop(context);
            }),
          ),

        // Camera Button
        if (widget.withoutIcons == false)
          Positioned(
            top: 40,
            left: LocalizationHelper.isRTL == false ? null : 16,
            right: LocalizationHelper.isRTL == false ? 16 : null,
            // right: 16,
            child: const SliderIcons(),
          ),
      ],
    );
  }
}

class SliderIcons extends StatelessWidget {
  const SliderIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        return Row(
          spacing: 5,
          children: [
            GlassCircleButton(
                child: Center(
                  child: SvgPicture.asset(
                    SvgAssets.pickLocation,
                  ),
                ),
                onTap: () async {
                  final response = await Navigator.pushNamed(
                    context,
                    Routes.BranchesMapScreen,
                    arguments: LatLng(
                      double.parse(cubit.currentBranch?.latitude ?? "0"),
                      double.parse(cubit.currentBranch?.longitude ?? "0"),
                    ),
                  );
                  if (response != null) {
                    cubit.branchId = (response as BranchModel).id ??
                        LocalizationHelper.tr.unspecified_phrase;
                    cubit.getBranchcategories();
                  }
                }),
            GlassCircleButton(
              child: Center(
                child: SvgPicture.asset(
                  SvgAssets.call,
                ),
              ),
              onTap: () {
                if (HomeCubit.get(context).currentBranch?.phoneNumber == null) {
                  Alerts.snack(
                      text: LocalizationHelper.tr.no_phone_number,
                      state: SnackState.failed);
                  return;
                }
                LauncherHelper.call(
                    HomeCubit.get(context).currentBranch?.phoneNumber ??
                        LocalizationHelper.tr.unspecified_phrase);
              },
            ),
            GlassCircleButton(
                child: Center(
                  child: SvgPicture.asset(
                    SvgAssets.notification,
                  ),
                ),
                onTap: () async {
                  Navigator.pushNamed(
                    context,
                    Routes.NotificationScreen,
                  );
                }),
          ],
        );
      },
    );
  }
}

class SliderDots extends StatelessWidget {
  const SliderDots({
    super.key,
    this.currentIndex,
    this.index,
    this.length,
  });
  final int? currentIndex;
  final int? index;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length ?? 0,
        (i) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: currentIndex == i ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: currentIndex == i ? Colors.white : Colors.grey,
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
          );
        },
      ),
    );
  }
}
