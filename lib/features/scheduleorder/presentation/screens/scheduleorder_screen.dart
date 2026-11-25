import 'package:getincoffee/core/Router/Router.dart';
import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/scheduleorder/domain/model/scheduleorder_model.dart';
import 'package:getincoffee/features/scheduleorder/presentation/widgets/scheduleorder_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/theme/light_theme.dart';
import '../../../../shared/back_widget.dart';
import '../../cubit/scheduleorder_cubit.dart';
import '../../cubit/scheduleorder_states.dart';

class ScheduleorderScreen extends StatefulWidget {
  const ScheduleorderScreen({super.key});

  @override
  State<ScheduleorderScreen> createState() => _ScheduleorderScreenState();
}

class _ScheduleorderScreenState extends State<ScheduleorderScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleorderCubit()..addpageListener(),
      child: BlocConsumer<ScheduleorderCubit, ScheduleorderStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          final cubit = ScheduleorderCubit.get(context);
          return Scaffold(
            backgroundColor: LightThemeColors.white,
            appBar: AppBar(
              leading: const BackWidget(),
              centerTitle: false,
              title: Text(
                LocalizationHelper.tr.my_order_schedule,
                style: const TextStyle(
                  color: LightThemeColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Column(
              children: [
                17.ph,
                Expanded(
                  child: PagedListView.separated(
                    builderDelegate:
                        PagedChildBuilderDelegate<ScheduleorderModel>(
                      itemBuilder: (context, item, i) {
                        return ScheduleorderItem(
                          item: item,
                          onRefresh: () {
                            cubit.paginationController.refresh();
                          },
                        );
                      },
                    ),
                    separatorBuilder: (context, i) => 10.ph,
                    pagingController: cubit.paginationController,
                  ),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: LightThemeColors.primary,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.CreateSchedulorderScreen,
                ).then((e) {
                  if (context.mounted && e != null) {
                    ScheduleorderCubit.get(context)
                        .paginationController
                        .refresh();
                  }
                });
              },
              child: const Icon(
                color: LightThemeColors.white,
                Icons.add,
              ),
            ),
          );
        },
      ),
    );
  }
}
