import 'package:getincoffee/core/generated/images.dart';
import 'package:getincoffee/core/services/alerts.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/addresses/presentation/widgets/create_addreess_sheet_body.dart';
import 'package:getincoffee/features/cart/presentation/widgets/location_item.dart';
import 'package:getincoffee/shared/back_widget.dart';
import 'package:getincoffee/shared/widgets/button_widget.dart';
import 'package:getincoffee/shared/widgets/loadinganderror.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/localization/localization_helper.dart';
import '../../../../core/resources/font_manager.dart';
import '../../cubit/addresses_cubit.dart';
import '../../cubit/addresses_states.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressesCubit(),
      child: BlocConsumer<AddressesCubit, AddressesStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = AddressesCubit.get(context);
          return Scaffold(
            backgroundColor: LightThemeColors.white,
            appBar: AppBar(
              leading: const BackWidget(),
              centerTitle: false,
              title: Text(
                LocalizationHelper.tr.location,
                style: const TextStyle(
                  color: LightThemeColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: LoadingAndError(
              isLoading: state is GetAddressesLoading,
              isError: state is GetAddressesFailure,
              function: () {
                cubit.reset();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: AddressesBody(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddressesBody extends StatelessWidget {
  const AddressesBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = AddressesCubit.get(context);

    if (cubit.addressesModel?.data?.isNotEmpty ?? false) {
      return Column(
        children: [
          Expanded(
            child: BlocBuilder<AddressesCubit, AddressesStates>(
              builder: (context, state) {
                final addressesModel =
                    AddressesCubit.get(context).addressesModel;

                return ListView.separated(
                  itemCount: addressesModel?.data?.length ?? 0,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                  itemBuilder: (context, index) {
                    final address = addressesModel?.data?[index];
                    return LocationItemWidget(
                      onchoose: () {},
                      address: address!,
                      onEdit: (address) {
                        // cubit.editAddress(address);
                      },
                      onDelete: (id) {
                        cubit.deleteAddress(id);
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ButtonWidget(
            onTap: () {
              Alerts.bottomSheet(
                context,
                child: BlocProvider.value(
                  value: AddressesCubit.get(context),
                  child: const CreateAddreessSheetBody(),
                ),
                // child: const ChosseWaylocationSheetbody(),
              );
            },
            title: LocalizationHelper.tr.add_location,
          ),
          const SizedBox(height: 34),
        ],
      );
    }
    return const NoLocationsWidget();
  }
}

class NoLocationsWidget extends StatelessWidget {
  const NoLocationsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        215.ph,
        SvgPicture.asset(
          SvgAssets.personalLocation,
        ),
        20.ph,
        Text(
          LocalizationHelper.tr.enter_delivery_locations,
          style: TextStyles.font14BlackBold.copyWith(
            fontWeight: FontWeights.extraBold,
            fontSize: 21,
            color: LightThemeColors.primary,
          ),
        ),
        8.ph,
        Text(
          LocalizationHelper.tr.enter_location_description,
          style: TextStyles.font14BlackBold.copyWith(
            fontWeight: FontWeights.semiBold,
            fontSize: 12,
            color: LightThemeColors.grey,
          ),
        ),
        230.ph,
        // const Spacer(),
        ButtonWidget(
          onTap: () {
            Alerts.bottomSheet(
              context,
              child: BlocProvider.value(
                value: AddressesCubit.get(context),
                child: const CreateAddreessSheetBody(),
              ),
              // child: const ChosseWaylocationSheetbody(),
            );
          },
          title: LocalizationHelper.tr.add_location,
        ),
      ],
    );
  }
}
