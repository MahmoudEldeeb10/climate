import 'package:climate/constants.dart';
import 'package:climate/features/botton_nav_bar/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:climate/features/chat/presentation/view/chat_view.dart';
import 'package:climate/features/home/presentation/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final List pages = [
    HomeView(),
    ChatView(),
    HomeView(),
    HomeView(),
    HomeView(),
  ];
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
                left: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BottomNavigationBar(
                      backgroundColor: AppColors.backgroundColor,
                      currentIndex: state.currentIndex,
                      onTap: context.read<BottomNavCubit>().changeTab,

                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      type: BottomNavigationBarType.fixed,

                      selectedItemColor: AppColors.primaryColor,
                      unselectedItemColor: AppColors.textColor,

                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.chat_outlined),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: '',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: '',
                        ),
                      ],
                    ),
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
