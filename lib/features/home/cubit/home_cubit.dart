import 'dart:developer';
import 'package:getincoffee/core/general/cubit/general_cubit.dart';

import 'package:getincoffee/core/Router/navigation_helper.dart';
import 'package:getincoffee/core/general/generalmodel.dart';
import 'package:getincoffee/core/services/location_service.dart';
import 'package:getincoffee/core/utils/utils.dart';
import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/home/domain/model/slider_model.dart';
import 'package:getincoffee/features/home/domain/request/filter_request.dart';
import 'package:getincoffee/features/home/domain/request/home_request.dart';
import 'package:getincoffee/features/home/presentation/widgets/bottom_sheet/search_bottom_sheet.dart'
    show SearchBottomSheet;
import 'package:getincoffee/features/productdetails/domain/repository/repository.dart';
import 'package:getincoffee/features/productdetails/domain/request/productdetails_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/services/alerts.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitial()) {
    // init(context, vsync: vsync);
  }
  // : super(HomeInitial());
  ProductFilter productFilter = ProductFilter();
  static HomeCubit get(context) => BlocProvider.of(context);

  final HomeRepository homeRepository = locator<HomeRepository>();
  final ProductdetailsRepository productdetailsRepository =
      locator<ProductdetailsRepository>();

  late TabController secondtabController;
  late TabController tabController;

  int currentIndex = 0;
  int currentTab = 0;

  List<BranchCategory> categories = [];
  List<String> images = ["home_slider", "home_slider", "home_slider"];

  bool isDismiss = true;
  String branchId = "";
  BranchModel? currentBranch;
  PagedProducts? pagedProducts;
  PagingController<int, ProductModel>? pagingController;

  final TextEditingController branchNamecontroller = TextEditingController();
  setPrimaryBranch(BranchModel branch) {
    emit(BranchLoading());
    currentBranch = branch;
    if (currentBranch?.isDelivery == false) {
      GeneralCubit.get(NavigationHelper.context).updateDeliveryType(1);
    }
    emit(HomeBranchChanges());

    branchId = (branch).id ?? "";
    Utils.branchId = branch.id ?? "";
    log(Utils.branchId, name: "tt");

    getBranchcategories();
    emit(BranchChanges());

    // init(context, vsync: vsync, withsheet: false); // refresh
  }

  searchByName(String name) {
    emit(ProductFilterChangesStart());
    if (productFilter.search != name) {
      productFilter.search = name;
      changeProductFilter(productFilter);
    }
  }

  changeProductFilter(ProductFilter filter) async {
    emit(ProductFilterChangesStart());

    productFilter = filter;
    if (!productFilter.isAllNull()) {
      if (pagingController == null) {
        pagingController = PagingController(firstPageKey: 1);
        pagingController!.addPageRequestListener((pageKey) {
          getFilterProduct(pageKey);
        });
      } else {
        pagingController!.refresh();
      }
    } else {
      pagingController?.dispose();
      pagingController = null;
    }
    emit(ProductFilterChangesSuccess());
  }

  getFilterProduct(int page) async {
    emit(ProductFilterChangesStart());
    try {
      var res = await homeRepository.getProductsByFilter(
          filter: productFilter, branchId: branchId, page: page);
      if (res != null) {
        pagedProducts = res;
        final isLastPage = (res.lastPage ?? 1) <= page;
        if (isLastPage) {
          pagingController?.appendLastPage(res.products ?? []);
        } else {
          final nextPageKey = page + 1;
          pagingController?.appendPage(res.products ?? [], nextPageKey);
        }
        emit(ProductFilterChangesSuccess());
      } else {
        pagingController?.error = "Error loading products";
        emit(ProductFilterChangesFail());
      }
    } catch (e) {
      pagingController?.error = e;
      emit(ProductFilterChangesFail());
    }
  }

  setBranchById(String id) {
    emit(BranchLoading());
    if (id != branchId) {
      branchId = id;
      getBranchcategories();
      getproductsBycategories();
      emit(BranchChanges());
    }
  }

  /// init tabs + open branch bottomSheet if needed
  init(
    BuildContext context, {
    required TickerProviderStateMixin vsync,
    bool? withsheet = true,
    BranchModel? branch,
  }) async {
    secondtabController =
        TabController(length: categories.length + 2, vsync: vsync);
    tabController = TabController(length: 2, vsync: vsync);

    print(branchId);
    if (branch != null) {
      branchId = branch.id ?? "";
      currentBranch = branch;
      emit(HomeBranchChanges());

      getBranchcategories();
      emit(BranchChanges());
    } else {
      if (withsheet == true) {
        print("withsheet");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          userBranches().then((val) async {
            if (val?.branches?.isNotEmpty == true) {
              branchId = val?.branches?.first.id ?? "";
              currentBranch = val?.branches?.first;
              if (currentBranch?.isDelivery == false) {
                GeneralCubit.get(NavigationHelper.context)
                    .updateDeliveryType(1);
              }
              isDismiss = false;
              getBranchcategories().then((_) {
                // ignore: use_build_context_synchronously
                init(context, vsync: vsync, withsheet: false);
              });
            }
            if (val != null) {
              // final homeText = await getHomeText();
              final homeSlider = await getHomeAds();
              emit(BranchBottomSheetState(homeSlider: homeSlider, branch: val));
            }
          });
        });
      }
    }
  }

  /// search in branches
  searchBranch(
    BuildContext context, {
    required TickerProviderStateMixin vsync,
    Function(BranchModel val)? ontap,
    bool filter = false,
    bool withpop = true,
  }) {
    getBranches().then((val) {
      if (withpop) {
        NavigationHelper.pop();
      }

      if (val != null) {
        log(isDismiss.toString(), name: "isDismiss");

        Alerts.bottomSheet(
          // ignore: use_build_context_synchronously
          NavigationHelper.context,
          isdismissible: isDismiss,
          close: (val) async {
            if (val != null) {
              print(val);
              currentBranch = val;
              if (currentBranch?.isDelivery == false) {
                GeneralCubit.get(NavigationHelper.context)
                    .updateDeliveryType(1);
              }
              emit(HomeBranchChanges());

              branchId = (val as BranchModel).id ?? "";
              Utils.branchId = branchId;

              getBranchcategories().then((_) {
                filter == true
                    ? null
                    // ignore: use_build_context_synchronously
                    : init(context, vsync: vsync, withsheet: false);
              });

              return true;
            } else {
              // Keep the modal closed when dismissal is allowed. The previous
              // inverted condition reopened the sheet after the close action.
              return isDismiss;
            }
          },
          child: SearchBottomSheet(
            onBranchSelected: ontap,
            branches: val.branches,
          ),
        );
      }
    });
  }

  /// get branches list
  Future<BranchModel?> getBranches() async {
    emit(SearchBranchLoading());
    final response = await homeRepository.getBranches(
      name: branchNamecontroller.text,
    );
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
    Position? position = await LocationService.getCurrentLocation();
    final response = await homeRepository.userBranch(position: position);
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
  Future<BranchCategory?> getBranchcategories() async {
    emit(BranchCategoriesLoading());
    final response = await homeRepository.getBranchCategories(id: branchId);
    if (response != null) {
      categories = response.categories ?? [];
      emit(BranchLoadedSuccess(categories: categories));
      return response;
    } else {
      emit(BranchCategoriesError());
      return null;
    }
  }

  /// get products
  ProductParams params = ProductParams();
  HomeModel homemodel = HomeModel();
  getproductsBycategories({bool changeTabbar = true}) async {
    emit(ProductsLoading());
    final response = await homeRepository.getBranchproducts(
      id: branchId,
      params: params,
    );
    if (response is List && homemodel.branch?.id == branchId) {
      homemodel.newproducts = [];
      homemodel.popularproducts = [];
      homemodel.category = null;
      emit(ProductsLoadedSuccess(
        homeModel: homemodel,
        changeTab: changeTabbar,
      ));
    } else if (response is List && homemodel.branch?.id != branchId) {
      emit(ProductsLoadedEmpty());
    } else {
      if (response != null) {
        homemodel = HomeModel.fromMap(response);
        final products = <ProductModel>[
          ...?homemodel.newproducts,
          ...?homemodel.popularproducts,
          for (final category in homemodel.category ?? <BranchCategory>[])
            ...?category.products,
        ];
        log(
          products
              .map((product) =>
                  'id=${product.id}, remaining_quantity=${product.remaining_quantity}')
              .join(' | '),
          name: 'HomeProductsAvailability branch=$branchId',
        );
        emit(ProductsLoadedSuccess(
          homeModel: homemodel,
          changeTab: changeTabbar,
        ));
      } else {
        emit(ProductsLoadedError());
      }
    }
  }

  void updateProductFavoriteStatus(
      String productId, bool isLiked, String? favouriteId) {
    bool changed = false;
    void updateList(List<ProductModel>? list) {
      if (list == null) return;
      for (var product in list) {
        if (product.id == productId) {
          product.isLiked = isLiked;
          product.favourite_id = favouriteId;
          changed = true;
        }
      }
    }

    updateList(homemodel.popularproducts);
    updateList(homemodel.newproducts);

    if (pagedProducts?.products != null) {
      updateList(pagedProducts!.products);
    }
    if (pagingController?.itemList != null) {
      updateList(pagingController!.itemList);
    }
    if (changed) {
      emit(ProductFavoriteUpdated());
    }
  }

  Future<bool> saveBranchTouser(
      {String? branchId, BuildContext? context}) async {
    emit(SaveBranchLoading());
    final response = await homeRepository.saveBranchtoUser(id: branchId);
    if (response != null) {
      //  currentBranch?.followed = true;
      emit(SaveBranckSuccess(id: branchId ?? ""));

      if (context != null) {
        Navigator.pop(
          // ignore: use_build_context_synchronously
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
      emit(FollowBranchSuccess(id: branchId ?? ""));
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
    request.quantity = "1";
    final response = await productdetailsRepository.addtoCart(
      request: request,
    );
    if (response != null) {
      emit(AddTocartSuccess());
      locator<GeneralCubit>().incrementCartCount(1);
    } else {
      emit(AddTocartFailed());
    }
  }

  /// slider home and bottom baranch
  List<GeneralModel> sliders = [];
  List<GeneralModel> texts = [];

  // Future<List<GeneralModel>?> getHomeSliders() async {
  //   emit(GetHomeSlidersLoading());
  //   final response = await homeRepository.getHomeSliders();
  //   if (response != null) {
  //     sliders = response;
  //     print(sliders.length);
  //     emit(GetHomeSlidersSuccess(sliders: sliders));
  //     return response;
  //   } else {
  //     emit(GetHomeSlidersError());
  //   }
  //   return null;
  // }

  Future<HomeAdsModel?> getHomeAds() async {
    emit(GetHomeSlidersLoading());
    final response = await homeRepository.getHomeAds();
    if (response != null) {
      sliders = response.sliders;
      texts = response.texts;
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
