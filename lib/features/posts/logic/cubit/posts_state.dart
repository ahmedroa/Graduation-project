part of 'posts_cubit.dart';

class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

// class CarInfoCleared extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostCar> carList;
  PostsLoaded(this.carList);
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);
}



class PostsSelectedOption extends PostsState {}

class CarImagesUpdated extends PostsState {}

class PostsCreated extends PostsState {
  final PostCar post;
  PostsCreated(this.post);
}


class LocationFetched extends PostsState {}

class LocationError extends PostsState {
  final String message;
  LocationError(this.message);
}

class LocationLoading extends PostsState {} 
