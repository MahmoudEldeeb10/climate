import 'dart:async';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/features/on_board/presentation/view/onboard_view.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/appLogo2.png',
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
            ),
            Text(
              'Climate AI',
              style: Styles.textStyle30.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Smart Weather AI',
              style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
