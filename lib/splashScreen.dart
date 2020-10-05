import 'package:catvsdog/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: HomeScreen(),
      title: Text(
        "Dog and Cat",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Color(0xFFE99600),
        ),
      ),
      image: Image.asset(
        "assets/cat.png",
      ),
      backgroundColor: Colors.black,
      photoSize: 50,
      loaderColor: Color(0xFFEEDA28),
    );
  }
}
