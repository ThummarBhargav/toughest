import 'package:flutter/material.dart';
import 'package:toughest_new/ui/home.dart';

import '../constants/AdsManager/app_lifecycle_reactor.dart';
import '../constants/AdsManager/app_open_ad_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppLifecycleReactor? appLifecycleReactor;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
      appLifecycleReactor =
          AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
      if (appLifecycleReactor != null) {
        appLifecycleReactor!.listenToAppStateChanges();
      }
    });
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset(
        'assets/images/spalsh screen.png',
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
