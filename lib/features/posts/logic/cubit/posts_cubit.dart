import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation/core/data/models/Car_information.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String auth = 'test';
  Future<void> createPost({
    required String name,
    required String description,
    required int year,

    required String carTheftHistory,
    required String image,
    required String location,
    required String phone,
    required String phone2,
    required String tokinNotification,
    required String userId,
    required String createdAt,
    required String locationName,
    required String nameFound,
    required bool what1,
    required bool what2,
    required bool isFound,

    required bool isLocation,
  }) async {
    emit(PostsLoading());
    try {
      String userId = 'test';
      PostCar post = PostCar(
        id: '',
        name: name,
        description: description,
        year: year,
        carTheftHistory: carTheftHistory,
        image: image,
        location: location,
        isLocation: isLocation,
        locationName: locationName,
        nameFound: nameFound,
        phone2: phone2,
        what1: what1,
        what2: what2,
        isFound: isFound,
        phone: phone,
        tokinNotification: tokinNotification,
        userId: userId,
        createdAt: FieldValue.serverTimestamp(),
      );
      DocumentReference postRef = await firestore.collection('posts').add(post.toJson());
      await postRef.update({'id': postRef.id});
      post.id = postRef.id;
      await firestore.collection('users').doc(userId).collection('posts').doc(postRef.id).set(post.toJson());
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  void likePost(String postId) async {
    emit(PostsLoading());
    try {
      await firestore.collection('posts').doc(postId).update({'likes': FieldValue.increment(1)});
      await firestore.collection('users').doc(auth).collection('likes').doc(postId).set({'postId': postId});
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }
}
