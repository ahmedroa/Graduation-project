import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation/core/data/models/Car_information.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit() : super(DetailsState());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<bool> checkIfCarLiked(String? carId) async {
    if (carId == null) return false;
    final userId = getCurrentUserId();
    if (userId == null) {
      return false;
    }
    try {
      emit(state.copyWith(isLikeLoading: true));
      final docSnapshot = await firestore.collection('users').doc(userId).collection('liked_cars').doc(carId).get();
      final isLiked = docSnapshot.exists;
      emit(state.copyWith(isLikeLoading: false, isLiked: isLiked));
      return isLiked;
    } catch (e) {
      print('Error checking like status: $e');
      emit(state.copyWith(isLikeLoading: false, error: e.toString()));
      return false;
    }
  }

  Future<bool> toggleLike(PostCar car) async {
    if (car.id == null) return false;
    final userId = getCurrentUserId();
    if (userId == null) {
      return false;
    }
    try {
      final isCurrentlyLiked = await checkIfCarLiked(car.id);
      emit(state.copyWith(isLikeLoading: true));
      final userLikesRef = firestore.collection('users').doc(userId).collection('liked_cars');
      if (isCurrentlyLiked) {
        await userLikesRef.doc(car.id).delete();
      } else {
        await userLikesRef.doc(car.id).set(car.toMap());
      }
      final carRef = firestore.collection('cars').doc(car.id);
      await firestore.runTransaction((transaction) async {
        final carDoc = await transaction.get(carRef);
        if (carDoc.exists) {
          int currentLikes = carDoc.data()?['likesCount'] ?? 0;
          transaction.update(carRef, {'likesCount': isCurrentlyLiked ? currentLikes - 1 : currentLikes + 1});
        }
      });
      emit(state.copyWith(isLikeLoading: false, isLiked: !isCurrentlyLiked));
      return true;
    } catch (e) {
      print('Error toggling like: $e');
      emit(state.copyWith(isLikeLoading: false, error: e.toString()));
      return false;
    }
  }

  
  Future<void> getLastThreeComments(String carId) async {
    try {
      emit(state.copyWith(isCommentsLoading: true));
      final commentsSnapshot =
          await firestore
              .collection('posts')
              .doc(carId)
              .collection('comments')
              .orderBy('timestamp', descending: true)
              .limit(3)
              .get();

      final comments =
          commentsSnapshot.docs.map((doc) {
            final data = doc.data();
            return Comment.fromMap(data, doc.id);
          }).toList();

      emit(state.copyWith(isCommentsLoading: false, lastThreeComments: comments));
    } catch (e) {
      print('Error getting last three comments: $e');
      emit(state.copyWith(isCommentsLoading: false, error: e.toString()));
    }
  }

  Future<bool> addComment(String carId, String commentText) async {
    final userId = getCurrentUserId();
    if (userId == null || commentText.trim().isEmpty) return false;

    try {
      emit(state.copyWith(isAddingComment: true));

      final userDoc = await firestore.collection('users').doc(userId).get();
      final userName = userDoc.data()?['name'] ?? 'مستخدم';
      final userProfileImage = userDoc.data()?['profileImage'];

      await firestore.collection('posts').doc(carId).collection('comments').add({
        'userId': userId,
        'userName': userName,
        'userProfileImage': userProfileImage,
        'comment': commentText.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      await firestore.collection('posts').doc(carId).update({'commentsCount': FieldValue.increment(1)});

      emit(state.copyWith(isAddingComment: false));

      await getLastThreeComments(carId);

      return true;
    } catch (e) {
      print('Error adding comment: $e');
      emit(state.copyWith(isAddingComment: false, error: e.toString()));
      return false;
    }
  }

  Future<void> getAllComments(String carId) async {
    try {
      emit(state.copyWith(isCommentsLoading: true));
      final commentsSnapshot =
          await firestore
              .collection('posts')
              .doc(carId)
              .collection('comments')
              .orderBy('timestamp', descending: true)
              .get();

      final comments =
          commentsSnapshot.docs.map((doc) {
            final data = doc.data();
            return Comment.fromMap(data, doc.id);
          }).toList();

      emit(state.copyWith(isCommentsLoading: false, allComments: comments));
    } catch (e) {
      print('Error getting all comments: $e');
      emit(state.copyWith(isCommentsLoading: false, error: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}