// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thesocial/const/colors.dart';
import 'package:thesocial/screens/altProfile/altProfileWidget.dart';
import 'package:thesocial/screens/feed/feedWidget.dart';
import 'package:thesocial/screens/home/home_page_services.dart';
import 'package:thesocial/screens/landingPage/landingServices.dart';
import 'package:thesocial/screens/landingPage/landingUtils.dart';
import 'package:thesocial/screens/landingPage/landingWidget.dart';
import 'package:thesocial/screens/profile/profile_services.dart';
import 'package:thesocial/screens/splash_screen/splash_screen.dart';
import 'package:thesocial/services/authentication.dart';
import 'package:thesocial/services/firebaseServices.dart';
import 'package:thesocial/utils/postOption.dart';
import 'package:thesocial/utils/uploadPost.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ConstColors constColors = ConstColors();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AltProfileWidget()),
        ChangeNotifierProvider(create: (_) => PostFunctions()),
        ChangeNotifierProvider(create: (_) => FeedWidget()),
        ChangeNotifierProvider(create: (_) => UploadPost()),
        ChangeNotifierProvider(create: (_) => HomePageServices()),
        ChangeNotifierProvider(create: (_) => ProfileServices()),
        ChangeNotifierProvider(create: (_) => FirebaseServices()),
        ChangeNotifierProvider(create: (_) => LandingUtils()),
        ChangeNotifierProvider(create: (_) => LandingService()),
        ChangeNotifierProvider(create: (_) => Authentication()),
        ChangeNotifierProvider(create: (_) => LandingWidgets())
      ],
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: constColors.blueColor,
          fontFamily: 'Poppins',
          canvasColor: Colors.transparent,
        ),
      ),
    );
  }
}
