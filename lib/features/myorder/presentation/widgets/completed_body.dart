import 'package:getincoffee/core/utils/extentions.dart';
import 'package:getincoffee/features/myorder/cubit/myorder_cubit.dart';
import 'package:flutter/material.dart';

import 'myorderWidget.dart';

class CompletedBody extends StatefulWidget {
  const CompletedBody({super.key, this.cubit});
  final MyorderCubit? cubit;
  @override
  State<CompletedBody> createState() => _CompletedBodyState();
}

class _CompletedBodyState extends State<CompletedBody> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => 10.ph,
      itemCount: 4,
      itemBuilder: (context, index) {
        return const Myorderwidget();
      },
    );
  }
}
