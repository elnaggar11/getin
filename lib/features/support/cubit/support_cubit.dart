import 'package:getincoffee/core/data_source/dio_helper.dart';
import 'package:getincoffee/core/utils/Locator.dart';
import 'package:getincoffee/features/support/domain/model/support_model.dart';
import 'package:getincoffee/features/support/domain/repository/support_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit() : super(SupportInitial());

  final SupportRepository _repository =
      SupportRepository(locator<DioService>());

  Future<void> getSupport() async {
    emit(SupportLoading());
    try {
      final result = await _repository.getSupport();
      if (result != null) {
        emit(SupportSuccess(supportModel: result));
      } else {
        emit(SupportFailed());
      }
    } catch (e) {
      emit(SupportFailed());
    }
  }
}
