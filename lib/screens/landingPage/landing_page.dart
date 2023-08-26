// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/screens/landingPage/landingWidget.dart';

import '../../const/colors.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});
  final ConstColors constColors = ConstColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constColors.whiteColor,
      body: Stack(
        children: [
          bodyColor(),
          Provider.of<LandingWidgets>(context, listen: false)
              .bodyImage(context),
          Provider.of<LandingWidgets>(context, listen: false)
              .tagLineText(context),
          Provider.of<LandingWidgets>(context, listen: false)
              .mainButton(context),
          Provider.of<LandingWidgets>(context, listen: false)
              .privacyText(context),
        ],
      ),
    );
  }

  bodyColor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 0.9],
          colors: [constColors.darkColor, constColors.blueGreyColor],
        ),
      ),
    );
  }
}
