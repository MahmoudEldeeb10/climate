import 'package:climate/features/home/data/models/daily_forecast_model.dart';

abstract class DaysForecastState {}

class DaysForecastInitial extends DaysForecastState {}

class DaysForecastLoading extends DaysForecastState {}

class DaysForecastSuccess extends DaysForecastState {
  final List<DailyForecastModel> forecasts;
  DaysForecastSuccess(this.forecasts);
}

class DaysForecastFailure extends DaysForecastState {
  final String errMessage;
  DaysForecastFailure(this.errMessage);
}
