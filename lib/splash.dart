import 'package:demoapp/screens/auth_screen.dart';
import 'package:demoapp/screens/home_screen.dart';
import 'package:demoapp/widgets/app_icon.dart';
import 'package:demoapp/widgets/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'animations/fade_transition.dart';
import 'models/user.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<void> fetchData() async {
    final userProvider = Provider.of<UserStats>(context, listen: false);

    if (FirebaseAuth.instance.currentUser != null) {
      await Future.delayed(const Duration(milliseconds: 400));
      final fetchCompleted = await userProvider.fetchUserStats();

      if (fetchCompleted) {
        Navigator.of(context).push(FadeTransiton(const HomeScreen(), 300));
      } else {
        Navigator.of(context).push(FadeTransiton(const AuthScreen(), 300));
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 400));

      Navigator.of(context).push(FadeTransiton(const AuthScreen(), 300));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          MyBackground(),
          Center(
            child: AppIcon(size: 100),
          ),
        ],
      ),
    );
  }
}
