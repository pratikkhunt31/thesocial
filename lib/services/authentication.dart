// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:velocity_x/velocity_x.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User? currentUser = auth.currentUser;
final GoogleSignIn googleSignIn = GoogleSignIn();

class Authentication extends ChangeNotifier {
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // User? currentUser = firebaseAuth.currentUser;
  // String? userUid;
  // String? get getUserUid => userUid;

  Future<UserCredential?> logIntoAccount(String email, String password,
      {context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      // notifyListeners();
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    // final User? user = userCredential?.user;
    // userUid = user!.uid;
    return userCredential;
  }

  Future<UserCredential?> createAccount({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    // final User? user = userCredential?.user;
    // userUid = user!.uid;
    return userCredential;
  }

  Future logOut() async {
    return auth.signOut();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential userCredential =
        await auth.signInWithCredential(authCredential);
    final User? user = userCredential.user;
    assert(user!.uid != null);
    // userUid = user!.uid;
    // print('Google User Uid => $userUid');
    notifyListeners();
  }

  Future signOutWithGoogle() async {
    return googleSignIn.signOut();
  }
}
