// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/home/home_page.dart';
import 'package:thesocial/screens/landingPage/landingServices.dart';
import 'package:thesocial/screens/landingPage/landingUtils.dart';
import 'package:thesocial/services/authentication.dart';

class LandingWidgets extends ChangeNotifier {
  ConstColors constColors = ConstColors();

  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login.png'),
        ),
      ),
    );
  }

  Widget tagLineText(BuildContext context) {
    return Positioned(
      top: 450.0,
      left: 20.0,
      child: Container(
        constraints: BoxConstraints(maxWidth: 170.0),
        child: RichText(
          text: TextSpan(
            text: 'Are ',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: constColors.blueColor,
              // fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'You ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constColors.whiteColor,
                  // fontWeight: FontWeight.bold,
                  fontSize: 34.0,
                ),
              ),
              TextSpan(
                text: 'Social',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constColors.whiteColor,
                  // fontWeight: FontWeight.bold,
                  fontSize: 34.0,
                ),
              ),
              TextSpan(
                text: '?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: constColors.whiteColor,
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

  Widget mainButton(BuildContext context) {
    return Positioned(
      top: 630.0,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                emailAuthSheet(context);
              },
              child: Container(
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: constColors.yellowColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                    Icon(Icons.email_outlined, color: constColors.yellowColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('Signing With Google');
                Provider.of<Authentication>(context, listen: false)
                    .signInWithGoogle()
                    .whenComplete(() {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: HomePage(),
                          type: PageTransitionType.bottomToTop));
                });
              },
              child: Container(
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: constColors.redColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                    Icon(FontAwesomeIcons.google, color: constColors.redColor),
              ),
            ),
            GestureDetector(
              child: Container(
                width: 80.0,
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(color: constColors.blueColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Icon(FontAwesomeIcons.facebookF,
                    color: constColors.blueColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height - 100,
      left: 20.0,
      right: 20.0,
      child: Column(
        children: [
          Text(
            "By Continuing you agree theSocial's Terms of",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14.0),
          ),
          Text(
            "Services & Privacy Policy",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constColors.whiteColor,
                  ),
                ),
                Provider.of<LandingService>(context, listen: false)
                    .pwLessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constColors.blueColor,
                      child: Text(
                        'Log in',
                        style: TextStyle(
                            color: constColors.whiteColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Provider.of<LandingService>(context, listen: false)
                            .loginSheet(context);
                      },
                    ),
                    MaterialButton(
                      color: constColors.redColor,
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            color: constColors.whiteColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Provider.of<LandingUtils>(context, listen: false)
                            .selectAvatarOptionSheet(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
