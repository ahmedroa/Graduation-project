import 'package:bloc/bloc.dart';
import 'package:graduation/features/profile/cubit/profile_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileStateInitial()) {
    getUserData();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String? phoneNumber;
  String? email;

  Future<void> getUserData() async {
    try {
      emit(ProfileStateLoading());

      // الحصول على المستخدم الحالي
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // الحصول على بيانات المستخدم من Firestore
        final DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          name = userData['name'] ?? '';
          phoneNumber = userData['phone'] ?? '';
          email = userData['email'] ?? currentUser.email ?? '';

          emit(ProfileStateLoaded(name: name!, phoneNumber: phoneNumber!, email: email!));
        } else {
          // إذا لم يكن للمستخدم وثيقة في Firestore، استخدم بيانات المصادقة فقط
          name = currentUser.displayName ?? '';
          phoneNumber = '';
          email = currentUser.email ?? '';

          emit(ProfileStateLoaded(name: name!, phoneNumber: phoneNumber!, email: email!));
        }
      } else {
        emit(ProfileStateError(message: 'لم يتم تسجيل الدخول'));
      }
    } catch (e) {
      emit(ProfileStateError(message: 'حدث خطأ: ${e.toString()}'));
    }
  }
}
