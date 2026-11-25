import 'package:getincoffee/core/localization/localization_helper.dart';
import 'package:getincoffee/core/general/generalmodel.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/domain/request/home_request.dart';
import 'package:getincoffee/features/productdetails/domain/repository/repository.dart';
import 'package:getincoffee/features/productdetails/domain/request/productdetails_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'branch_map_states.dart';

class BranchMapCubit extends Cubit<BranchMapStates> {
  BranchMapCubit() : super(BranchMapInitial());

  static BranchMapCubit get(context) => BlocProvider.of(context);

  final HomeRepository homeRepository = locator<HomeRepository>();
  final ProductdetailsRepository productdetailsRepository =
      locator<ProductdetailsRepository>();

  late TabController secondtabController;
  late TabController tabController;

  int currentIndex = 0;
  int currentTab = 0;

  List<BranchCategory> categories = [];
  List<String> images = ["home_slider", "home_slider", "home_slider"];

  bool isDismiss = false;
  String branchId = LocalizationHelper.tr.unspecified_phrase;
  BranchModel? currentBranch;

  final TextEditingController branchNamecontroller = TextEditingController();

  /// init tabs + open branch bottomSheet if needed
  Future<BranchModel?> getBranches() async {
    emit(SearchBranchLoading());
    final response = await homeRepository.getBranches(
      name: branchNamecontroller.text,
    );
    if (isClosed) return null;
    if (response != null) {
      emit(BranchesLoadedSuccess(branches: response.branches ?? []));
      return response;
    } else {
      emit(BrancheesLoadedError());
      return null;
    }
  }

  /// get user branch
  Future<BranchModel?> userBranches() async {
    emit(UserBranchesLoading());
    // Position? position = await LocationService.getCurrentLocation();
    final response = await homeRepository.getBranches();
    if (response != null) {
      emit(UserBranchesSuccess(
        branches: response,
      ));
      return response;
    } else {
      emit(UserBranchesErroe());
      return null;
    }
  }

  /// get categories by branch

  /// get products
  ProductParams params = ProductParams();
  HomeModel homemodel = HomeModel();
  getproductsBycategories({bool changeTabbar = true}) async {
    emit(ProductsLoading());
    final response = await homeRepository.getBranchproducts(
      id: branchId,
      params: params,
    );
    if (response != null) {
      homemodel = HomeModel.fromMap(response);
      emit(ProductsLoadedSuccess(
        homeModel: homemodel,
        changeTab: changeTabbar,
      ));
    } else {
      emit(ProductsLoadedError());
    }
  }

  Future<bool> saveBranchTouser(
      {String? branchId, BuildContext? context}) async {
    emit(SaveBranchLoading());
    final response = await homeRepository.saveBranchtoUser(id: branchId);
    if (response != null) {
      //  currentBranch?.followed = true;
      emit(SaveBranckSuccess(
          id: branchId ?? LocalizationHelper.tr.unspecified_phrase));

      if (context != null) {
        Navigator.pop(
          context,
          true,
        );
      }

      return true;
    } else {
      emit(SaveBranchError());
      return false;
    }
  }

  followBranch() async {
    emit(FollowBranchLoading());
    final response = await homeRepository.saveBranchtoUser(id: branchId);
    if (response != null) {
      currentBranch?.followed = true;
      emit(FollowBranchSuccess(
          id: branchId));
    } else {
      emit(FollowBranchError());
    }
  }

  /// delete branch from user
  unfollowBranchtoUser() async {
    emit(DeleteBranchLoading());
    print(currentBranch?.followed.toString());
    final response = await homeRepository.deleteBranchtoUser(id: branchId);
    if (response != null) {
      currentBranch?.followed = false;
      emit(DeleteBranckSuccess());
    } else {
      emit(DeleteBranchError());
    }
  }

  /// add to cart
  AddtoCartRequest request = AddtoCartRequest();
  List<String> properties = [];
  addtoCart() async {
    emit(AddTocartLoading());
    final response = await productdetailsRepository.addtoCart(
      request: request..optionValueIds = properties,
    );
    if (response != null) {
      emit(AddTocartSuccess());
    } else {
      emit(AddTocartFailed());
    }
  }

  /// slider home and bottom baranch
  List<GeneralModel> sliders = [];
  Future<List<GeneralModel>?> getHomeSliders() async {
    emit(GetHomeSlidersLoading());
    final response = await homeRepository.getHomeSliders();
    if (response != null) {
      sliders = response;
      print(sliders.length);
      emit(GetHomeSlidersSuccess(sliders: sliders));
      return response;
    } else {
      emit(GetHomeSlidersError());
    }
    return null;
  }

  /// home text
  getHomeText() async {
    emit(GetHomeTextLoading());
    final response = await homeRepository.getHomeText();
    if (response != null) {
      emit(GetHomeTextSuccess());
    } else {
      emit(GetHomeTextError());
    }
  }

  /// notifications
  getAllnotifications() async {
    emit(GetAllNotificationsLoading());
    final response = await homeRepository.getAllnotifications();
    if (response != null) {
      emit(GetAllNotificationsSuccess());
    } else {
      emit(GetAllNotificationsError());
    }
  }
}
