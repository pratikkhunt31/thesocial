// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/screens/landingPage/landingUtils.dart';
import 'package:thesocial/services/authentication.dart';

class FirebaseServices extends ChangeNotifier {
  UploadTask? imgUploadTask;
  String? initUserName, initUserEmail, initUserImage;

  // late File initUserImage;

  String? get getInitUserName => initUserName;

  String? get getInitUserEmail => initUserEmail;

  String? get getInitUserImage => initUserImage;

  Future uploadUserImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/ ${Provider.of<LandingUtils>(context, listen: false).getUserImage!.path}/${TimeOfDay.now()}');
    imgUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserImage!);
    await imgUploadTask!.whenComplete(() {
      print('Image Uploaded');
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userImgUrl =
          url.toString();
      print(
          'The user profile avatar url => ${Provider.of<LandingUtils>(context, listen: false).userImgUrl}');
      notifyListeners();
    });
  }

  // Storing data method
  storeUserData(BuildContext context, {name, password, email, userImg}) async {
    DocumentReference store =
        firestore.collection('users').doc(currentUser!.uid);
    store.set({
      'username': name,
      'email': email,
      'user_pass': password,
      'userid': currentUser!.uid,
      'user_image': userImg,
    });
  }

  Future storeData(BuildContext context, dynamic data) async {
    DocumentReference store =
        firestore.collection('users').doc(currentUser!.uid);
    store.set(data);
  }

  // Future createUserCollection(BuildContext context, dynamic data) async {
  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
  //       .set(data);
  // }

  Future initUserData(BuildContext context) async {
    return firestore
        .collection('users')
        .doc(currentUser!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        print("Fetching user data");
        initUserName = doc['username'];
        initUserEmail = doc['email'];
        initUserImage = doc['user_image'];
        print(initUserName);
        print(initUserEmail);
        print(initUserImage);
        notifyListeners();
      } else {
        {
          print("User data not found");
        }
      }
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return firestore.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String userUid, dynamic collection) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(userUid)
        .delete();
  }

  Future addAward(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('awards')
        .add(data);
  }

  Future updateCaption(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future followUser(
      String followingUid,
      String followingDocId,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }
}

class FirestoreServices {
  static getUser(uid) {
    return firestore
        .collection('users')
        .where('userid', isEqualTo: uid)
        .snapshots();
  }
}
