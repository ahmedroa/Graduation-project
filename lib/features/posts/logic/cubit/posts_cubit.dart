import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation/core/data/models/Car_information.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(PostsInitial());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PostCar? postCar;

  createPost(
    //   {
    //   required String name,
    //   required String description,
    //   required int year,
    //   required int carTheftHistory,
    //   required String image,
    //   required String location,
    //   required bool isLocation,
    //   required String locationName,
    //   required String nameFound,
    //   required String phone,
    //   required String phone2,
    //   required bool what1,
    //   required bool what2,
    //   required String tokinNotification,
    // }
  ) {
    emit(PostsLoading());
    try {
      firestore
          .collection('posts')
          .add({
            'id': '',
            'name': 'جلي امجراند',
            'description': 'سرقت من المعموره اخر محطه بجوار مسجد السيدة زينب',
            'year': 2023,
            'carTheftHistory': '2024',
            'image':
                'https://firebasestorage.googleapis.com/v0/b/graduation-1e7b6.appspot.com/o/1.jpg?alt=media&token=3b3b3b3b-3b3b-3b3b-3b3b-3b3b3b3b3b3b',
            'location': 'https://maps.app.goo.gl/T811JhKnSEK5qRfi7',
            'isLocation': true,
            'locationName': 'المعموره',
            'nameFound': 'ahned khalid',
            'phone': '+966548828730',
            "phone2": '+966548828730',
            'what1': false,
            'what2': false,
            'isFound': false,
            'tokinNotification': '',
          })
          .then((value) {
            FirebaseFirestore.instance.collection('posts').doc(value.id).update({'id': value.id});
          }); // emit(PostsSuccess());
    } catch (e) {
      // emit(PostsError(e.toString()));
    }
  }
}
