part of 'reported_cars_cubit.dart';

@freezed
class ReportedCarsState with _$ReportedCarsState {
  const factory ReportedCarsState.initial() = _Initial;

  const factory ReportedCarsState.loading() = Loading;

  const factory ReportedCarsState.error(String message) = Error;

  const factory ReportedCarsState.success({required List<PostCar> carInformation}) = Success;

  const factory ReportedCarsState.deleteSuccess() = DeleteSuccess;

  const factory ReportedCarsState.deleteFailure(String message) = DeleteFailure;

  const factory ReportedCarsState.editSuccess() = EditSuccess;

  const factory ReportedCarsState.editFailure(String message) = EditFailure;
}
