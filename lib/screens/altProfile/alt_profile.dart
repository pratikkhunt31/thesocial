// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/altProfile/altProfileWidget.dart';
import 'package:thesocial/screens/home/home_page.dart';

class AltProfile extends StatelessWidget {
  // const AltProfile({super.key, required this.userUid});

  final String userUid;
  const AltProfile({super.key, required this.userUid});

  @override
  Widget build(BuildContext context) {
    ConstColors constColors = ConstColors();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: constColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: HomePage(), type: PageTransitionType.bottomToTop));
          },
        ),
        backgroundColor: constColors.blueGreyColor.withOpacity(0.4),
        actions: [
          IconButton(
              onPressed: () {
                PageTransition(
                    child: HomePage(), type: PageTransitionType.bottomToTop);
              },
              icon: Icon(
                EvaIcons.moreVertical,
                color: constColors.whiteColor,
              ))
        ],
        title: RichText(
          text: TextSpan(
              text: 'The',
              style: TextStyle(
                color: constColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' Social',
                  style: TextStyle(
                    color: constColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constColors.blueGreyColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userUid)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Provider.of<AltProfileWidget>(context, listen: false)
                        .headerProfile(context, snapshot, userUid),
                    Provider.of<AltProfileWidget>(context, listen: false)
                        .divider(context),
                    Provider.of<AltProfileWidget>(context, listen: false)
                        .middleProfile(context),
                    Provider.of<AltProfileWidget>(context, listen: false)
                        .footerProfile(context, snapshot),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
