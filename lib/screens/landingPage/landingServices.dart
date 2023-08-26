// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/home/home_page.dart';
import 'package:thesocial/screens/landingPage/landingUtils.dart';
import 'package:thesocial/services/authentication.dart';
import 'package:thesocial/services/firebaseServices.dart';

class LandingService extends ChangeNotifier {
  // text controller
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  ConstColors constColors = ConstColors();

  showUserImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: constColors.blueGreyColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constColors.whiteColor,
                  ),
                ),
                CircleAvatar(
                  radius: 80.0,
                  backgroundColor: constColors.transparent,
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .userImage!),
                ),
                Container(
                  child: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Provider.of<LandingUtils>(context)
                              .pickUserImage(context, ImageSource.gallery);
                        },
                        child: Text('ReSelect',
                            style: TextStyle(
                              color: constColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: constColors.whiteColor,
                            )),
                      ),
                      MaterialButton(
                        color: constColors.blueColor,
                        onPressed: () {
                          Provider.of<FirebaseServices>(context, listen: false)
                              .uploadUserImage(context);
                        },
                        child: Text('Confirm Image',
                            style: TextStyle(
                              color: constColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget pwLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('allUsers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                  trailing: IconButton(
                    icon: Icon(EvaIcons.trash, color: constColors.redColor),
                    onPressed: () {},
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage('url'),
                  ),
                  subtitle: Text(
                    'email',
                    // documentSnapshot.data()['userEmail'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constColors.greenColor,
                      fontSize: 12.0,
                    ),
                  ),
                  title: Text(
                    'name',
                    // documentSnapshot.data()['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constColors.greenColor,
                      fontSize: 12.0,
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.22,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                        hintStyle: TextStyle(
                          color: constColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: constColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      obscureText: true,
                      controller: passController,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(
                          color: constColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: constColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: FloatingActionButton(
                      backgroundColor: constColors.blueColor,
                      child: Icon(Icons.check, color: constColors.whiteColor),
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .logIntoAccount(
                                  emailController.text, passController.text)
                              .whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.bottomToTop));
                          });
                        } else {
                          warningText(context, 'Fill all the data!');
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.43,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
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
                  CircleAvatar(
                    backgroundColor: constColors.redColor,
                    radius: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter name',
                        hintStyle: TextStyle(
                          color: constColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: constColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                        hintStyle: TextStyle(
                          color: constColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: constColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextField(
                      controller: passController,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        hintStyle: TextStyle(
                          color: constColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      style: TextStyle(
                        color: constColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: FloatingActionButton(
                      backgroundColor: constColors.redColor,
                      child: Icon(Icons.check, color: constColors.whiteColor),
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .createAccount(
                                  emailController.text, passController.text)
                              .whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.bottomToTop));
                          });
                        } else {
                          warningText(context, 'Fill all the data!');
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: constColors.darkColor,
                borderRadius: BorderRadius.circular(15.0)),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                  color: constColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          );
        });
  }
}
