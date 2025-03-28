// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// part 'firebase_error_handler.freezed.dart';

// @freezed
// class FirebaseFailure with _$FirebaseFailure {
//   const factory FirebaseFailure.auth({required String code, required String message}) = _AuthFailure;

//   const factory FirebaseFailure.database({required String code, required String message}) = _DatabaseFailure;

//   const factory FirebaseFailure.network({required String message}) = _NetworkFailure;

//   const factory FirebaseFailure.unknown({required String message}) = _UnknownFailure;
// }

// class FirebaseErrorHandler {
//   static FirebaseFailure handleError(dynamic error) {
//     if (error is FirebaseAuthException) {
//       return _handleAuthError(error);
//     } else if (error is FirebaseException) {
//       return _handleDatabaseError(error);
//     } else {
//       return FirebaseFailure.unknown(message: error.toString());
//     }
//   }

//   static FirebaseFailure _handleAuthError(FirebaseAuthException error) {
//     return FirebaseFailure.auth(code: error.code, message: _getAuthErrorMessage(error.code));
//   }

//   static FirebaseFailure _handleDatabaseError(FirebaseException error) {
//     return FirebaseFailure.database(code: error.code, message: _getDatabaseErrorMessage(error.code));
//   }

//   // static String _getAuthErrorMessage(String code) {
//   //   switch (code) {
//   //     case 'email-already-in-use':
//   //       return 'البريد الإلكتروني مستخدم بالفعل';
//   //     case 'invalid-email':
//   //       return 'البريد الإلكتروني غير صالح';
//   //     case 'weak-password':
//   //       return 'كلمة المرور ضعيفة';
//   //     case 'user-disabled':
//   //       return 'تم تعطيل هذا الحساب';
//   //     case 'user-not-found':
//   //       return 'لم يتم العثور على المستخدم';
//   //     case 'wrong-password':
//   //       return 'كلمة المرور غير صحيحة';
//   //     case 'operation-not-allowed':
//   //       return 'العملية غير مسموح بها';
//   //     case 'too-many-requests':
//   //       return 'تم تجاوز عدد المحاولات المسموح بها';
//   //     default:
//   //       return 'حدث خطأ غير متوقع';
//   //   }
//   // }
//   static String _getAuthErrorMessage(String code) {
//     switch (code) {
//       case 'email-already-in-use':
//         return 'البريد الإلكتروني مستخدم بالفعل';
//       case 'invalid-email':
//         return 'البريد الإلكتروني غير صالح';
//       case 'weak-password':
//         return 'كلمة المرور ضعيفة';
//       case 'user-disabled':
//         return 'تم تعطيل هذا الحساب';
//       case 'user-not-found':
//         return 'لم يتم العثور على المستخدم';
//       case 'wrong-password':
//         return 'كلمة المرور غير صحيحة';
//       case 'operation-not-allowed':
//         return 'العملية غير مسموح بها';
//       case 'too-many-requests':
//         return 'تم تجاوز عدد المحاولات المسموح بها';
//       case 'invalid-credential': // ✅ أضف هذا السطر
//         return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
//       default:
//         return 'حدث خطأ غير متوقع';
//     }
//   }

//   static String _getDatabaseErrorMessage(String code) {
//     switch (code) {
//       case 'permission-denied':
//         return 'ليس لديك صلاحية للوصول';
//       case 'unavailable':
//         return 'الخدمة غير متوفرة حالياً';
//       case 'cancelled':
//         return 'تم إلغاء العملية';
//       case 'data-loss':
//         return 'حدث خطأ في البيانات';
//       default:
//         return 'حدث خطأ غير متوقع';
//     }
//   }
// }

// // مثال على الاستخدام
// extension FirebaseFailureX on FirebaseFailure {
//   String getMessage() {
//     return when(
//       auth: (code, message) => message,
//       database: (code, message) => message,
//       network: (message) => message,
//       unknown: (message) => message,
//     );
//   }
// }
