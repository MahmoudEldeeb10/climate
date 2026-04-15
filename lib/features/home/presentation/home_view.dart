import 'package:climate/constants.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SizedBox(height: 50), CustomSearch()],
        ),
      ),
    );
  }
}

class CustomSearch extends StatelessWidget {
  const CustomSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: TextField(
        style: const TextStyle(color: AppColors.primaryText),
        cursorColor: AppColors.primaryText,
        decoration: InputDecoration(
          hintText: 'Search for a city',
          hintStyle: TextStyle(color: AppColors.primaryText),
          filled: true,
          fillColor: AppColors.cardBackgroundColor,
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryText),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
