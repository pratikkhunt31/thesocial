// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/landingPage/landingServices.dart';

class LandingUtils extends ChangeNotifier {
  ConstColors constColors = ConstColors();

  final picker = ImagePicker();
  File? userImage;

  File? get getUserImage => userImage;
  String? userImgUrl;

  String? get getUserImgUrl => userImgUrl;

  Future pickUserImage(BuildContext context, ImageSource source) async {
    final pickUserImage = await picker.pickImage(source: source);
    pickUserImage == null
        ? print('Select image')
        : userImage = File(pickUserImage.path);
    print(userImage?.path);

    userImage != null
        ? Provider.of<LandingService>(context, listen: false)
            .showUserImage(context)
        : print('Image upload Error!');

    notifyListeners();
  }

  Future selectAvatarOptionSheet(BuildContext context) async {
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
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () {
                        pickUserImage(context, ImageSource.gallery)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<LandingService>(context, listen: false)
                              .showUserImage(context);
                        });
                      },
                    ),
                    MaterialButton(
                      color: constColors.blueColor,
                      child: Text(
                        'Camera',
                        style: TextStyle(
                          color: constColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () {
                        pickUserImage(context, ImageSource.camera)
                            .whenComplete(() {
                          Navigator.pop(context);
                          Provider.of<LandingService>(context, listen: false)
                              .showUserImage(context);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
