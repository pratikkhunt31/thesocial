// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/altProfile/alt_profile.dart';
import 'package:thesocial/services/authentication.dart';
import 'package:thesocial/utils/postOption.dart';

class FeedWidget extends ChangeNotifier {
  ConstColors constColors = ConstColors();

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.87,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: constColors.darkColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0))),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                    ),
                  ),
                );
              } else {
                return loadPost(context, snapshot);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        Provider.of<PostFunctions>(context, listen: false)
            .showTimeAgo(documentSnapshot['time']);

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (documentSnapshot['user_uid'] != currentUser!.uid) {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: AltProfile(
                                    userUid: documentSnapshot['user_uid'],
                                  ),
                                  type: PageTransitionType.bottomToTop));
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: constColors.blueGreyColor,
                        radius: 20.0,
                        backgroundImage:
                            NetworkImage(documentSnapshot['user_image']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documentSnapshot['username'],
                              style: TextStyle(
                                color: constColors.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: documentSnapshot['caption'],
                                style: TextStyle(
                                  color: constColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                        ' , ${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted.toString()}',
                                    style: TextStyle(
                                        color: constColors.lightBlueColor
                                            .withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: firestore
                            .collection('posts')
                            .doc(documentSnapshot['caption'])
                            .collection('awards')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return SizedBox(
                                  height: 30.0,
                                  width: 30.0,
                                  child:
                                      Image.network(documentSnapshot['awards']),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.46,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Image.network(
                      documentSnapshot['post_image'],
                      scale: 2,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showLikes(
                                context,
                                documentSnapshot['caption'],
                              );
                            },
                            onTap: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .addLikes(
                                      context,
                                      documentSnapshot['caption'],
                                      currentUser!.uid);
                            },
                            child: Icon(
                              FontAwesomeIcons.heart,
                              color: constColors.redColor,
                              size: 22.0,
                            ),
                          ),
                          SizedBox(width: 5),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(documentSnapshot['caption'])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: constColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showCommentSheet(context, documentSnapshot,
                                      documentSnapshot['caption']);
                            },
                            child: Icon(
                              FontAwesomeIcons.comment,
                              color: constColors.blueColor,
                              size: 22.0,
                            ),
                          ),
                          SizedBox(width: 5),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(documentSnapshot['caption'])
                                .collection('comment')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: constColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showAwardsPresent(
                                      context, documentSnapshot['caption']);
                            },
                            onTap: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showRewards(
                                      context, documentSnapshot['caption']);
                            },
                            child: Icon(
                              FontAwesomeIcons.award,
                              color: constColors.yellowColor,
                              size: 22.0,
                            ),
                          ),
                          SizedBox(width: 5),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(documentSnapshot['caption'])
                                .collection('awards')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: constColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    currentUser!.uid == documentSnapshot['user_uid']
                        ? IconButton(
                            onPressed: () {
                              Provider.of<PostFunctions>(context, listen: false)
                                  .showPostOptions(
                                      context, documentSnapshot['caption']);
                            },
                            icon: Icon(
                              EvaIcons.moreVertical,
                              color: constColors.whiteColor,
                            ))
                        : SizedBox(
                            width: 0.0,
                            height: 0.0,
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

// Widget loadPost1(
//     BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//   return ListView(
//     physics: BouncingScrollPhysics(),
//     shrinkWrap: true,
//     children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
//       // Move the logic inside a FutureBuilder to handle asynchronous operations.
//       return FutureBuilder<void>(
//         future: Provider.of<PostFunctions>(context, listen: false)
//             .showTimeAgo(documentSnapshot['time']),
//         builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // Return your widget here once the asynchronous operation is done.
//             return SizedBox(
//               height: MediaQuery.of(context).size.height * 0.65,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0, left: 8.0),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           child: CircleAvatar(
//                             backgroundColor: constColors.blueGreyColor,
//                             radius: 20.0,
//                             backgroundImage: NetworkImage(
//                                 documentSnapshot['user_image'] ?? ''),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 8.0),
//                           child: SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.6,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   documentSnapshot['username'] ?? '',
//                                   style: TextStyle(
//                                     color: constColors.greenColor,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16.0,
//                                   ),
//                                 ),
//                                 RichText(
//                                   text: TextSpan(
//                                     text: documentSnapshot['caption'],
//                                     style: TextStyle(
//                                       color: constColors.blueColor,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14.0,
//                                     ),
//                                     children: <TextSpan>[
//                                       TextSpan(
//                                         text:
//                                             ' , ${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted.toString()}',
//                                         style: TextStyle(
//                                             color: constColors.lightBlueColor
//                                                 .withOpacity(0.8)),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.2,
//                           height: MediaQuery.of(context).size.height * 0.05,
//                           child: StreamBuilder<QuerySnapshot>(
//                             stream: firestore
//                                 .collection('posts')
//                                 .doc(documentSnapshot['caption'])
//                                 .collection('awards')
//                                 .snapshots(),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return Center(
//                                     child: CircularProgressIndicator());
//                               } else {
//                                 return ListView(
//                                   scrollDirection: Axis.horizontal,
//                                   children: snapshot.data!.docs.map(
//                                       (DocumentSnapshot documentSnapshot) {
//                                     return SizedBox(
//                                       height: 30.0,
//                                       width: 30.0,
//                                       child: Image.network(
//                                           documentSnapshot['awards']),
//                                     );
//                                   }).toList(),
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.46,
//                       width: MediaQuery.of(context).size.width,
//                       child: FittedBox(
//                         child: Image.network(
//                           documentSnapshot['post_image'],
//                           scale: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0, left: 20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         SizedBox(
//                           width: 80.0,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               GestureDetector(
//                                 onLongPress: () {
//                                   Provider.of<PostFunctions>(context,
//                                           listen: false)
//                                       .showLikes(
//                                     context,
//                                     documentSnapshot['caption'],
//                                   );
//                                 },
//                                 onTap: () {
//                                   Provider.of<PostFunctions>(context,
//                                           listen: false)
//                                       .addLikes(
//                                           context,
//                                           documentSnapshot['caption'],
//                                           currentUser!.uid);
//                                 },
//                                 child: Icon(
//                                   FontAwesomeIcons.heart,
//                                   color: constColors.redColor,
//                                   size: 22.0,
//                                 ),
//                               ),
//                               SizedBox(width: 5),
//                               StreamBuilder<QuerySnapshot>(
//                                 stream: FirebaseFirestore.instance
//                                     .collection('posts')
//                                     .doc(documentSnapshot['caption'])
//                                     .collection('likes')
//                                     .snapshots(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   } else {
//                                     return Text(
//                                       snapshot.data!.docs.length.toString(),
//                                       style: TextStyle(
//                                         color: constColors.whiteColor,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18.0,
//                                       ),
//                                     );
//                                   }
//                                 },
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: 80.0,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   Provider.of<PostFunctions>(context,
//                                           listen: false)
//                                       .showCommentSheet(
//                                           context,
//                                           documentSnapshot,
//                                           documentSnapshot['caption']);
//                                 },
//                                 child: Icon(
//                                   FontAwesomeIcons.comment,
//                                   color: constColors.blueColor,
//                                   size: 22.0,
//                                 ),
//                               ),
//                               SizedBox(width: 5),
//                               StreamBuilder<QuerySnapshot>(
//                                 stream: FirebaseFirestore.instance
//                                     .collection('posts')
//                                     .doc(documentSnapshot['caption'])
//                                     .collection('comment')
//                                     .snapshots(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   } else {
//                                     return Text(
//                                       snapshot.data!.docs.length.toString(),
//                                       style: TextStyle(
//                                         color: constColors.whiteColor,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18.0,
//                                       ),
//                                     );
//                                   }
//                                 },
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: 80.0,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   Provider.of<PostFunctions>(context,
//                                           listen: false)
//                                       .showRewards(context,
//                                           documentSnapshot['caption']);
//                                 },
//                                 child: Icon(
//                                   FontAwesomeIcons.award,
//                                   color: constColors.yellowColor,
//                                   size: 22.0,
//                                 ),
//                               ),
//                               SizedBox(width: 5),
//                               StreamBuilder<QuerySnapshot>(
//                                 stream: FirebaseFirestore.instance
//                                     .collection('posts')
//                                     .doc(documentSnapshot['caption'])
//                                     .collection('awards')
//                                     .snapshots(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   } else {
//                                     return Text(
//                                       snapshot.data!.docs.length.toString(),
//                                       style: TextStyle(
//                                         color: constColors.whiteColor,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18.0,
//                                       ),
//                                     );
//                                   }
//                                 },
//                               )
//                             ],
//                           ),
//                         ),
//                         Spacer(),
//                         currentUser!.uid == documentSnapshot['user_uid']
//                             ? IconButton(
//                                 onPressed: () {
//                                   Provider.of<PostFunctions>(context,
//                                           listen: false)
//                                       .showPostOptions(context);
//                                 },
//                                 icon: Icon(
//                                   EvaIcons.moreVertical,
//                                   color: constColors.whiteColor,
//                                 ))
//                             : SizedBox(
//                                 width: 0.0,
//                                 height: 0.0,
//                               ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//             // Your other widget code...
//           } else {
//             // You can return a loading indicator or placeholder here if needed.
//             return CircularProgressIndicator();
//           }
//         },
//       );
//     }).toList(), // Convert the map result to a list.
//   );
// }
}
//
// return FutureBuilder<void>(
// future: Provider.of<PostFunctions>(context, listen: false)
//     .showTimeAgo(documentSnapshot['time']),
// builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
// if (snapshot.connectionState == ConnectionState.done) {
// return SizedBox(
// height: MediaQuery.of(context).size.height * 0.65,
// width: MediaQuery.of(context).size.width,
// // Your other widget code...
// );
// } else if (snapshot.hasError) {
// // Handle the error here, e.g., show an error message.
// return Text("Error: ${snapshot.error}");
// } else {
// return CircularProgressIndicator();
// }
// },
// );
