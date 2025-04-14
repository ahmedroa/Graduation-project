part of 'favorite_cubit.dart';

class FavoriteState {}

class InitialFavoriteState extends FavoriteState {}

class LoadingFavoriteState extends FavoriteState {}

class Error extends FavoriteState {
  final String message;
  Error(this.message);
}

class SuccessFavoriteState extends FavoriteState {
  final List<PostCar> carInformation;
  SuccessFavoriteState(this.carInformation);
}
