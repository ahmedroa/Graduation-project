part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = _Initial;

  const factory SettingsState.loading() = Loading;

  const factory SettingsState.error(String message) = Error;

  const factory SettingsState.success() = Success;

  // Logout :
  const factory SettingsState.loggingOut() = LoggingOut;
  const factory SettingsState.logoutSuccess() = LogoutSuccess;
  const factory SettingsState.logoutFailure(String message) = LogoutFailure;
  
  // Delete Account :
  const factory SettingsState.deleteAccount() = DeleteAccount;
  const factory SettingsState.deleteAccountSuccess() = DeleteAccountSuccess;
  const factory SettingsState.deleteAccountFailure(String message) = DeleteAccountFailure;

}
// Reported Cars