import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AIInsightsView extends StatelessWidget {
  const AIInsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(child: Text('AI Insights Coming Soon!')),
          ],
        ),
      ),
    );
  }
}
