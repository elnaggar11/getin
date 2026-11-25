part of 'staticpage_cubit.dart';

sealed class StaticpageState extends Equatable {
  const StaticpageState();

  @override
  List<Object> get props => [];
}

final class StaticpageInitial extends StaticpageState {}

final class GetTermsLoading extends StaticpageState {}

// ignore: must_be_immutable
final class GetTermsSucess extends StaticpageState {
  String? content;

  GetTermsSucess({this.content});
}

final class GetTermsFailed extends StaticpageState {}
