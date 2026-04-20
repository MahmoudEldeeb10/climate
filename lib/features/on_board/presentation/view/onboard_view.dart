import 'package:climate/constants.dart';
import 'package:climate/core/utils/styles.dart';
import 'package:climate/core/widgets/custom_button.dart';
import 'package:climate/core/widgets/custom_icon.dart';
import 'package:climate/features/auth/presentation/view/login_view.dart';
import 'package:climate/features/on_board/presentation/view/widgets/animated_dot.dart';
import 'package:flutter/material.dart';

class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  final PageController _pageController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              children: [
                // First
                Column(
                  children: [
                    Spacer(flex: 1),
                    CustomIcon(icon: Icons.cloud),
                    SizedBox(height: 20),
                    Text('Accurate Weather', style: Styles.textStyle30),
                    SizedBox(height: 10),

                    Text(
                      'Get real-time weather updates for any',
                      style: Styles.textStyle16,
                    ),
                    Text(
                      'location worldwide with precise forecasts',
                      style: Styles.textStyle16,
                    ),
                    Spacer(flex: 2),
                  ],
                ),

                // Second
                Column(
                  children: [
                    Spacer(flex: 1),

                    CustomIcon(icon: Icons.insights),
                    SizedBox(height: 20),
                    Text('AI-Powered Insights', style: Styles.textStyle30),

                    SizedBox(height: 10),
                    Text(
                      'Receive personalized recommendations and',
                      style: Styles.textStyle16,
                    ),

                    Text(
                      'smart insights tailored to your day.',
                      style: Styles.textStyle16,
                    ),
                    Spacer(flex: 2),
                  ],
                ),

                // Third
                Column(
                  children: [
                    Spacer(flex: 1),

                    CustomIcon(icon: Icons.chat),
                    SizedBox(height: 20),
                    Text('Chat Assistant', style: Styles.textStyle30),

                    SizedBox(height: 10),
                    Text(
                      'Ask weather questions in natural language',
                      style: Styles.textStyle16,
                    ),

                    Text(
                      'and get instant intelligent answers.',
                      style: Styles.textStyle16,
                    ),
                    Spacer(flex: 2),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.01,
              left: 0,
              right: 0,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedDotContainer(count: 3, activeIndex: currentIndex),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: CustomButton(
                      color: AppColors.cardBackgroundColor,
                      text: 'Next',
                      textColor: Colors.white,
                      onpressed: () {
                        if (currentIndex == 2) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
