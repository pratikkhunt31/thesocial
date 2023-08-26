import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/screens/landingPage/landingUtils.dart';

class FirebaseServices extends ChangeNotifier {
  UploadTask? imgUploadTask;
  Future uploadUserImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileAvatar/ ${Provider.of<LandingUtils>(context, listen: false).getUserAvatar!.path}/${TimeOfDay.now()}');
    imgUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvatar!);
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
}
