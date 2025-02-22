import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:graduation/core/data/models/Car_information.dart';
part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;

  const factory HomeState.loading() = Loading;

  const factory HomeState.success({required List<PostCar> carInformation}) = Success;

  const factory HomeState.error({required String error}) = Error;
}
