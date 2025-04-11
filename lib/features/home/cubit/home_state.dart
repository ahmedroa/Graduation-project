import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation/core/data/models/Car_information.dart';
// part 'home_state.freezed.dart';

// Home State
class HomeState {
  final bool isLoading;
  final List<PostCar> carInformation;
  final String? error;
  final List<QueryDocumentSnapshot> searchResults;
  final bool isSearching;

  HomeState({
    required this.isLoading,
    required this.carInformation,
    this.error,
    this.searchResults = const [],
    this.isSearching = false,
  });

  factory HomeState.initial() => HomeState(isLoading: false, carInformation: []);

  factory HomeState.loading() => HomeState(isLoading: true, carInformation: []);

  factory HomeState.success({required List<PostCar> carInformation}) =>
      HomeState(isLoading: false, carInformation: carInformation);

  factory HomeState.error({required String error}) => HomeState(isLoading: false, carInformation: [], error: error);

  factory HomeState.searching({
    required bool isSearching,
    List<QueryDocumentSnapshot> searchResults = const [],
    required List<PostCar> carInformation,
  }) => HomeState(
    isLoading: false,
    carInformation: carInformation,
    searchResults: searchResults,
    isSearching: isSearching,
  );

  HomeState copyWith({
    bool? isLoading,
    List<PostCar>? carInformation,
    String? error,
    List<QueryDocumentSnapshot>? searchResults,
    bool? isSearching,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      carInformation: carInformation ?? this.carInformation,
      error: error ?? this.error,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
