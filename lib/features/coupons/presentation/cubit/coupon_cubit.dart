import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getincoffee/core/utils/locator.dart';
import 'package:getincoffee/features/coupons/domain/repository/coupon_repository.dart';
import 'package:getincoffee/features/coupons/presentation/cubit/coupon_states.dart';
import 'package:getincoffee/core/data_source/dio_helper.dart';
import 'package:getincoffee/features/coupons/domain/model/coupon_model.dart';

class CouponCubit extends Cubit<CouponState> {
  CouponCubit() : super(CouponInitial()) {
    _couponRepository = CouponRepository(locator<DioService>());
  }

  late final CouponRepository _couponRepository;
  List<CouponModel> coupons = [];

  static CouponCubit get(context) => BlocProvider.of(context);

  Future<void> getCoupons() async {
    emit(CouponLoading());
    try {
      final response = await _couponRepository.getCoupons();
      if (response != null) {
        coupons = response;
        emit(CouponLoaded(response));
      } else {
        emit(const CouponError('Failed to load coupons'));
      }
    } catch (e) {
      emit(CouponError(e.toString()));
    }
  }

  void applyCoupon(String code) {
    // You can implement coupon application logic here
    // This is a placeholder for the actual implementation
    try {
      final coupon = coupons.firstWhere(
        (coupon) => coupon.code?.toLowerCase() == code.toLowerCase(),
      );
      // Valid coupon
      emit(CouponApplied(coupon));
    } catch (e) {
      emit(const CouponError('Invalid coupon code'));
    }
  }
}

class CouponApplied extends CouponState {
  final CouponModel coupon;

  const CouponApplied(this.coupon);

  @override
  List<Object> get props => [coupon];
}
