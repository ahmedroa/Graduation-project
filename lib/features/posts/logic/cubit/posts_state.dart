part of 'posts_cubit.dart';

class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostCar> carList;
  PostsLoaded(this.carList);
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);
}
