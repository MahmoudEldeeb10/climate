import 'dart:convert';
import 'package:climate/features/home/presentation/manager/weather_cubit.dart';
import 'package:climate/features/home/presentation/manager/weather_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:climate/features/home/data/models/weather_model.dart';

import '../../../../constants.dart';

// ─── Models ───────────────────────────────────────────────────────────────────
enum _Status { good, warn, bad }

class _Check {
  final IconData icon;
  final String label;
  final String value;
  final _Status status;
  const _Check(this.icon, this.label, this.value, this.status);
}

class _Metric {
  final String label, value, unit;
  const _Metric(this.label, this.value, this.unit);
}

class _Prof {
  final String key, name, hint;
  final IconData icon;
  final List<_Metric> Function(WeatherModel w) metricsOf;
  final List<_Check> Function(WeatherModel w) checksOf;
  final String Function(WeatherModel w) promptOf;
  const _Prof({
    required this.key,
    required this.name,
    required this.hint,
    required this.icon,
    required this.metricsOf,
    required this.checksOf,
    required this.promptOf,
  });
}

// ─── Wind direction helper ────────────────────────────────────────────────────
String _windDir(double deg) {
  const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  return dirs[((deg + 22.5) / 45).floor() % 8];
}

String _uvLabel(double uv) {
  if (uv <= 2) return 'Low';
  if (uv <= 5) return 'Moderate';
  if (uv <= 7) return 'High';
  if (uv <= 10) return 'Very High';
  return 'Extreme';
}

_Status _uvStatus(double uv) {
  if (uv <= 2) return _Status.good;
  if (uv <= 5) return _Status.warn;
  return _Status.bad;
}

_Status _windStatus(double kmh) {
  if (kmh < 20) return _Status.good;
  if (kmh < 40) return _Status.warn;
  return _Status.bad;
}

_Status _humidityStatus(double h) {
  if (h < 70) return _Status.good;
  if (h < 85) return _Status.warn;
  return _Status.bad;
}

