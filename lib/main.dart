import 'package:climate/constants.dart';
import 'package:climate/features/auth/presentation/view/login_view.dart';
import 'package:climate/features/botton_nav_bar/presentation/manager/cubit/bottom_nav_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const ClimateApp());
}

class ClimateApp extends StatelessWidget {
  const ClimateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(scaffoldBackgroundColor: AppColors.backgroundColor),
        home: LoginView(),
      ),
    );
  }
}
