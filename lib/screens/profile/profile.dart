// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/profile/profile_services.dart';
import 'package:thesocial/services/authentication.dart';
import 'package:thesocial/services/firebaseServices.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    ConstColors constColors = ConstColors();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            EvaIcons.settings2Outline,
            color: constColors.lightBlueColor,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ProfileServices>(context, listen: false)
                    .logOutDialog(context);
              },
              icon: Icon(
                EvaIcons.logInOutline,
                color: constColors.lightBlueColor,
              ))
        ],
        backgroundColor: constColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
          text: TextSpan(
              text: "My ",
              style: TextStyle(
                color: constColors.whiteColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "Profile",
                  style: TextStyle(
                    color: constColors.blueColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: constColors.blueGreyColor.withOpacity(0.6),
            ),
            child: StreamBuilder(
              stream: FirestoreServices.getUser(currentUser!.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(constColors.redColor),
                    ),
                  );
                } else {
                  var data = snapshot.data!.docs[0];

                  return Column(
                    children: [
                      Provider.of<ProfileServices>(context, listen: false)
                          .headerProfile(context, data),
                      Provider.of<ProfileServices>(context, listen: false)
                          .divider(context),
                      Provider.of<ProfileServices>(context, listen: false)
                          .middleProfile(context, data),
                      Provider.of<ProfileServices>(context, listen: false)
                          .footerProfile(context, data),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

//
// child: StreamBuilder<DocumentSnapshot>(
// stream: FirebaseFirestore.instance
//     .collection('users')
//     .doc(Provider.of<Authentication>(context, listen: false)
//     .getUserUid)
//     .snapshots(),
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return Center(
// child: CircularProgressIndicator(),
// );
// } else {
// var data = snapshot.data;
// return Column(
// children: [
// Provider.of<ProfileServices>(context, listen: false)
//     .headerProfile(context, snapshot),
// Provider.of<ProfileServices>(context, listen: false)
//     .divider(context),
// Provider.of<ProfileServices>(context, listen: false)
//     .middleProfile(context),
// Provider.of<ProfileServices>(context, listen: false)
//     .footerProfile(context, snapshot),
// ],
// );
// }
// },
// ),
