import 'package:getincoffee/core/data_source/dio_helper.dart';
import 'package:getincoffee/core/utils/locator.dart';
import 'package:getincoffee/features/static_pages/domain/repositories/pages_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'staticpage_state.dart';

class StaticpageCubit extends Cubit<StaticpageState> {
  StaticpageCubit() : super(StaticpageInitial());

  StaticRepositories staticRepositories =
      StaticRepositories(locator<DioService>());

  Future<void> getTermsScreen() async {
    emit(GetTermsLoading());
    try {
      var response = await staticRepositories.gettermspage();
      emit(GetTermsSucess(content: response["content"]));
    } catch (e) {
      emit(GetTermsFailed());
    }
  }
}
