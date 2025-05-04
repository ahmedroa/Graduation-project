part of 'posts_cubit.dart';

class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

// class CarInfoCleared extends PostsState {}

// class PostsSuccess extends PostsState {
//   final List<PostCar> carList;
//   PostsSuccess(this.carList);
// }

class PostsSendSuccess extends PostsState {}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);
}

class PostsSelectedOption extends PostsState {}

class CarImagesUpdated extends PostsState {}

// class PostsCrdeated extends PostsState {
//   final PostCar post;
//   PostsCreated(this.post);
// }

class LocationFetched extends PostsState {}

class LocationError extends PostsState {
  final String message;
  LocationError(this.message);
}

// class LocationLoading extends PostsState {}

class TagUpdated extends PostsState {}

// حالة رفع الصور
class UploadingImages extends PostsState {
  final int progress;
  UploadingImages(this.progress);
}

class PageValidationError extends PostsState {
  final String message;
  PageValidationError(this.message);
}