// ─── Profession definitions (data comes from WeatherModel) ───────────────────
final _profs = <_Prof>[
  _Prof(
    key: 'sailor',
    name: 'Sailor',
    hint: 'Marine & coastal',
    icon: CupertinoIcons.helm,
    metricsOf: (w) => [
      _Metric(
        'Wind',
        '${w.currentWindSpeed.toStringAsFixed(1)}',
        'km/h ${_windDir(w.currentWindDirection)}',
      ),
      _Metric('Humidity', '${w.hourly.first.humidity.toStringAsFixed(0)}', '%'),
      _Metric(
        'UV index',
        '${w.hourly.first.uvIndex.toStringAsFixed(1)}',
        _uvLabel(w.hourly.first.uvIndex),
      ),
    ],
    checksOf: (w) {
      final ws = w.currentWindSpeed;
      final uv = w.hourly.first.uvIndex;
      return [
        _Check(
          CupertinoIcons.wind,
          'Wind speed',
          '${ws.toStringAsFixed(1)} km/h ${_windDir(w.currentWindDirection)}',
          _windStatus(ws),
        ),
        _Check(
          CupertinoIcons.eye,
          'Visibility',
          ws < 30 ? 'Good' : 'Reduced by wind',
          ws < 30 ? _Status.good : _Status.warn,
        ),
        _Check(
          CupertinoIcons.drop,
          'Humidity',
          '${w.hourly.first.humidity.toStringAsFixed(0)}%',
          _humidityStatus(w.hourly.first.humidity),
        ),
        _Check(CupertinoIcons.sun_max, 'UV index', _uvLabel(uv), _uvStatus(uv)),
        _Check(
          CupertinoIcons.cloud_bolt,
          'Storm risk',
          ws < 30
              ? 'Low'
              : ws < 50
              ? 'Moderate'
              : 'High',
          _windStatus(ws),
        ),
      ];
    },
    promptOf: (w) =>
        'Live weather: temp ${w.hourly.first.temperature.toStringAsFixed(1)}°C, '
        'wind ${w.currentWindSpeed.toStringAsFixed(1)} km/h ${_windDir(w.currentWindDirection)}, '
        'humidity ${w.hourly.first.humidity.toStringAsFixed(0)}%, '
        'UV ${w.hourly.first.uvIndex.toStringAsFixed(1)}. '
        'Write a 3-4 sentence professional marine weather briefing for a sailor. Plain text only.',
  ),

  _Prof(
    key: 'farmer',
    name: 'Farmer',
    hint: 'Soil & crop care',
    icon: CupertinoIcons.leaf_arrow_circlepath,
    metricsOf: (w) => [
      _Metric('Temp', '${w.hourly.first.temperature.toStringAsFixed(1)}', '°C'),
      _Metric('Humidity', '${w.hourly.first.humidity.toStringAsFixed(0)}', '%'),
      _Metric(
        'UV index',
        '${w.hourly.first.uvIndex.toStringAsFixed(1)}',
        _uvLabel(w.hourly.first.uvIndex),
      ),
    ],
    checksOf: (w) {
      final h = w.hourly.first.humidity;
      final ws = w.currentWindSpeed;
      final uv = w.hourly.first.uvIndex;
      final t = w.hourly.first.temperature;
      return [
        _Check(
          CupertinoIcons.thermometer,
          'Temperature',
          '${t.toStringAsFixed(1)}°C',
          t < 35 ? _Status.good : _Status.warn,
        ),
        _Check(
          CupertinoIcons.drop,
          'Humidity',
          '${h.toStringAsFixed(0)}%',
          _humidityStatus(h),
        ),
        _Check(
          CupertinoIcons.wind,
          'Wind (spray)',
          '${ws.toStringAsFixed(1)} km/h',
          _windStatus(ws),
        ),
        _Check(CupertinoIcons.sun_max, 'UV index', _uvLabel(uv), _uvStatus(uv)),
        _Check(
          CupertinoIcons.snow,
          'Frost risk',
          t > 4 ? 'None' : 'High',
          t > 4 ? _Status.good : _Status.bad,
        ),
      ];
    },
    promptOf: (w) =>
        'Live weather: temp ${w.hourly.first.temperature.toStringAsFixed(1)}°C, '
        'humidity ${w.hourly.first.humidity.toStringAsFixed(0)}%, '
        'wind ${w.currentWindSpeed.toStringAsFixed(1)} km/h, '
        'UV ${w.hourly.first.uvIndex.toStringAsFixed(1)}, '
        'sunrise ${w.daily.first.sunrise}, sunset ${w.daily.first.sunset}. '
        'Write a 3-4 sentence professional briefing for a farmer (irrigation, spraying, crop safety). Plain text only.',
  ),

  _Prof(
    key: 'fisherman',
    name: 'Fisherman',
    hint: 'Tides & sea state',
    icon: CupertinoIcons.antenna_radiowaves_left_right,
    metricsOf: (w) => [
      _Metric('Wind', '${w.currentWindSpeed.toStringAsFixed(1)}', 'km/h'),
      _Metric('Humidity', '${w.hourly.first.humidity.toStringAsFixed(0)}', '%'),
      _Metric('Temp', '${w.hourly.first.temperature.toStringAsFixed(1)}', '°C'),
    ],
    checksOf: (w) {
      final ws = w.currentWindSpeed;
      final uv = w.hourly.first.uvIndex;
      return [
        _Check(
          CupertinoIcons.wind,
          'Sea wind',
          '${ws.toStringAsFixed(1)} km/h ${_windDir(w.currentWindDirection)}',
          _windStatus(ws),
        ),
        _Check(
          CupertinoIcons.drop,
          'Humidity',
          '${w.hourly.first.humidity.toStringAsFixed(0)}%',
          _humidityStatus(w.hourly.first.humidity),
        ),
        _Check(CupertinoIcons.sun_max, 'UV index', _uvLabel(uv), _uvStatus(uv)),
        _Check(
          CupertinoIcons.cloud_bolt,
          'Squall risk',
          ws < 20
              ? 'Low'
              : ws < 40
              ? 'Moderate'
              : 'High',
          _windStatus(ws),
        ),
        _Check(
          CupertinoIcons.moon,
          'Sunrise',
          _timeOnly(w.daily.first.sunrise),
          _Status.good,
        ),
      ];
    },
    promptOf: (w) =>
        'Live weather: temp ${w.hourly.first.temperature.toStringAsFixed(1)}°C, '
        'wind ${w.currentWindSpeed.toStringAsFixed(1)} km/h ${_windDir(w.currentWindDirection)}, '
        'humidity ${w.hourly.first.humidity.toStringAsFixed(0)}%, '
        'UV ${w.hourly.first.uvIndex.toStringAsFixed(1)}, '
        'sunrise ${w.daily.first.sunrise}. '
        'Write a 3-4 sentence fishing conditions briefing (sea state, safety, best windows). Plain text only.',
  ),

  _Prof(
    key: 'pilot',
    name: 'Pilot',
    hint: 'Aviation & ceiling',
    icon: CupertinoIcons.airplane,
    metricsOf: (w) => [
      _Metric('Wind', '${w.currentWindSpeed.toStringAsFixed(1)}', 'km/h'),
      _Metric('Temp', '${w.hourly.first.temperature.toStringAsFixed(1)}', '°C'),
      _Metric('Humidity', '${w.hourly.first.humidity.toStringAsFixed(0)}', '%'),
    ],
    checksOf: (w) {
      final ws = w.currentWindSpeed;
      final h = w.hourly.first.humidity;
      final t = w.hourly.first.temperature;
      return [
        _Check(
          CupertinoIcons.wind,
          'Wind speed',
          '${ws.toStringAsFixed(1)} km/h',
          _windStatus(ws),
        ),
        _Check(
          CupertinoIcons.arrow_right,
          'Wind dir',
          _windDir(w.currentWindDirection),
          _Status.good,
        ),
        _Check(
          CupertinoIcons.drop,
          'Humidity',
          '${h.toStringAsFixed(0)}%',
          _humidityStatus(h),
        ),
        _Check(
          CupertinoIcons.thermometer,
          'Temperature',
          '${t.toStringAsFixed(1)}°C',
          t < 35 ? _Status.good : _Status.warn,
        ),
        _Check(
          CupertinoIcons.snow,
          'Icing risk',
          t > 4 ? 'None' : 'Possible',
          t > 4 ? _Status.good : _Status.bad,
        ),
      ];
    },
    promptOf: (w) =>
        'Live weather: temp ${w.hourly.first.temperature.toStringAsFixed(1)}°C, '
        'wind ${w.currentWindSpeed.toStringAsFixed(1)} km/h ${_windDir(w.currentWindDirection)}, '
        'humidity ${w.hourly.first.humidity.toStringAsFixed(0)}%. '
        'Write a 3-4 sentence aviation weather briefing for a pilot (VFR/IFR, hazards). Plain text only.',
  ),

  _Prof(
    key: 'hiker',
    name: 'Hiker',
    hint: 'Trail & outdoor safety',
    icon: CupertinoIcons.map,
    metricsOf: (w) => [
      _Metric('Temp', '${w.hourly.first.temperature.toStringAsFixed(1)}', '°C'),
      _Metric(
        'UV index',
        '${w.hourly.first.uvIndex.toStringAsFixed(1)}',
        _uvLabel(w.hourly.first.uvIndex),
      ),
      _Metric('Humidity', '${w.hourly.first.humidity.toStringAsFixed(0)}', '%'),
    ],
    checksOf: (w) {
      final uv = w.hourly.first.uvIndex;
      final t = w.hourly.first.temperature;
      final ws = w.currentWindSpeed;
      return [
        _Check(
          CupertinoIcons.sun_max,
          'UV index',
          '${uv.toStringAsFixed(1)} — ${_uvLabel(uv)}',
          _uvStatus(uv),
        ),
        _Check(
          CupertinoIcons.thermometer,
          'Temperature',
          '${t.toStringAsFixed(1)}°C',
          t < 32 ? _Status.good : _Status.warn,
        ),
        _Check(
          CupertinoIcons.wind,
          'Wind chill',
          ws < 20 ? 'Low risk' : 'Moderate',
          _windStatus(ws),
        ),
        _Check(
          CupertinoIcons.drop,
          'Humidity',
          '${w.hourly.first.humidity.toStringAsFixed(0)}%',
          _humidityStatus(w.hourly.first.humidity),
        ),
        _Check(
          CupertinoIcons.clock,
          'Sunset',
          _timeOnly(w.daily.first.sunset),
          _Status.good,
        ),
      ];
    },
    promptOf: (w) =>
        'Live weather: temp ${w.hourly.first.temperature.toStringAsFixed(1)}°C, '
        'UV ${w.hourly.first.uvIndex.toStringAsFixed(1)}, '
        'humidity ${w.hourly.first.humidity.toStringAsFixed(0)}%, '
        'wind ${w.currentWindSpeed.toStringAsFixed(1)} km/h, '
        'sunset ${w.daily.first.sunset}. '
        'Write a 3-4 sentence trail conditions briefing for a hiker (safety, heat, timing). Plain text only.',
  ),

  _Prof(
    key: 'construction',
    name: 'Construction',
    hint: 'Site safety',
    icon: CupertinoIcons.building_2_fill,
    metricsOf: (w) => [
      _Metric('Temp', '${w.hourly.first.temperature.toStringAsFixed(1)}', '°C'),
      _Metric('Wind gust', '${w.currentWindSpeed.toStringAsFixed(1)}', 'km/h'),
      _Metric('Humidity', '${w.hourly.first.humidity.toStringAsFixed(0)}', '%'),
    ],
    checksOf: (w) {
      final ws = w.currentWindSpeed;
      final t = w.hourly.first.temperature;
      final h = w.hourly.first.humidity;
      return [
        _Check(
          CupertinoIcons.wind,
          'Wind speed',
          '${ws.toStringAsFixed(1)} km/h',
          _windStatus(ws),
        ),
        _Check(
          CupertinoIcons.cloud_bolt,
          'Gust risk',
          ws < 30
              ? 'Low'
              : ws < 50
              ? 'Caution'
              : 'High',
          _windStatus(ws),
        ),
        _Check(
          CupertinoIcons.sun_max,
          'Heat index',
          '${t.toStringAsFixed(1)}°C',
          t < 32 ? _Status.good : _Status.warn,
        ),
        _Check(
          CupertinoIcons.drop,
          'Humidity',
          '${h.toStringAsFixed(0)}%',
          _humidityStatus(h),
        ),
        _Check(
          CupertinoIcons.eye,
          'Visibility',
          ws < 30 ? 'Clear' : 'Reduced',
          ws < 30 ? _Status.good : _Status.warn,
        ),
      ];
    },
    promptOf: (w) =>
        'Live weather: temp ${w.hourly.first.temperature.toStringAsFixed(1)}°C, '
        'wind ${w.currentWindSpeed.toStringAsFixed(1)} km/h, '
        'humidity ${w.hourly.first.humidity.toStringAsFixed(0)}%. '
        'Write a 3-4 sentence worksite weather briefing for a construction manager (heat, wind, safety). Plain text only.',
  ),
];

