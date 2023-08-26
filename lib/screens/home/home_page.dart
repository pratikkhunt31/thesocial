import 'package:flutter/material.dart';
import 'package:thesocial/const/colors.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  ConstColors constColors = ConstColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constColors.redColor,
    );
  }
}
