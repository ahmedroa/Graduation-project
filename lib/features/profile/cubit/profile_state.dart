abstract class ProfileState {}

class ProfileStateInitial extends ProfileState {}

class ProfileStateLoading extends ProfileState {}

class ProfileStateLoaded extends ProfileState {
  final String name;
  final String phoneNumber;
  final String email;

  ProfileStateLoaded({
    required this.name,
    required this.phoneNumber,
    required this.email,
  });
}

class ProfileStateError extends ProfileState {
  final String message;

  ProfileStateError({required this.message});
}