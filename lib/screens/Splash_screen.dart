import 'dart:async';
import 'package:flutter/material.dart';
import 'Login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _loadEnvAndNavigate();
  }

  Future<void> _loadEnvAndNavigate() async {
    await dotenv.load(fileName: "assets/.env");
    await Future.delayed(Duration(seconds: 4));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, 
        ),
        child: Center(
          child: Image.asset("assets/k.png", width: 150, height: 150),
        ),
      ),
    );
  }
}
