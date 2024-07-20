import 'package:flutter/material.dart';
import 'package:picture_of_day/presentation/home_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 5),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomePage()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: DefaultTextStyle(style: const TextStyle(fontSize: 30), child: AnimatedTextKit(animatedTexts: [TypewriterAnimatedText("Welcome to APOD...",speed: const Duration(milliseconds: 200))]))
      ),
    );
  }
}