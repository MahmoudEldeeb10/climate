import 'package:climate/constants.dart';
import 'package:climate/features/ai_insights/presentation/view/ai_insights_view.dart';
import 'package:climate/features/botton_nav_bar/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:climate/features/chat/presentation/view/chat_view.dart';
import 'package:climate/features/home/presentation/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final List pages = [HomeView(), AIInsightsView(), ChatView()];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              pages[state.currentIndex],

              Positioned(
                bottom: 16,
                left: 52,
                right: 52,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BottomNavigationBar(
                    backgroundColor: AppColors.cardBackgroundColor,
                    currentIndex: state.currentIndex,
                    onTap: context.read<BottomNavCubit>().changeTab,

                    showSelectedLabels: true,
                    showUnselectedLabels: false,
                    type: BottomNavigationBarType.fixed,

                    selectedItemColor: AppColors.primaryText,
                    unselectedItemColor: AppColors.primaryText,

                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.insights_outlined),
                        label: 'Insights',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.chat_outlined),
                        label: 'Chat',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
