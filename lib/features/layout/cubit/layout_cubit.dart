import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data_source/dio_helper.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/general/cubit/general_cubit.dart';
import '../../cart/domain/repository/repository.dart';
import '../../cart/domain/model/cart_model.dart';
import '../domain/repository/repository.dart';
import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitial());
  static LayoutCubit get(context) => BlocProvider.of(context);

  LayoutRepository layoutRepository = LayoutRepository(locator<DioService>());
  late TabController tabController;

  initTabBar(vsync, [int index = 0]) {
    tabController = TabController(length: 5, vsync: vsync, initialIndex: index);
    _fetchInitialCartCount();
  }

  Future<void> _fetchInitialCartCount() async {
    final response = await locator<CartRepository>().getAllcart();
    if (response != null) {
      if (response is List) {
        locator<GeneralCubit>().updateCartCount(0);
      } else {
        final cartModel = CartModel.fromMap(response);
        locator<GeneralCubit>().updateCartCount(cartModel.totalQuantity);
      }
    }
  }

  void changeTab(int tab) {
    print(tab);
    switch (tab) {
      case 0:
        tabController.animateTo(0);
        break;
      case 1:
        tabController.animateTo(1);
        break;
      case 2:
        tabController.animateTo(2);
        break;
      case 3:
        tabController.animateTo(3);
        break;
      case 4:
        tabController.animateTo(4);
        break;
      case 5:
        tabController.animateTo(5);
        break;
      default:
    }
    emit(HomeLayoutChangeScreenState());
  }
}
