import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation/core/data/models/Car_information.dart';
part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(InitialFavoriteState());

  final uid = FirebaseAuth.instance.currentUser!.uid;

  void getFavoriteCars() async {
    try {
      emit(LoadingFavoriteState());
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).collection('liked_cars').get();
      List<PostCar> likedCars =
          snapshot.docs.map((doc) => PostCar.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      emit(SuccessFavoriteState(likedCars));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
