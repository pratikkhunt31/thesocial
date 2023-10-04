// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unnecessary_null_comparison, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/services/authentication.dart';
import 'package:thesocial/services/firebaseServices.dart';

class UploadPost extends ChangeNotifier {
  ConstColors constColors = ConstColors();

  late File uploadPostImage;

  File get getUploadPostImage => uploadPostImage;
  late String uploadPostImageUrl;

  String get getUploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  UploadTask? imagePostUploadTask;

  //post edit controller
  TextEditingController captionController = TextEditingController();

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        ? print('Select image')
        : uploadPostImage = File(uploadPostImageVal.path);
    print(uploadPostImage.path);

    uploadPostImage != null
        ? showPostImage(context)
        : print('Image upload Error!');

    notifyListeners();
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage);
    await imagePostUploadTask!.whenComplete(() {
      print("Post uploaded");
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      print(uploadPostImageUrl);
      notifyListeners();
    });
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constColors.blueGreyColor,
              borderRadius: BorderRadius.circular(12.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constColors.blueColor,
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                          color: constColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.gallery);
                      },
                    ),
                    MaterialButton(
                      color: constColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          color: constColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.camera);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.36,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constColors.darkColor,
              borderRadius: BorderRadius.circular(12.0),
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
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: SizedBox(
                    height: 200.0,
                    width: 400.0,
                    child: Image.file(
                      uploadPostImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          selectPostImageType(context);
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
                          uploadPostImageToFirebase().whenComplete(() {
                            editPostSheet(context);
                            print("Image Uploaded");
                          });
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

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
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
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.image_aspect_ratio,
                              color: constColors.greenColor,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.fit_screen,
                              color: constColors.yellowColor,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 200.0,
                      width: 300.0,
                      child: Image.file(uploadPostImage, fit: BoxFit.contain),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 30.0,
                      width: 17.0,
                      child: Image.asset('assets/images/login.png'),
                    ),
                    Container(
                      height: 110.0,
                      width: 3.0,
                      color: constColors.blueColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        height: 120.0,
                        width: 300.0,
                        child: TextField(
                          maxLines: 5,
                          textCapitalization: TextCapitalization.words,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          maxLength: 100,
                          controller: captionController,
                          style: TextStyle(
                              color: constColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Add a caption...',
                            hintStyle: TextStyle(
                                color: constColors.whiteColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: () async {
                    Provider.of<FirebaseServices>(context, listen: false)
                        .uploadPostData(captionController.text, {
                      'post_image': getUploadPostImageUrl,
                      'caption': captionController.text,
                      'username':
                          Provider.of<FirebaseServices>(context, listen: false)
                              .getInitUserName,
                      'user_email':
                          Provider.of<FirebaseServices>(context, listen: false)
                              .getInitUserEmail,
                      // Provider.of<FirebaseServices>(context, listen: false)
                      //     .getInitUserEmail,
                      'user_image':
                          Provider.of<FirebaseServices>(context, listen: false)
                              .getInitUserImage,
                      'user_uid': currentUser!.uid,
                      'time': Timestamp.now(),
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  color: constColors.blueColor,
                  child: Text(
                    'Share',
                    style: TextStyle(
                        color: constColors.whiteColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
