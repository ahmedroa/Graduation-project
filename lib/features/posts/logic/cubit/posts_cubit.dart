import 'package:bloc/bloc.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());
  // FirebaseFirestore firestore = FirebaseFirestore.instance;

  // CarModel? carModel;
  // void createPost({
  //   required String title,
  //   required String description,
  //   required String model,
  //   required String carLocation,
  //   required String carYear,
  //   required String carColor,
  //   required String image,
  // }) {
  //   emit(PostsLoading());
  //   try {
  //     firestore.collection('posts').add({
  //       'title': title,
  //       'description': description,
  //       'image': image,
  //       'model': model,
  //       'carLocation': carLocation,
  //       'carYear': carYear,
  //       'carColor': carColor,
  //       'createdAt': DateTime.now(),
  //     });
  //   } catch (e) {
  //     emit(PostsError(e.toString()));
  //   }
  // }

  // void getPosts() async {
  //   emit(PostsLoading());
  //   try {
  //     QuerySnapshot querySnapshot = await firestore.collection('posts').get();
  //     List<CarModel> carList = querySnapshot.docs.map((doc) {
  //       return CarModel.fromJson(doc.data() as Map<String, dynamic>);
  //     }).toList();
  //     emit(PostsLoaded(carList));
  //   } catch (e) {
  //     emit(PostsError(e.toString()));
  //   }
  // }
}
