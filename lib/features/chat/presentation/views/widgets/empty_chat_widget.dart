import 'package:flutter/material.dart';

class EmptyChatWidget extends StatelessWidget {
  const EmptyChatWidget({super.key});

  static const List<String> _suggestions = [
    '🌡 What\'s the weather in Cairo today?',
    '🌧 Will it rain in London this week?',
    '❄️ What causes snowstorms?',
    '🌪 How do hurricanes form?',
    '☀️ Best time to visit Dubai weather-wise?',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   width: 90,
            //   height: 90,
            //   decoration: BoxDecoration(
            //     gradient: const LinearGradient(
            //       colors: [Color(0xFF2576F9), Color(0xFF6D98ED)],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ),
            //     shape: BoxShape.circle,
            //     boxShadow: [
            //       BoxShadow(
            //         color: const Color(0xFF2576F9).withOpacity(0.4),
            //         blurRadius: 24,
            //         offset: const Offset(0, 8),
            //       ),
            //     ],
            //   ),
            //   child: const Center(
            //     child: Text('🌤', style: TextStyle(fontSize: 44)),
            //   ),
            // ),
            // const SizedBox(height: 24),
            Text(
              'WeatherBot',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your AI-powered weather companion.\nAsk me anything about weather!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Try asking:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white38 : Colors.black38,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ..._suggestions.map((s) => _SuggestionChip(text: s)),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;
  const _SuggestionChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF2576F9).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
