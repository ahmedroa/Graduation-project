part of 'posts_cubit.dart';

@immutable
abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsOptionSelected extends PostsState {
  final int selectedOption;
  PostsOptionSelected(this.selectedOption);
}

class PostsImageUpdated extends PostsState {}
