// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/home/home_page.dart';
import 'package:thesocial/services/authentication.dart';
import 'package:thesocial/services/firebaseServices.dart';

import 'alt_profile.dart';

class AltProfileWidget extends ChangeNotifier {
  ConstColors constColors = ConstColors();

  Widget appBar(BuildContext context) {
    return AppBar(
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
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: HomePage(), type: PageTransitionType.bottomToTop));
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
                text: 'Social',
                style: TextStyle(
                  color: constColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ]),
      ),
    );
  }

  Widget headerProfile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 220.0,
                width: 150.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: constColors.transparent,
                          radius: 60.0,
                          backgroundImage:
                              NetworkImage(snapshot.data!['user_image']),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          snapshot.data!['username'],
                          style: TextStyle(
                            color: constColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(EvaIcons.email,
                                color: constColors.greenColor, size: 18.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                snapshot.data!['email'],
                                style: TextStyle(
                                  color: constColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              checkFollowerSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: constColors.darkColor,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              height: 70.0,
                              width: 80.0,
                              child: Column(
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(snapshot.data!['userid'])
                                          .collection('followers')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          return Text(
                                            snapshot.data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                color: constColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28.0),
                                          );
                                        }
                                      }),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                        color: constColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: constColors.darkColor,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            height: 70.0,
                            width: 80.0,
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!['userid'])
                                        .collection('following')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: TextStyle(
                                              color: constColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28.0),
                                        );
                                      }
                                    }),
                                Text(
                                  'Following',
                                  style: TextStyle(
                                      color: constColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: constColors.darkColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        height: 70.0,
                        width: 80.0,
                        child: Column(
                          children: [
                            Text(
                              '0',
                              style: TextStyle(
                                  color: constColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28.0),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                  color: constColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: constColors.blueColor,
                  onPressed: () {
                    Provider.of<FirebaseServices>(context, listen: false)
                        .followUser(
                      userUid,
                      currentUser!.uid,
                      {
                        'username': Provider.of<FirebaseServices>(context,
                                listen: false)
                            .getInitUserName,
                        'userImage': Provider.of<FirebaseServices>(context,
                                listen: false)
                            .getInitUserImage,
                        'userUid': currentUser!.uid,
                        'userEmail': Provider.of<FirebaseServices>(context,
                                listen: false)
                            .getInitUserEmail,
                        'time': Timestamp.now(),
                      },
                      currentUser!.uid,
                      userUid,
                      {
                        'username': snapshot.data!['username'],
                        'userImage': snapshot.data!['user_image'],
                        'userEmail': snapshot.data!['email'],
                        'userUid': snapshot.data!['userid'],
                        'time': Timestamp.now(),
                      },
                    )
                        .whenComplete(() {
                      followedNotification(
                        context,
                        snapshot.data!['username'],
                      );
                    });
                  },
                  child: Text(
                    'Follow',
                    style: TextStyle(
                      color: constColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                MaterialButton(
                  color: constColors.blueColor,
                  onPressed: () {},
                  child: Text(
                    'Message',
                    style: TextStyle(
                      color: constColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 25.0,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Divider(
          color: constColors.whiteColor,
        ),
      ),
    );
  }

  Widget middleProfile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  FontAwesomeIcons.userAstronaut,
                  size: 16.0,
                  color: constColors.yellowColor,
                ),
                SizedBox(width: 10.0),
                Text(
                  'Recently Added',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: constColors.whiteColor,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constColors.darkColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.53,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: constColors.darkColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0)),
        child: Image.asset('assets/images/login.png'),
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constColors.darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constColors.whiteColor,
                    ),
                  ),
                  Text(
                    'Followed $name',
                    style: TextStyle(
                      color: constColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  checkFollowerSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data.data()['userid'])
                    .collection('followers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView(
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListTile(
                            onTap: () {
                              if (documentSnapshot['userUid'] !=
                                  currentUser!.uid) {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: AltProfile(
                                            userUid:
                                                documentSnapshot['userUid']),
                                        type: PageTransitionType.topToBottom));
                              }
                            },
                            trailing:
                                documentSnapshot['userUid'] == currentUser!.uid
                                    ? SizedBox(
                                        width: 0.0,
                                        height: 0.0,
                                      )
                                    : MaterialButton(
                                        color: constColors.blueColor,
                                        child: Text(
                                          'Unfollow',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: constColors.whiteColor,
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                            leading: CircleAvatar(
                              backgroundColor: constColors.darkColor,
                              backgroundImage:
                                  NetworkImage(documentSnapshot['userImage']),
                            ),
                            title: Text(
                              documentSnapshot['username'],
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: constColors.whiteColor,
                              ),
                            ),
                            subtitle: Text(
                              documentSnapshot['userEmail'],
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: constColors.yellowColor,
                              ),
                            ),
                          );
                        }
                      }).toList(),
                    );
                  }
                }),
          );
        });
  }
}
