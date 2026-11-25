import 'package:getincoffee/features/home/domain/model/home_model.dart';
import 'package:getincoffee/features/productdetails/domain/request/productdetails_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/Locator.dart';
import '../../../core/general/cubit/general_cubit.dart';
import '../domain/repository/repository.dart';
import 'productdetails_states.dart';

class ProductdetailsCubit extends Cubit<ProductdetailsStates> {
  ProductdetailsCubit() : super(ProductdetailsInitial());
  static ProductdetailsCubit get(context) => BlocProvider.of(context);

  ProductdetailsRepository productdetailsRepository =
      locator<ProductdetailsRepository>();

  ProductModel productdetails = ProductModel();
  addProperties(String index, List<ValueOptionModel> fnew) {
    emit(StartChangeProperites());
    properties[index] = fnew;
    emit(EndChangeProperites());
  }

  getProductDetails(
      {String? id, String? branchId, bool isloading = true}) async {
    if (isloading == true) emit(ProductdetailsLoading());
    final response = await productdetailsRepository.getProductDetails(
      id: id,
      branchId: branchId,
    );
    if (response != null) {
      productdetails = ProductModel.fromMap(response);
      for (int i = 0; i < (productdetails.options?.length ?? 0); i++) {
        var option = productdetails.options?[i];
        var values = option?.values;
        if (option?.type == OptionType.multipleChoice) {
          properties[(option?.id ?? '')] = [];
        } else {
          properties[(option?.id ?? '')] =
              (values != null && values.isNotEmpty) ? [values.first] : [];
        }
      }

      emit(ProductdetailsSuccess(productdetails));
    } else {
      emit(ProductdetailsFailure());
    }
  }

  num get extraPrice {
    return properties.values
        .expand((e) => e)
        .map((e) => num.tryParse(e.extraPrice ?? "0") ?? 0)
        .fold(0, (a, b) => a + b);
  }

  AddtoCartRequest request = AddtoCartRequest();
  Map<String, List<ValueOptionModel>> properties = {};
  addtoCart() async {
    emit(AddTocartLoading());
    final response = await productdetailsRepository.addtoCart(
      request: request
        ..optionValueIds = properties.values
            .expand((e) => e)
            .map((e) => e.id.toString())
            .toList(),
    );
    if (response != null) {
      locator<GeneralCubit>()
          .incrementCartCount(int.tryParse(request.quantity ?? "1") ?? 1);
      emit(AddTocartSuccess());
    } else {
      emit(AddTocartFailed());
    }
  }

  likeDislike() async {
    emit(LikeLoadingState());
    final response = await productdetailsRepository.likeanDislike();
    if (response != null) {
      emit(LikeSuccessState());
    } else {
      emit(LikeErrorState());
    }
  }
}
