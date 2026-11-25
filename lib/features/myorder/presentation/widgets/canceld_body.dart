import 'package:getincoffee/core/utils/extentions.dart';
import 'package:flutter/material.dart';

import '../../cubit/myorder_cubit.dart';
import 'myorderWidget.dart';

class CanceledBody extends StatefulWidget {
  const CanceledBody({
    super.key,
    this.cubit,
  });
  final MyorderCubit? cubit;
  @override
  State<CanceledBody> createState() => _CanceledBodyState();
}

class _CanceledBodyState extends State<CanceledBody> {
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
