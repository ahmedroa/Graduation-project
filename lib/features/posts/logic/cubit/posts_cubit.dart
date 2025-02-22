import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation/core/data/models/Car_information.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PostCar? postCar;

  void createPost({
    required String title,
    required String description,
    required String model,
    required String carLocation,
    required String carYear,
    required String carColor,
    required String image,
  }) {
    emit(PostsLoading());
    try {
      firestore.collection('posts').add({
        'title': title,
        'description': description,
        'image': image,
        'model': model,
        'carLocation': carLocation,
        'carYear': carYear,
        'carColor': carColor,
        'createdAt': DateTime.now(),
      });
    } catch (error) {
      emit(PostsError(error.toString()));
    }
  }
}
