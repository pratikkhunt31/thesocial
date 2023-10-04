// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/feed/feedWidget.dart';
import 'package:thesocial/utils/uploadPost.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    ConstColors constColors = ConstColors();

    return Scaffold(
      // backgroundColor: constColors.blueGreyColor,
      drawer: Drawer(),
      appBar: AppBar(
        backgroundColor: constColors.darkColor.withOpacity(0.6),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<UploadPost>(context, listen: false)
                    .selectPostImageType(context);
              },
              icon: Icon(
                Icons.camera_enhance_rounded,
                color: constColors.greenColor,
              ))
        ],
        title: RichText(
          text: TextSpan(
              text: "Social ",
              style: TextStyle(
                color: constColors.whiteColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "Feed",
                  style: TextStyle(
                    color: constColors.blueColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]),
        ),
      ),
      body: Provider.of<FeedWidget>(context, listen: false).feedBody(context),
    );
  }
}
