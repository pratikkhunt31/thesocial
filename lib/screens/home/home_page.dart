// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/chatRoom/chatRoom.dart';
import 'package:thesocial/screens/feed/feed.dart';
import 'package:thesocial/screens/home/home_page_services.dart';
import 'package:thesocial/screens/profile/profile.dart';
import 'package:thesocial/services/firebaseServices.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConstColors constColors = ConstColors();
  final PageController homepageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    Provider.of<FirebaseServices>(context, listen: false).initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constColors.darkColor,
      body: PageView(
        controller: homepageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
        children: [Feed(), Chatroom(), Profile()],
      ),
      bottomNavigationBar: Provider.of<HomePageServices>(context, listen: false)
          .bottomNavBar(context, pageIndex, homepageController),
    );
  }
}
