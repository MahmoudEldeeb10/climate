class WeatherModel {
  final double currentWindSpeed;
  final double currentWindDirection;

  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherModel({
    required this.currentWindSpeed,
    required this.currentWindDirection,
    required this.hourly,
    required this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final hourlyJson = json['hourly'] as Map<String, dynamic>;
    final dailyJson = json['daily'] as Map<String, dynamic>;

    // Hourly — take next 8 hours only
    final times = List<String>.from(hourlyJson['time']);
    final temps = List<double>.from(
      (hourlyJson['temperature_2m'] as List).map((e) => (e as num).toDouble()),
    );
    final windSpeeds = List<double>.from(
      (hourlyJson['wind_speed_10m'] as List).map((e) => (e as num).toDouble()),
    );
    final uvIndexes = List<double>.from(
      (hourlyJson['uv_index'] as List).map((e) => (e as num).toDouble()),
    );
    final humidities = List<double>.from(
      (hourlyJson['relative_humidity_2m'] as List)
          .map((e) => (e as num).toDouble()),
    );

    // Find current hour index
    final now = DateTime.now();
    int startIndex = times.indexWhere((t) {
      final dt = DateTime.parse(t);
      return dt.hour == now.hour && dt.day == now.day;
    });
    if (startIndex == -1) startIndex = 0;

    final hourlyList = List.generate(8, (i) {
      final idx = startIndex + i;
      return HourlyWeather(
        time: times[idx],
        temperature: temps[idx],
        windSpeed: windSpeeds[idx],
        uvIndex: uvIndexes[idx],
        humidity: humidities[idx],
      );
    });

    // Daily
    final dailyTimes = List<String>.from(dailyJson['time']);
    final sunrises = List<String>.from(dailyJson['sunrise']);
    final sunsets = List<String>.from(dailyJson['sunset']);

    final dailyList = List.generate(dailyTimes.length, (i) {
      return DailyWeather(
        date: dailyTimes[i],
        sunrise: sunrises[i],
        sunset: sunsets[i],
      );
    });

    return WeatherModel(
      currentWindSpeed: (current['wind_speed_10m'] as num).toDouble(),
      currentWindDirection: (current['wind_direction_10m'] as num).toDouble(),
      hourly: hourlyList,
      daily: dailyList,
    );
  }
}

class HourlyWeather {
  final String time;
  final double temperature;
  final double windSpeed;
  final double uvIndex;
  final double humidity;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.windSpeed,
    required this.uvIndex,
    required this.humidity,
  });

  /// Returns "Now", "1 PM", "2 PM", etc.
  String get formattedTime {
    final dt = DateTime.parse(time);
    final now = DateTime.now();
    if (dt.hour == now.hour && dt.day == now.day) return 'Now';
    final hour = dt.hour;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour $suffix';
  }

  String get uvLabel {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }
}

class DailyWeather {
  final String date;
  final String sunrise;
  final String sunset;

  DailyWeather({
    required this.date,
    required this.sunrise,
    required this.sunset,
  });

  /// Returns "Monday", "Tuesday", etc.
  String get dayName {
    final dt = DateTime.parse(date);
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dt.weekday - 1];
  }
}