String _timeOnly(String isoOrDateTime) {
  try {
    final dt = DateTime.parse(isoOrDateTime);
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $s';
  } catch (_) {
    return isoOrDateTime;
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PAGE 1 — Home: 6 profession cards
// Add to your router/navigator: Navigator.push(context, CupertinoPageRoute(builder: (_) => const HelperView()))
// ════════════════════════════════════════════════════════════════════════════
class HelperView extends StatelessWidget {
  const HelperView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherCubit()..getWeather(),
      child: CupertinoPageScaffold(
        backgroundColor: AppColors.backgroundColor,
        child: SafeArea(
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (ctx, state) {
              if (state is WeatherLoading || state is WeatherInitial) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.primaryText,
                  ),
                );
              }
              if (state is WeatherFailure) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_circle,
                        color: AppColors.secondaryText,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Could not load weather',
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CupertinoButton(
                        onPressed: () => ctx.read<WeatherCubit>().getWeather(),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: AppColors.secondaryText),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final weather = (state as WeatherSuccess).weather;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _HomeHeader(weather: weather)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (c, i) => _ProfCard(prof: _profs[i], weather: weather),
                        childCount: _profs.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 1.08,
                          ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final WeatherModel weather;
  const _HomeHeader({required this.weather});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RichText(
        //   text: const TextSpan(
        //     style: TextStyle(
        //       fontSize: 30,
        //       fontWeight: FontWeight.w700,
        //       color: AppColors.primaryText,
        //       letterSpacing: -0.5,
        //     ),
        //     children: [
        //       TextSpan(text: 'Weather'),
        //       TextSpan(
        //         text: 'Pro',
        //         style: TextStyle(color: AppColors.secondaryText),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 4),
        // Text(
        //   '${weather.hourly.first.temperature.toStringAsFixed(1)}°C  ·  '
        //   'Wind ${weather.currentWindSpeed.toStringAsFixed(1)} km/h ${_windDir(weather.currentWindDirection)}',
        //   style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
        // ),
        // const SizedBox(height: 20),
        const Text(
          'CHOOSE YOUR PROFESSION',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.primaryText,
            // letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

class _ProfCard extends StatelessWidget {
  final _Prof prof;
  final WeatherModel weather;
  const _ProfCard({super.key, required this.prof, required this.weather});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => WeatherProDetailPage(prof: prof, weather: weather),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x26FFFFFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(prof.icon, color: AppColors.primaryText, size: 26),
          ),
          const Spacer(),
          Text(
            prof.name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            prof.hint,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(
                CupertinoIcons.arrow_right,
                size: 12,
                color: AppColors.secondaryText,
              ),
              SizedBox(width: 4),
              Text(
                'View briefing',
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
// PAGE 2 — Detail page
// ════════════════════════════════════════════════════════════════════════════
class WeatherProDetailPage extends StatefulWidget {
  final _Prof prof;
  final WeatherModel weather;
  const WeatherProDetailPage({
    super.key,
    required this.prof,
    required this.weather,
  });
  @override
  State<WeatherProDetailPage> createState() => _DetailState();
}

class _DetailState extends State<WeatherProDetailPage> {
  String? _briefing;
  bool _loading = true;
  bool _error = false;

  static const _apiKey = 'YOUR_ANTHROPIC_API_KEY'; // replace with your key

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 300,
          'messages': [
            {'role': 'user', 'content': widget.prof.promptOf(widget.weather)},
          ],
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final text = (data['content'] as List)
            .where((b) => b['type'] == 'text')
            .map<String>((b) => b['text'] as String)
            .join('');
        setState(() {
          _briefing = text;
          _loading = false;
        });
      } else {
        setState(() {
          _error = true;
          _loading = false;
        });
      }
    } catch (_) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.prof;
    final w = widget.weather;
    final metrics = p.metricsOf(w);
    final checks = p.checksOf(w);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────────
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        CupertinoIcons.arrow_left,
                        color: AppColors.primaryText,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0x26FFFFFF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(p.icon, color: AppColors.primaryText, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryText,
                        ),
                      ),
                      Text(
                        p.hint,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ── Metrics ─────────────────────────────────────────────────────
              const SizedBox(height: 24),
              _sectionLabel('TODAY AT A GLANCE'),
              const SizedBox(height: 10),
              Row(
                children: metrics
                    .asMap()
                    .entries
                    .map(
                      (e) => Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: e.key < metrics.length - 1 ? 10 : 0,
                          ),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackgroundColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.value.label,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryText,
                                  ),
                                  children: [
                                    TextSpan(text: e.value.value),
                                    if (e.value.unit.isNotEmpty)
                                      TextSpan(
                                        text: ' ${e.value.unit}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              // ── AI Briefing ──────────────────────────────────────────────────
              // const SizedBox(height: 24),
              // _sectionLabel('AI BRIEFING'),
              // const SizedBox(height: 10),
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(18),
              //   decoration: BoxDecoration(
              //     color: AppColors.cardBackgroundColor2,
              //     borderRadius: BorderRadius.circular(18),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Row(
              //         children: [
              //           Icon(
              //             CupertinoIcons.waveform,
              //             size: 13,
              //             color: AppColors.secondaryText,
              //           ),
              //           SizedBox(width: 5),
              //           Text(
              //             'Powered by Claude',
              //             style: TextStyle(
              //               fontSize: 11,
              //               color: AppColors.secondaryText,
              //               letterSpacing: 0.4,
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 12),
              //       if (_loading)
              //         const _Dots()
              //       else if (_error)
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Text(
              //               'Could not load briefing.',
              //               style: TextStyle(
              //                 fontSize: 13,
              //                 color: AppColors.secondaryText,
              //               ),
              //             ),
              //             const SizedBox(height: 8),
              //             GestureDetector(
              //               onTap: _fetch,
              //               child: const Text(
              //                 'Tap to retry',
              //                 style: TextStyle(
              //                   fontSize: 13,
              //                   color: AppColors.primaryText,
              //                   decoration: TextDecoration.underline,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         )
              //       else
              //         Text(
              //           _briefing ?? '',
              //           style: const TextStyle(
              //             fontSize: 14,
              //             color: AppColors.primaryText,
              //             height: 1.7,
              //           ),
              //         ),
              //     ],
              //   ),
              // ),

              // ── Condition checklist ──────────────────────────────────────────
              const SizedBox(height: 24),
              _sectionLabel('CONDITION CHECKLIST'),
              const SizedBox(height: 10),
              ...checks.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1AFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(c.icon, size: 16, color: AppColors.secondaryText),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            c.label,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ),
                        _Badge(status: c.status, text: c.value),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Hourly forecast (next 8 hrs from model) ──────────────────────
              const SizedBox(height: 24),
              _sectionLabel('NEXT 8 HOURS'),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: w.hourly.asMap().entries.map((e) {
                    final i = e.key;
                    final h = e.value;
                    final uv = h.uvIndex;
                    return Container(
                      width: 80,
                      margin: EdgeInsets.only(
                        right: i < w.hourly.length - 1 ? 10 : 0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: i == 0
                            ? AppColors.cardBackgroundColor2
                            : AppColors.cardBackgroundColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            h.formattedTime,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            uv > 5
                                ? CupertinoIcons.sun_max
                                : uv > 2
                                ? CupertinoIcons.cloud_sun
                                : CupertinoIcons.cloud,
                            size: 22,
                            color: uv > 5
                                ? const Color(0xFFFFD966)
                                : AppColors.secondaryText,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${h.temperature.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${h.windSpeed.toStringAsFixed(0)} km/h',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // ── Daily sunrise / sunset ───────────────────────────────────────
              const SizedBox(height: 24),
              _sectionLabel('SUN SCHEDULE'),
              const SizedBox(height: 10),
              Row(
                children: w.daily
                    .take(3)
                    .toList()
                    .asMap()
                    .entries
                    .map(
                      (e) => Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: e.key < 2 ? 10 : 0),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackgroundColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.value.dayName.substring(0, 3).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.sunrise,
                                    size: 13,
                                    color: Color(0xFFFFD966),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _timeOnly(e.value.sunrise),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.sunset,
                                    size: 13,
                                    color: AppColors.secondaryText,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _timeOnly(e.value.sunset),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 14,
      color: AppColors.primaryText,
      // letterSpacing: 1,
      fontWeight: FontWeight.w700,
    ),
  );
}

// ─── Badge ────────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final _Status status;
  final String text;
  const _Badge({super.key, required this.status, required this.text});

  Color get _bg => status == _Status.good
      ? const Color(0xFF1D9E75)
      : status == _Status.warn
      ? const Color(0xFFEF9F27)
      : const Color(0xFFD85A30);
  Color get _fg => status == _Status.good
      ? const Color(0xFFE1F5EE)
      : status == _Status.warn
      ? const Color(0xFF411402)
      : const Color(0xFFFAECE7);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: _bg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 11, color: _fg, fontWeight: FontWeight.w500),
    ),
  );
}

// ─── Animated loading dots ────────────────────────────────────────────────────
class _Dots extends StatefulWidget {
  const _Dots();
  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) => Row(
      children: List.generate(3, (i) {
        final t = ((_c.value * 3) - i).clamp(0.0, 1.0);
        final op = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.2, 1.0);
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Opacity(
            opacity: op,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.secondaryText,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    ),
  );
}
