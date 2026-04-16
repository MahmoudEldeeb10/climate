import 'package:climate/features/home/presentation/view/widgets/custom_search.dart';
import 'package:flutter/material.dart' hide SearchBar;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SizedBox(height: 50), SearchBar()],
        ),
      ),
    );
  }
}
