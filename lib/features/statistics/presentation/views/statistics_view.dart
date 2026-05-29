import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/features/home/data/models/weather_model.dart';
import 'package:climate/features/home/presentation/manager/weather_cubit.dart';
import 'package:climate/features/home/presentation/manager/weather_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit()..getWeather(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Weather Stats', style: Styles.textStyle22),
        ),
        body: SafeArea(
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (state is WeatherFailure) {
                return Center(
                  child: Text(
                    state.errMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              if (state is WeatherSuccess) {
                return _StatsBody(weather: state.weather);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  final WeatherModel weather;

  const _StatsBody({required this.weather});

  @override
  Widget build(BuildContext context) {
    final hourly = weather.hourly;
    final daily = weather.daily.take(5).toList();

    final avgTemp =
        hourly.map((h) => h.temperature).reduce((a, b) => a + b) /
        hourly.length;
    final maxTemp = hourly
        .map((h) => h.temperature)
        .reduce((a, b) => a > b ? a : b);
    final minTemp = hourly
        .map((h) => h.temperature)
        .reduce((a, b) => a < b ? a : b);
    final avgHum =
        hourly.map((h) => h.humidity).reduce((a, b) => a + b) / hourly.length;
    final peakUv = hourly.map((h) => h.uvIndex).reduce((a, b) => a > b ? a : b);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Metric Cards ──────────────────────────────────────
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
            children: [
              _MetricCard(
                label: 'Avg Temp',
                value: '${avgTemp.round()}°',
                icon: Icons.thermostat,
                color: Colors.orangeAccent,
              ),
              _MetricCard(
                label: 'Max Temp',
                value: '${maxTemp.round()}°',
                icon: Icons.arrow_upward,
                color: Colors.redAccent,
              ),
              _MetricCard(
                label: 'Min Temp',
                value: '${minTemp.round()}°',
                icon: Icons.arrow_downward,
                color: Colors.lightBlueAccent,
              ),
              _MetricCard(
                label: 'Humidity',
                value: '${avgHum.round()}%',
                icon: Icons.water_drop,
                color: Colors.tealAccent,
              ),
              _MetricCard(
                label: 'Wind',
                value: '${weather.currentWindSpeed.round()} km/h',
                icon: Icons.air,
                color: Colors.white70,
              ),
              _MetricCard(
                label: 'Peak UV',
                value: peakUv.toStringAsFixed(1),
                icon: Icons.wb_sunny,
                color: Colors.amberAccent,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Temperature Line Chart ────────────────────────────
          _ChartCard(
            title: 'Temperature (°C) — next 8 hours',
            child: SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: Colors.white12, strokeWidth: 0.5),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (v, _) => Text(
                          '${v.round()}°',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= hourly.length) {
                            return const SizedBox();
                          }
                          return Text(
                            hourly[idx].formattedTime,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: hourly
                          .asMap()
                          .entries
                          .map(
                            (e) =>
                                FlSpot(e.key.toDouble(), e.value.temperature),
                          )
                          .toList(),
                      isCurved: true,
                      color: Colors.lightBlueAccent,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                          radius: 3,
                          color: Colors.lightBlueAccent,
                          strokeWidth: 0,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.lightBlueAccent.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Humidity Line Chart ───────────────────────────────
          _ChartCard(
            title: 'Humidity (%) — next 8 hours',
            child: SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: Colors.white12, strokeWidth: 0.5),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) => Text(
                          '${v.round()}%',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= hourly.length) {
                            return const SizedBox();
                          }
                          return Text(
                            hourly[idx].formattedTime,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: hourly
                          .asMap()
                          .entries
                          .map(
                            (e) => FlSpot(e.key.toDouble(), e.value.humidity),
                          )
                          .toList(),
                      isCurved: true,
                      color: Colors.tealAccent,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                          radius: 3,
                          color: Colors.tealAccent,
                          strokeWidth: 0,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.tealAccent.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── UV Index Bar Chart ────────────────────────────────
          _ChartCard(
            title: 'UV Index — next 8 hours',
            child: SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: Colors.white12, strokeWidth: 0.5),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (v, _) => Text(
                          v.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= hourly.length) {
                            return const SizedBox();
                          }
                          return Text(
                            hourly[idx].formattedTime,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: hourly.asMap().entries.map((e) {
                    final uv = e.value.uvIndex;
                    final color = uv <= 2
                        ? Colors.green
                        : uv <= 5
                        ? Colors.yellow
                        : uv <= 7
                        ? Colors.orange
                        : Colors.red;
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: uv,
                          color: color,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Wind Speed Bar Chart ──────────────────────────────
          _ChartCard(
            title: 'Wind Speed (km/h) — next 8 hours',
            child: SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: Colors.white12, strokeWidth: 0.5),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (v, _) => Text(
                          '${v.round()}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= hourly.length) {
                            return const SizedBox();
                          }
                          return Text(
                            hourly[idx].formattedTime,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: hourly.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.windSpeed,
                          color: AppColors.secondaryText,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Sunrise / Sunset ──────────────────────────────────
          _ChartCard(
            title: 'Sunrise & Sunset — next 5 days',
            child: Column(
              children: daily.map((d) {
                final sunrise = _parseTime(d.sunrise);
                final sunset = _parseTime(d.sunset);
                final daylightHours = sunset != null && sunrise != null
                    ? sunset.difference(sunrise).inMinutes / 60.0
                    : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 36,
                        child: Text(
                          d.dayName.substring(0, 3),
                          style: Styles.textStyle14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.wb_twilight,
                        color: Colors.orangeAccent,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(d.sunrise),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: daylightHours / 24,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.amberAccent,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.nights_stay,
                        color: Colors.blueAccent,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(d.sunset),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // ── Wind Compass ──────────────────────────────────────
          _ChartCard(
            title: 'Wind Direction',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WindCompass(direction: weather.currentWindDirection),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.currentWindDirection.round()}°',
                      style: Styles.textStyle30,
                    ),
                    Text(
                      _dirLabel(weather.currentWindDirection),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${weather.currentWindSpeed.round()} km/h',
                      style: Styles.textStyle22,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _parseTime(String iso) {
    try {
      return DateTime.parse(iso);
    } catch (_) {
      return null;
    }
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final suffix = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $suffix';
    } catch (_) {
      return iso;
    }
  }

  String _dirLabel(double deg) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    return dirs[(deg / 45).round() % 8];
  }
}

// ── Reusable Widgets ────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _WindCompass extends StatelessWidget {
  final double direction;

  const _WindCompass({required this.direction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: CustomPaint(painter: _CompassPainter(direction: direction)),
    );
  }
}

class _CompassPainter extends CustomPainter {
  final double direction;

  _CompassPainter({required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 4;

    final circlePaint = Paint()
      ..color = AppColors.cardBackgroundColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), r, circlePaint);

    final borderPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(Offset(cx, cy), r, borderPaint);

    const labels = ['N', 'E', 'S', 'W'];
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2 - math.pi / 2;
      final tx = cx + (r - 14) * math.cos(angle);
      final ty = cy + (r - 14) * math.sin(angle);
      tp.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: Colors.white60, fontSize: 11),
      );
      tp.layout();
      tp.paint(canvas, Offset(tx - tp.width / 2, ty - tp.height / 2));
    }

    final needleAngle = (direction - 90) * math.pi / 180;
    final needlePaint = Paint()
      ..color = Colors.lightBlueAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - 10 * math.cos(needleAngle), cy - 10 * math.sin(needleAngle)),
      Offset(
        cx + (r - 24) * math.cos(needleAngle),
        cy + (r - 24) * math.sin(needleAngle),
      ),
      needlePaint,
    );

    canvas.drawCircle(
      Offset(cx, cy),
      5,
      Paint()..color = Colors.lightBlueAccent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
