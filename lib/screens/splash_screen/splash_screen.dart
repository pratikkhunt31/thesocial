// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:thesocial/screens/home/home_page.dart';
import 'package:thesocial/screens/landingPage/landing_page.dart';
import 'package:thesocial/services/authentication.dart';

import '../../const/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstColors constColors = ConstColors();

  changeScreen() {
    Timer(Duration(seconds: 2), () {
      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: LandingPage(), type: PageTransitionType.rightToLeft));
        } else {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: HomePage(), type: PageTransitionType.rightToLeft));
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constColors.darkColor,
      body: Center(
        child: RichText(
          text: TextSpan(
            text: 'the',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: constColors.whiteColor,
              // fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Social',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constColors.blueColor,
                  // fontWeight: FontWeight.bold,
                  fontSize: 34.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
