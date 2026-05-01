class DailyForecastModel {
  final String date;
  final String day;
  final double temp;

  const DailyForecastModel({
    required this.date,
    required this.day,
    required this.temp,
  });

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) {
    return DailyForecastModel(
      date: json['date'],
      day: json['day'],
      temp: (json['temp'] as num).toDouble(),
    );
  }
}