import 'dart:ui' as ui;

import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/services/location_service.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/core/utils/launcher.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/map/branch_map_cubit.dart';
import 'package:getincoffee/features/home/map/branch_map_states.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:getincoffee/shared/widgets/edit_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/resources/font_manager.dart';
import '../../../../shared/widgets/default_image_widget.dart';

class BranchesMapScreen extends StatefulWidget {
  final LatLng? initialLocation;
  const BranchesMapScreen({super.key, this.initialLocation});

  @override
  State<BranchesMapScreen> createState() => _BranchesMapScreenState();
}

class _BranchesMapScreenState extends State<BranchesMapScreen>
    with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  List<BranchModel> _filteredBranches = [];
  bool _showAutocomplete = false;

  bool _loadingLocation = true;
  Future<void> _initLocation() async {
    if (widget.initialLocation != null) {
      _initialPosition = widget.initialLocation!;
      setState(() {
        _loadingLocation = false;
      });
      return;
    }

    try {
      final pos = await LocationService.getCurrentLocation();
      if (!mounted) return;
      if (pos != null) {
        _initialPosition = LatLng(pos.latitude, pos.longitude);
      }
      setState(() {
        _loadingLocation = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingLocation = false;
      });
    }
  }

  final Set<Marker> _markers = {};
  String? _mapStyle;
  LatLng _initialPosition = const LatLng(32.033333, 32.233334);
  final List<BranchModel> branches = [];

  Future<BitmapDescriptor> createTextMarker(
    String text, {
    Color bgColor = LightThemeColors.primary,
    Color textColor = Colors.white,
    double fontSize = 36,
  }) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final Paint paint = Paint()..color = bgColor;
    const double radius = 40;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final double width = textPainter.width + 40;
    final double height = textPainter.height + 40;
    const double arrowHeight = 20;

    final RRect rect = RRect.fromLTRBR(
      0,
      0,
      width,
      height,
      const Radius.circular(radius),
    );
    canvas.drawRRect(rect, paint);

    final Path trianglePath = Path();
    trianglePath.moveTo(width / 2 - 15, height);
    trianglePath.lineTo(width / 2 + 15, height);
    trianglePath.lineTo(width / 2, height + arrowHeight);
    trianglePath.close();
    canvas.drawPath(trianglePath, paint);

    final Offset textOffset = Offset(
      (width - textPainter.width) / 2,
      (height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);

    final ui.Image image = await recorder
        .endRecording()
        .toImage(width.toInt(), (height + arrowHeight).toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
    rootBundle.loadString('assets/json/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BranchMapCubit(),
      child: BlocConsumer<BranchMapCubit, BranchMapStates>(
        listener: (context, state) {
          if (state is BranchesLoadedSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              if (!mounted) return;
              branches.clear();
              branches.addAll(state.branches);
              for (final e in branches) {
                final icon = await createTextMarker(
                  e.name ?? LocalizationHelper.tr.unspecified_phrase,
                );
                if (!mounted) return;
                _markers.add(
                  Marker(
                    markerId: MarkerId(e.id!),
                    position: LatLng(e.latitude?.toDouble() ?? 0,
                        e.longitude?.toDouble() ?? 0),
                    icon: icon,
                    onTap: () {
                      LauncherHelper.openGoogleMaps(
                        e.latitude?.toDouble() ?? 0,
                        e.longitude?.toDouble() ?? 0,
                      );
                      //  Navigator.pop(context, e);
                    },
                  ),
                );
                setState(() {});
              }

              if (widget.initialLocation == null && branches.isNotEmpty) {
                double minDistance = double.infinity;
                LatLng? nearestLocation;

                for (var b in branches) {
                  final lat = double.tryParse(b.latitude ?? "0") ?? 0;
                  final lng = double.tryParse(b.longitude ?? "0") ?? 0;
                  final distance = Geolocator.distanceBetween(
                    _initialPosition.latitude,
                    _initialPosition.longitude,
                    lat,
                    lng,
                  );
                  if (distance < minDistance) {
                    minDistance = distance;
                    nearestLocation = LatLng(lat, lng);
                  }
                }

                if (nearestLocation != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(nearestLocation, 15),
                  );
                }
              }
            });
          }
        },
        builder: (context, state) {
          final cubit = BranchMapCubit.get(context);
          if (_loadingLocation) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Loading Location'),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) async {
                    _mapController = controller;
                    await cubit.getBranches();
                    if (_mapStyle != null) {
                      // ignore: deprecated_member_use
                      _mapController!.setMapStyle(_mapStyle);
                    }
                    /*  final current = await LocationService.getCurrentLocation();
                    if (current != null) {
                      _mapController!.animateCamera(
                        CameraUpdate.newLatLngZoom(
                          LatLng(current.latitude, current.longitude),
                          16,
                        ),
                      );
                    } */
                  },
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 15,
                  ),
                  markers: _markers,
                  zoomControlsEnabled: false,
                  onTap: (_) {
                    setState(() {
                      _showAutocomplete = false;
                    });
                  },
                ),
                // if (_selectedBranch != null)
                Positioned(
                  bottom: 54,
                  right: 20,
                  left: 20,
                  child: SizedBox(
                    height: 110,
                    child: ListView.separated(
                        separatorBuilder: (context, index) => 10.pw,
                        scrollDirection: Axis.horizontal,
                        itemCount: branches.length,
                        itemBuilder: (context, index) {
                          final branch = branches[index];
                          return BranchInfoCard(
                            branch: branch,
                            onTap: () {
                              Navigator.pop(context, branch);

                              /*   cubit
                                  .saveBranchTouser(branchId: branch.id)
                                  .then((val) {
                                if (val == true) {
                                }
                              }); */
                            },
                          );
                        }),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 15,
                  right: 15,
                  child: _buildSearchBar(cubit, this),
                ),
                if (_showAutocomplete)
                  Positioned(
                    top: 105,
                    left: 80,
                    right: 20,
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        constraints: const BoxConstraints(maxHeight: 350),
                        child: _filteredBranches.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No branches found',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero, // <-- important

                                itemCount: _filteredBranches.length,
                                itemBuilder: (context, index) {
                                  final branch = _filteredBranches[index];

                                  return GestureDetector(
                                    onTap: () {
                                      // Fill text field
                                      cubit.branchNamecontroller.text =
                                          branch.name ?? '';

                                      // Hide suggestions
                                      setState(() {
                                        _showAutocomplete = false;
                                      });

                                      // Center map on this branch
                                      _mapController?.animateCamera(
                                        CameraUpdate.newLatLngZoom(
                                          LatLng(
                                            double.tryParse(
                                                    branch.latitude ?? "0") ??
                                                0,
                                            double.tryParse(
                                                    branch.longitude ?? "0") ??
                                                0,
                                          ),
                                          16,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: const [],
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: branch.image !=
                                                    null
                                                ? NetworkImage(branch.image!)
                                                : null,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  branch.name ?? '',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),

                Positioned(
                  bottom: 180,
                  right: 15,
                  child: _buildZoomButtons(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BranchMapCubit cubit, TickerProviderStateMixin vsync) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            icon: const BackWidget(),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        20.pw,
        Expanded(
          flex: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1,
                color: LightThemeColors.lightgrey.withValues(alpha: .2),
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                30.pw,
                InkWell(
                  onTap: () {
                    NavigationHelper.pop();
                    /*   cubit.searchBranch(
                      context,
                      vsync: vsync,
                      filter: true,
                    ); */
                  },
                  child: const Row(
                    children: [
                      Text(
                        "branches",
                        style: TextStyle(
                          fontWeight: FontWeights.regular,
                          fontSize: 14,
                          color: LightThemeColors.grey,
                        ),
                      ),
                      // 20.pw,
                      Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(SvgAssets.filterHomeIcon),
                ),
                Expanded(
                  child: TextFormFieldWidget(
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _filteredBranches = [];
                          _showAutocomplete = false;
                        });
                        return;
                      }

                      setState(() {
                        _filteredBranches = branches
                            .where((b) => (b.name ?? '')
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();

                        _showAutocomplete = true;
                      });
                    },

                    controller: cubit.branchNamecontroller,
                    // decoration: InputDecoration(
                    hintText: LocalizationHelper.tr.search_branches,
                    hintSize: 14,

                    // border: InputBorder.none,
                    contentPadding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 10),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildZoomButtons() {
    return Column(
      children: [
        FloatingActionButton.small(
          key: const Key('zoom_in'),
          onPressed: () => _mapController?.animateCamera(CameraUpdate.zoomIn()),
          backgroundColor: Colors.black87,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        const SizedBox(height: 8),
        FloatingActionButton.small(
          key: const Key('zoom_out'),
          onPressed: () =>
              _mapController?.animateCamera(CameraUpdate.zoomOut()),
          backgroundColor: Colors.black87,
          child: const Icon(Icons.remove, color: Colors.white),
        ),
      ],
    );
  }
}

class BranchInfoCard extends StatelessWidget {
  const BranchInfoCard({
    super.key,
    required this.branch,
    this.onTap,
  });

  final BranchModel branch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            width: 1,
            color: LightThemeColors.primary,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: ClipOval(
                child: DefaultImageWidget(
                  branch.image ?? LocalizationHelper.tr.unspecified_phrase,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    branch.name ?? LocalizationHelper.tr.no_name,
                    style: TextStyles.font16BlackBold.copyWith(
                      fontWeight: FontWeights.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    branch.description ?? LocalizationHelper.tr.no_description,
                    style: TextStyles.font14BlackMedium.copyWith(
                      color: LightThemeColors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(SvgAssets.Star, width: 16, height: 16),
                      const SizedBox(width: 4),
                      Text(
                        branch.averageRating != null
                            ? branch.averageRating!
                            : "5.0",
                        style: TextStyles.font14BlackMedium,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        "(${branch.totalRating ?? "0"}+)",
                        style: TextStyles.font14BlackMedium.copyWith(
                          color: LightThemeColors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildDot(),
                      const SizedBox(width: 8),
                      Text(
                        "${branch.distance ?? ""} ",
                        style: TextStyles.font14BlackMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: LightThemeColors.lightgrey,
        shape: BoxShape.circle,
      ),
    );
  }
}
