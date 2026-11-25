import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:getincoffee/features/myorder/cubit/myorder_states.dart';

import '../../cubit/myorder_cubit.dart';
import 'myorderWidget.dart';

class OngoingBody extends StatefulWidget {
  const OngoingBody({
    super.key,
    this.cubit,
  });
  final MyorderCubit? cubit;

  @override
  State<OngoingBody> createState() => _OngoingBodyState();
}

class _OngoingBodyState extends State<OngoingBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.cubit?.myorderModel?.orders?.isEmpty ?? true) {
      return const NoOrdersWidget();
    }

    return BlocListener<MyorderCubit, MyorderStates>(
      listener: (context, state) {},
      child: ListView.separated(
        separatorBuilder: (context, index) => 10.ph,
        itemCount: widget.cubit?.myorderModel?.orders?.length ?? 0,
        itemBuilder: (context, index) {
          if (index == 4) {
            log(
                widget.cubit?.myorderModel?.orders?[index].toString() ??
                    'dasdasda',
                name: "myorder");
          }
          return Myorderwidget(
            item: widget.cubit?.myorderModel?.orders?[index],
            reorder: () => widget.cubit?.reOrder(
                widget.cubit?.myorderModel?.orders?[index].id ??
                    LocalizationHelper.tr.unspecified_phrase),
            delete: () => widget.cubit?.cancelOrder(
                widget.cubit?.myorderModel?.orders?[index].id ??
                    LocalizationHelper.tr.unspecified_phrase),
          );
        },
      ),
    );
  }
}

class NoOrdersWidget extends StatelessWidget {
  const NoOrdersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration or icon
            Icon(
              Icons.shopping_bag_outlined,
              size: 96,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 24),

            // Title text
            Text(
              LocalizationHelper.tr.no_orders_yet,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),

            // Description text
            Text(
              LocalizationHelper.tr.no_orders_description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
