// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/altProfile/alt_profile.dart';
import 'package:thesocial/services/authentication.dart';
import 'package:thesocial/services/firebaseServices.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions extends ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  TextEditingController updateCaptionController = TextEditingController();

  ConstColors constColors = ConstColors();
  String? imageTimePosted;
  String get getImageTimePosted => imageTimePosted ?? '';

  // Time services
  showTimeAgo(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    // print(imageTimePosted);
    notifyListeners();
  }

  // Post option
  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0),
                  )),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constColors.whiteColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 300.0,
                                        height: 50.0,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Add New Caption',
                                            hintStyle: TextStyle(
                                              color: constColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          style: TextStyle(
                                            color: constColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                          controller: updateCaptionController,
                                        ),
                                      ),
                                      FloatingActionButton(
                                          backgroundColor: constColors.redColor,
                                          child: Icon(
                                            FontAwesomeIcons.upload,
                                            color: constColors.whiteColor,
                                          ),
                                          onPressed: () {
                                            Provider.of<FirebaseServices>(
                                                    context,
                                                    listen: false)
                                                .updateCaption(postId, {
                                              'caption':
                                                  updateCaptionController.text
                                            }).whenComplete(() {
                                              updateCaptionController.clear();
                                              Navigator.pop(context);
                                            });
                                          })
                                    ],
                                  ),
                                );
                              });
                        },
                        color: constColors.blueColor,
                        child: Text(
                          'Edit caption',
                          style: TextStyle(
                            color: constColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: constColors.darkColor,
                                  title: Text(
                                    'Delete this post?',
                                    style: TextStyle(
                                      color: constColors.whiteColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              constColors.whiteColor,
                                          color: constColors.whiteColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        Provider.of<FirebaseServices>(context,
                                                listen: false)
                                            .deleteUserData(postId, 'posts')
                                            .whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      color: constColors.redColor,
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          color: constColors.whiteColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        color: constColors.redColor,
                        child: Text(
                          'Delete Post',
                          style: TextStyle(
                            color: constColors.whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Add Likes
  Future addLikes(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username':
          Provider.of<FirebaseServices>(context, listen: false).getInitUserName,
      'userid': currentUser!.uid,
      'user_image': Provider.of<FirebaseServices>(context, listen: false)
          .getInitUserImage,
      'email': Provider.of<FirebaseServices>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    });
  }

  // Add Comment
  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .doc(comment)
        .set({
      'comment': comment,
      'username':
          Provider.of<FirebaseServices>(context, listen: false).getInitUserName,
      'userid': currentUser!.uid,
      'user_image': Provider.of<FirebaseServices>(context, listen: false)
          .getInitUserImage,
      'email': Provider.of<FirebaseServices>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    });
  }

  // Rewards
  showAwardsPresent(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
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
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: constColors.whiteColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Award Socialites',
                      style: TextStyle(
                        color: constColors.blueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('awards')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        child: AltProfile(
                                            userUid:
                                                documentSnapshot['userid']),
                                        type: PageTransitionType.bottomToTop,
                                      ));
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['user_image']),
                                  radius: 15.0,
                                  backgroundColor: constColors.darkColor,
                                ),
                              ),
                              title: Text(
                                documentSnapshot['username'],
                                style: TextStyle(
                                  color: constColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              trailing:
                                  currentUser!.uid == documentSnapshot['userid']
                                      ? SizedBox(
                                          width: 0.0,
                                          height: 0.0,
                                        )
                                      : MaterialButton(
                                          onPressed: () {},
                                          color: constColors.blueColor,
                                          child: Text(
                                            'Follow',
                                            style: TextStyle(
                                              color: constColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  showCommentSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
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
                  Container(
                    width: 110,
                    decoration: BoxDecoration(
                      border: Border.all(color: constColors.whiteColor),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          color: constColors.blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.615,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(docId)
                            .collection('comment')
                            .orderBy('time')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // else if (!snapshot.hasData) {
                          //   return Center(
                          //     child: Text(
                          //       'No Comments Yet!',
                          //       style: TextStyle(color: constColors.whiteColor),
                          //     ),
                          //   );
                          // }
                          else {
                            return ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.14,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    PageTransition(
                                                      child: AltProfile(
                                                          userUid:
                                                              documentSnapshot[
                                                                  'userid']),
                                                      type: PageTransitionType
                                                          .bottomToTop,
                                                    ));
                                              },
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    constColors.darkColor,
                                                radius: 15.0,
                                                backgroundImage: NetworkImage(
                                                    documentSnapshot[
                                                        'user_image']),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              documentSnapshot['username'],
                                              style: TextStyle(
                                                color: constColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                    FontAwesomeIcons.arrowUp,
                                                    color:
                                                        constColors.blueColor,
                                                    size: 12.0),
                                              ),
                                              Text(
                                                '0',
                                                style: TextStyle(
                                                  color: constColors.whiteColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                    FontAwesomeIcons.reply,
                                                    color:
                                                        constColors.yellowColor,
                                                    size: 12.0),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: constColors.blueColor,
                                                size: 12.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.72,
                                              child: Text(
                                                documentSnapshot['comment'],
                                                style: TextStyle(
                                                  color: constColors.whiteColor,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                  FontAwesomeIcons.trashCan,
                                                  color: constColors.redColor,
                                                  size: 16.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: constColors.darkColor
                                            .withOpacity(0.2),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    // color: constColors.redColor,
                    // height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            // height: 40.0,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Add Comment...',
                                hintStyle: TextStyle(
                                  color: constColors.whiteColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              controller: commentController,
                              style: TextStyle(
                                color: constColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            backgroundColor: constColors.greenColor,
                            child: Icon(
                              FontAwesomeIcons.comment,
                              color: constColors.whiteColor,
                            ),
                            onPressed: () {
                              print('Adding Comment..');
                              addComment(context, snapshot['caption'],
                                      commentController.text)
                                  .whenComplete(() {
                                commentController.clear();
                                notifyListeners();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constColors.whiteColor,
                  ),
                ),
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(color: constColors.whiteColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Likes',
                      style: TextStyle(
                        color: constColors.blueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                        child: AltProfile(
                                            userUid:
                                                documentSnapshot['userid']),
                                        type: PageTransitionType.bottomToTop,
                                      ));
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['user_image']),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['username'],
                                style: TextStyle(
                                  color: constColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              subtitle: Text(
                                documentSnapshot['email'],
                                style: TextStyle(
                                  color: constColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              trailing:
                                  currentUser!.uid == documentSnapshot['userid']
                                      ? SizedBox(
                                          width: 0.0,
                                          height: 0.0,
                                        )
                                      : MaterialButton(
                                          onPressed: () {},
                                          color: constColors.blueColor,
                                          child: Text(
                                            'Follow',
                                            style: TextStyle(
                                              color: constColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  showRewards(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  topLeft: Radius.circular(12.0),
                )),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constColors.whiteColor,
                  ),
                ),
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(color: constColors.whiteColor),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Rewards',
                      style: TextStyle(
                        color: constColors.blueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('awards')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () async {
                                  print(documentSnapshot['image']);
                                  Provider.of<FirebaseServices>(context,
                                          listen: false)
                                      .addAward(postId, {
                                    'username': Provider.of<FirebaseServices>(
                                            context,
                                            listen: false)
                                        .getInitUserName,
                                    'userid': currentUser!.uid,
                                    'user_image': Provider.of<FirebaseServices>(
                                            context,
                                            listen: false)
                                        .getInitUserImage,
                                    'award': documentSnapshot['image'],
                                    'time': Timestamp.now(),
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    height: 50.0,
                                    width: 50.0,
                                    child: Image.network(
                                        documentSnapshot['image']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
