part of 'posts_cubit.dart';

class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  // final List<CarModel> carList;
  // PostsLoaded(this.carList);
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);
}
// @freezed
// class PostsState with _$PostsState {
//   const factory PostsState.initial() = _Initial;
// }
