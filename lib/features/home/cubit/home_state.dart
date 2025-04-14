import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation/core/data/models/Car_information.dart';

// part 'home_state.freezed.dart';

class HomeState {
  final bool isLoading;
  final bool isLikeLoading;
  final List<PostCar> carInformation;
  final List<PostCar> likedCars;
  final bool isSearching;
  final List<QueryDocumentSnapshot> searchResults;
  final String? error;
  final bool isUserLoggedIn;

  HomeState({
    required this.isLoading,
    required this.isLikeLoading,
    required this.carInformation,
    required this.likedCars,
    required this.isSearching,
    required this.searchResults,
    required this.isUserLoggedIn,
    this.error,
  });

  factory HomeState.initial() {
    return HomeState(
      isLoading: false,
      isLikeLoading: false,
      carInformation: [],
      likedCars: [],
      isSearching: false,
      searchResults: [],
      isUserLoggedIn: FirebaseAuth.instance.currentUser != null,
      error: null,
    );
  }

  factory HomeState.loading() {
    return HomeState(
      isLoading: true,
      isLikeLoading: false,
      carInformation: [],
      likedCars: [],
      isSearching: false,
      searchResults: [],
      isUserLoggedIn: FirebaseAuth.instance.currentUser != null,
      error: null,
    );
  }

  factory HomeState.success({required List<PostCar> carInformation}) {
    return HomeState(
      isLoading: false,
      isLikeLoading: false,
      carInformation: carInformation,
      likedCars: [],
      isSearching: false,
      searchResults: [],
      isUserLoggedIn: FirebaseAuth.instance.currentUser != null,
      error: null,
    );
  }

  factory HomeState.error({required String error}) {
    return HomeState(
      isLoading: false,
      isLikeLoading: false,
      carInformation: [],
      likedCars: [],
      isSearching: false,
      searchResults: [],
      isUserLoggedIn: FirebaseAuth.instance.currentUser != null,
      error: error,
    );
  }

  HomeState copyWith({
    bool? isLoading,
    bool? isLikeLoading,
    List<PostCar>? carInformation,
    List<PostCar>? likedCars,
    bool? isSearching,
    List<QueryDocumentSnapshot>? searchResults,
    bool? isUserLoggedIn,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isLikeLoading: isLikeLoading ?? this.isLikeLoading,
      carInformation: carInformation ?? this.carInformation,
      likedCars: likedCars ?? this.likedCars,
      isSearching: isSearching ?? this.isSearching,
      searchResults: searchResults ?? this.searchResults,
      isUserLoggedIn: isUserLoggedIn ?? this.isUserLoggedIn,
      error: error ?? this.error,
    );
  }
}
// class HomeState {
//   final bool isLoading;
//   final bool isLikeLoading;
//   final List<PostCar> carInformation;
//   final List<PostCar> likedCars;
//   final bool isSearching;
//   final List<QueryDocumentSnapshot> searchResults;
//   final String? error;

//   HomeState({
//     required this.isLoading,
//     required this.isLikeLoading,
//     required this.carInformation,
//     required this.likedCars,
//     required this.isSearching,
//     required this.searchResults,
//     this.error,
//   });

//   factory HomeState.initial() {
//     return HomeState(
//       isLoading: false,
//       isLikeLoading: false,
//       carInformation: [],
//       likedCars: [],
//       isSearching: false,
//       searchResults: [],
//       error: null,
//     );
//   }

//   factory HomeState.loading() {
//     return HomeState(
//       isLoading: true,
//       isLikeLoading: false,
//       carInformation: [],
//       likedCars: [],
//       isSearching: false,
//       searchResults: [],
//       error: null,
//     );
//   }

//   factory HomeState.success({required List<PostCar> carInformation}) {
//     return HomeState(
//       isLoading: false,
//       isLikeLoading: false,
//       carInformation: carInformation,
//       likedCars: [],
//       isSearching: false,
//       searchResults: [],
//       error: null,
//     );
//   }

//   factory HomeState.error({required String error}) {
//     return HomeState(
//       isLoading: false,
//       isLikeLoading: false,
//       carInformation: [],
//       likedCars: [],
//       isSearching: false,
//       searchResults: [],
//       error: error,
//     );
//   }

//   HomeState copyWith({
//     bool? isLoading,
//     bool? isLikeLoading,
//     List<PostCar>? carInformation,
//     List<PostCar>? likedCars,
//     bool? isSearching,
//     List<QueryDocumentSnapshot>? searchResults,
//     String? error,
//   }) {
//     return HomeState(
//       isLoading: isLoading ?? this.isLoading,
//       isLikeLoading: isLikeLoading ?? this.isLikeLoading,
//       carInformation: carInformation ?? this.carInformation,
//       likedCars: likedCars ?? this.likedCars,
//       isSearching: isSearching ?? this.isSearching,
//       searchResults: searchResults ?? this.searchResults,
//       error: error ?? this.error,
//     );
//   }
// }


// // Home State
// class HomeState {
//   final bool isLoading;
//   final List<PostCar> carInformation;
//   final String? error;
//   final List<QueryDocumentSnapshot> searchResults;
//   final bool isSearching;

//   HomeState({
//     required this.isLoading,
//     required this.carInformation,
//     this.error,
//     this.searchResults = const [],
//     this.isSearching = false,
//   });

//   factory HomeState.initial() => HomeState(isLoading: false, carInformation: []);

//   factory HomeState.loading() => HomeState(isLoading: true, carInformation: []);

//   factory HomeState.success({required List<PostCar> carInformation}) =>
//       HomeState(isLoading: false, carInformation: carInformation);

//   factory HomeState.error({required String error}) => HomeState(isLoading: false, carInformation: [], error: error);

//   factory HomeState.searching({
//     required bool isSearching,
//     List<QueryDocumentSnapshot> searchResults = const [],
//     required List<PostCar> carInformation,
//   }) => HomeState(
//     isLoading: false,
//     carInformation: carInformation,
//     searchResults: searchResults,
//     isSearching: isSearching,
//   );

//   HomeState copyWith({
//     bool? isLoading,
//     List<PostCar>? carInformation,
//     String? error,
//     List<QueryDocumentSnapshot>? searchResults,
//     bool? isSearching,
//   }) {
//     return HomeState(
//       isLoading: isLoading ?? this.isLoading,
//       carInformation: carInformation ?? this.carInformation,
//       error: error ?? this.error,
//       searchResults: searchResults ?? this.searchResults,
//       isSearching: isSearching ?? this.isSearching,
//     );
//   }
// }
