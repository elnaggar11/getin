part of 'general_cubit.dart';

@immutable
abstract class GeneralState {}

class GeneralInitial extends GeneralState {}

class GeneralChangeAppTheme extends GeneralState {}

class GeneralChangeLocale extends GeneralState {
  final String locale;
  GeneralChangeLocale({required this.locale});
}

class GeneralFavoriteUpdated extends GeneralState {
  final String productId;
  final bool isLiked;
  final String? favouriteId;
  GeneralFavoriteUpdated({
    required this.productId,
    required this.isLiked,
    this.favouriteId,
  });
}

class GeneralCartCountUpdated extends GeneralState {
  final int count;
  GeneralCartCountUpdated({required this.count});
}

class GeneralDeliveryTypeUpdated extends GeneralState {
  final int type;
  GeneralDeliveryTypeUpdated({required this.type});
}


      class GeneralProfileLoadingState extends GeneralState {}
      
      class GeneralProfileSuccessState extends GeneralState {}
      
      class GeneralProfileErrorState extends GeneralState {}
      