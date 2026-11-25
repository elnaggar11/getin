import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/extensions/all_extensions.dart';
import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/cart/qr_order/cubit/qr_cubit.dart';
import 'package:getincoffee/features/cart/domain/model/home_change_model.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getincoffee/features/cart/presentation/screens/trackorder/cubit/track_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:path_provider/path_provider.dart';
import 'package:scanning_effect/scanning_effect.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/resources/font_manager.dart';
import '../../../../core/theme/light_theme.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({
    super.key,
    this.id,
  });
  final String? id;
  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  File? file;
  late final TrackCubit _trackCubit;

  // QR Scanner Controller
  late MobileScannerController _scannerController;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _trackCubit = TrackCubit();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  void _toggleScanner() {
    setState(() {
      _isScanning = !_isScanning;
      if (_isScanning) {
        _scannerController.start();
      } else {
        _scannerController.stop();
      }
    });
  }

  void _onDetect(BarcodeCapture capture, BuildContext context) {
    final barcode = capture.barcodes.first;
    final value = barcode.rawValue;

    if (value != null && value.isNotEmpty) {
      setState(() {
        _isScanning = false;
        log(value, name: 'QR Data');
        QrCubit.get(context).confirmOrder(value);
      });

      _scannerController.stop();
    }
  }

  Widget? cleanimage({required String base64String}) {
    log(base64String, name: LocalizationHelper.tr.photo);
    try {
      String cleaned = base64String.contains(",")
          ? base64String.split(",").last
          : base64String;

      cleaned = cleaned
          .replaceAll('\n', LocalizationHelper.tr.unspecified_phrase)
          .replaceAll('\r', LocalizationHelper.tr.unspecified_phrase)
          .trim();

      Uint8List bytes = base64Decode(cleaned);

      return Image.memory(
        bytes,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Text(LocalizationHelper.tr.invalid_image);
        },
      );
    } catch (e) {
      return Text("${LocalizationHelper.tr.error_decoding}: $e");
    }
  }

  Future<void> shareBase64Image(String base64Str, {String? fileName}) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = '${dir.path}/${fileName ?? "image"}.png';
    log(base64Str, name: "base64Str");
    String cleaned =
        base64Str.contains(",") ? base64Str.split(",").last : base64Str;

    cleaned = cleaned
        .replaceAll('\n', LocalizationHelper.tr.unspecified_phrase)
        .replaceAll('\r', LocalizationHelper.tr.unspecified_phrase)
        .trim();

    File filepath = File(path);
    file = await filepath.writeAsBytes(base64Decode(cleaned));

    setState(() {});
  }

  @override
  void dispose() {
    _trackCubit.close();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _trackCubit,
      child: BlocProvider(
        create: (context) => QrCubit()..getSinglCode(id: widget.id!),
        child: BlocConsumer<QrCubit, QrState>(
          listener: (context, state) {
            if (state is GetQrOrderSuccess) {
              QrCubit.get(context).orderItemModel = state.orderItemModel;
              shareBase64Image(
                state.orderItemModel.qr_data_uri ??
                    LocalizationHelper.tr.unspecified_phrase,
                fileName: 'order_${state.orderItemModel.id ?? ''}',
              );
            }
            if (state is QrReaderSuccess) {
              NavigationHelper.popUntilRoute(Routes.layoutScreen,
                  result: "done work");
              Alerts.snack(text: state.response, state: SnackState.success);
            }
          },
          builder: (context, state) {
            final cubit = QrCubit.get(context);

            return WillPopScope(
              onWillPop: () async {
                NavigationHelper.popUntilRoute(Routes.layoutScreen,
                    result: true);
                return false;
              },
              child: Scaffold(
                backgroundColor: LightThemeColors.primary,
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocalizationHelper.tr.success,
                        style: TextStyles.font20WhiteSemiBold.copyWith(
                          color: LightThemeColors.white,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: LightThemeColors.primary,
                  automaticallyImplyLeading: false,
                  leading: const Icon(
                    Icons.arrow_back_sharp,
                    color: LightThemeColors.white,
                  ).onTap(
                    () {
                      NavigationHelper.popUntilRoute(Routes.layoutScreen,
                          result: true);
                    },
                  ),
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: LightThemeColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LoadingAndError(
                    isLoading:
                        state is GetQrOrderLoading || state is QrReaderLoading,
                    isError: state is GetQrOrderError,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          30.ph,
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocalizationHelper.tr.payment_successful,
                                    style:
                                        TextStyles.font16BlackSemiBold.copyWith(
                                      color: LightThemeColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeights.extraBold,
                                    ),
                                  ),
                                  ButtonWidget(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.MypointsScreen,
                                      );
                                    },
                                    fontSize: 12,
                                    height: 35,
                                    width: 110,
                                    buttonColor: LightThemeColors.black,
                                    title: LocalizationHelper.tr.points,
                                    fontweight: FontWeights.semiBold,
                                  )
                                ],
                              ),
                              8.ph,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    LocalizationHelper.tr.order_confirmed,
                                    style: TextStyles.font14BlackBold.copyWith(
                                      fontSize: 12,
                                      color: LightThemeColors.grey,
                                      fontWeight: FontWeights.semiBold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        LocalizationHelper.tr
                                            .user_points_increase(cubit
                                                    .orderItemModel
                                                    ?.pointsIncreaseUser ??
                                                ''),
                                        style:
                                            TextStyles.font14BlackBold.copyWith(
                                          fontSize: 12,
                                          color: LightThemeColors.green,
                                          fontWeight: FontWeights.semiBold,
                                        ),
                                      ),
                                      25.pw,
                                    ],
                                  ),
                                ],
                              ),
                              13.ph,
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 23.5,
                                        vertical: 20,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: LightThemeColors.cardBackground,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 46,
                                            height: 46,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: LightThemeColors.primary,
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                SvgAssets.TicketStar,
                                              ),
                                            ),
                                          ),
                                          15.ph,
                                          Text(
                                            LocalizationHelper.tr.order_id,
                                            style: TextStyles.font14BlackMedium
                                                .copyWith(
                                              color: LightThemeColors.grey,
                                              fontWeight: FontWeights.regular,
                                            ),
                                          ),
                                          Text(
                                            "#${cubit.orderItemModel?.id ?? LocalizationHelper.tr.unspecified_phrase}",
                                            style: TextStyles.font14BlackMedium
                                                .copyWith(
                                              color: LightThemeColors.grey,
                                              fontWeight: FontWeights.regular,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  12.pw,
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 23.5,
                                        vertical: 20,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: LightThemeColors.cardBackground,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 46,
                                            height: 46,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: LightThemeColors.primary,
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                SvgAssets.cartClock,
                                              ),
                                            ),
                                          ),
                                          15.ph,
                                          Text(
                                            LocalizationHelper
                                                .tr.order_receipt_time,
                                            style: TextStyles.font14BlackMedium
                                                .copyWith(
                                              color: LightThemeColors.grey,
                                              fontWeight: FontWeights.regular,
                                            ),
                                          ),
                                          Text(
                                            LocalizationHelper.tr
                                                .order_receipt_time_minutes(cubit
                                                        .orderItemModel
                                                        ?.orderReceiptTime ??
                                                    ''),
                                            style: TextStyles.font14BlackMedium
                                                .copyWith(
                                              color: LightThemeColors.grey,
                                              fontWeight: FontWeights.regular,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              10.ph,
                              // Show QR Scanner if userLocation is null, otherwise show QR code
                              if (cubit.orderItemModel?.userLocation == null)
                                QrScannerSection(
                                  isScanning: _isScanning,
                                  onToggleScanner: _toggleScanner,
                                  scannerController: _scannerController,
                                  onDetect: _onDetect,
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 30,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: LightThemeColors.cardBackground,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: cleanimage(
                                        base64String:
                                            cubit.orderItemModel?.qr_data_uri ??
                                                LocalizationHelper
                                                    .tr.unspecified_phrase),
                                  ),
                                ),
                            ],
                          ),
                          Column(
                            children: [
                              ButtonWidget(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.TrackorderScreen,
                                    arguments: TrackorderScreenArgs(
                                      orderItemModel: cubit.orderItemModel,
                                      trackCubit: context.read<TrackCubit?>(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocalizationHelper.tr.track_order,
                                        style: TextStyles.font16BlackRegular
                                            .copyWith(
                                          color: LightThemeColors.white,
                                          fontWeight: FontWeights.medium,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        SvgAssets.buttonLocation,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              12.ph,
                              if (cubit.orderItemModel?.userLocation != null)
                                Builder(builder: (context) {
                                  return ButtonWidget(
                                    onTap: () {
                                      Share.shareXFiles(
                                        [
                                          XFile(
                                            file?.path ??
                                                LocalizationHelper
                                                    .tr.unspecified_phrase,
                                            mimeType: 'image/png',
                                          )
                                        ],
                                      );
                                    },
                                    buttonColor: LightThemeColors.black,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            LocalizationHelper.tr.share,
                                            style: TextStyles.font16BlackRegular
                                                .copyWith(
                                              color: LightThemeColors.white,
                                              fontWeight: FontWeights.medium,
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            SvgAssets.share,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              12.ph,
                              ButtonWidget(
                                onTap: () {
                                  NavigationHelper.popUntilRoute(
                                    Routes.layoutScreen,
                                    result: HomeChangeModel(page: 0),
                                  );
                                },
                                buttonColor: LightThemeColors.orange,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocalizationHelper.tr.back_to_branch,
                                        style: TextStyles.font16BlackRegular
                                            .copyWith(
                                          color: LightThemeColors.black,
                                          fontWeight: FontWeights.medium,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward,
                                        color: LightThemeColors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              38.ph,
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build QR Scanner Section with camera view
}

class QrScannerSection extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onToggleScanner;
  final MobileScannerController scannerController;
  final Function(BarcodeCapture, BuildContext) onDetect;

  const QrScannerSection({
    super.key,
    required this.isScanning,
    required this.onToggleScanner,
    required this.scannerController,
    required this.onDetect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: LightThemeColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isScanning)
                  ScanningEffect(
                    borderLineStrokeWidth: 2,
                    scanningHeightOffset: 0.01,
                    scanningColor: const Color(0xff0C3B33),
                    borderLineColor: LightThemeColors.primary,
                    child: MobileScanner(
                      controller: scannerController,
                      onDetect: (capture) => onDetect(capture, context),
                    ),
                  )
                else
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: LightThemeColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 80,
                          color: LightThemeColors.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          LocalizationHelper.tr.scan_qr_code,
                          textAlign: TextAlign.center,
                          style: TextStyles.font16BlackSemiBold.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          LocalizationHelper.tr.scan_instruction_message,
                          textAlign: TextAlign.center,
                          style: TextStyles.font14BlackMedium.copyWith(
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Scan button
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: LightThemeColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: LightThemeColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              isScanning ? Icons.stop : Icons.qr_code_scanner,
            ),
            iconSize: 30,
            color: Colors.white,
            onPressed: onToggleScanner,
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
