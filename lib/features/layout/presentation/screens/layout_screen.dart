import 'dart:io';

import 'package:getincoffee/core/general/cubit/general_cubit.dart';
import 'package:getincoffee/core/utils/Locator.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/edit_profile/presentation/widgets/drawer_widget.dart';
import 'package:getincoffee/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import '../../../home/presentation/screens/home_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../edit_profile/presentation/screens/edit_profile_screen.dart';
import '../../../favorite/presentation/screens/favorite_screen.dart';
import '../../../myorder/presentation/screens/myorder_screen.dart';
import '../../cubit/layout_cubit.dart';
import '../../cubit/layout_states.dart';
import '../../../home/cubit/home_cubit.dart';
import '../widgets/widgets.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.index});
  final int? index;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    locator<GeneralCubit>().getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          var result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: const Text('Exit'),
                ),
              ],
            ),
          );
          return result ?? false;
        }
        return false;
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                LayoutCubit()..initTabBar(this, widget.index ?? 0),
          ),
          BlocProvider(
            create: (context) => HomeCubit()..init(context, vsync: this),
          ),
        ],
        child: BlocConsumer<LayoutCubit, LayoutStates>(
          listener: (context, state) {},
          builder: (context, state) {
            final cubit = LayoutCubit.get(context);
            return Scaffold(
              key: Utils.scaffoldKey,
              drawer: const ProfileDrawerWidget(),
              drawerEnableOpenDragGesture: false, // 👈 disables swipe-to-open

              body: TabBarView(
                controller: cubit.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  //    const HomeScreen(),
                  HomeScreen(
                      // color: Colors.black,
                      ),
                  CartScreen(),
                  MyorderScreen(),
                  FavoriteScreen(),
                  EditProfileScreen(),
                ],
              ),
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: cubit.tabController.index,
                onTap: cubit.changeTab,
              ),
              extendBody: false,
            );
          },
        ),
      ),
    );
  }
}
