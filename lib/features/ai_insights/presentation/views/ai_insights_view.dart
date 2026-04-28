import 'package:climate/constants.dart';
import 'package:climate/core/utils/glass_card.dart';
import 'package:flutter/material.dart';
import 'widgets/header_widget.dart';
import 'widgets/weekly_outlook_card.dart';

class AiInsightsView extends StatelessWidget {
  const AiInsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            HeaderWidget(),
            SizedBox(height: 20),

            GlassCard(
              icon: "assets/images/summary.png",
              title: "Today's Summary",
              text: "Pleasant day ahead with partly cloudy skies.",
            ),
            GlassCard(
              icon: "assets/images/clothes.png",
              title: "What to Wear",
              text: "Light layers recommended.",
            ),
            GlassCard(
              icon: "assets/images/rain.png",
              title: "Rain Alert",
              text: "Rain expected Wednesday.",
            ),
            GlassCard(
              icon: "assets/images/tip.png",
              title: "AI Tip",
              text: "Temperature drops by evening, bring a jacket!",
            ),

            WeeklyOutlookCard(),
          ],
        ),
      ),
    );
  }
}
