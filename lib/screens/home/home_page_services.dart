// ignore_for_file: prefer_const_constructors

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/services/firebaseServices.dart';

class HomePageServices extends ChangeNotifier {
  ConstColors constColors = ConstColors();

  Widget bottomNavBar(
      BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constColors.blueGreyColor,
      unSelectedColor: constColors.whiteColor,
      strokeColor: constColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: const Color(0xff040307),
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: Icon(Icons.message_rounded)),
        CustomNavigationBarItem(
          icon: CircleAvatar(
            radius: 35.0,
            backgroundColor: constColors.blueGreyColor,
            backgroundImage: NetworkImage(
              Provider.of<FirebaseServices>(context, listen: false)
                      .getInitUserImage ??
                  "initUserImage ",
            ),
          ),
        ),
      ],
    );
  }
}
