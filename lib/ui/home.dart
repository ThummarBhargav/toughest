import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toughest_new/constants/AdsManager/ad_services.dart';
import 'package:toughest_new/constants/AdsManager/app_lifecycle_reactor.dart';
import 'package:toughest_new/constants/AdsManager/app_open_ad_manager.dart';
import 'package:toughest_new/main.dart';
import 'package:toughest_new/ui/detail.dart';
import 'package:toughest_new/commons/textStyle.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  var data;
  final GlobalKey<ScaffoldState> _sideMenuKey = GlobalKey<ScaffoldState>();
  AppLifecycleReactor? appLifecycleReactor;
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'interview.preparation.question.answer',
    appStoreIdentifier: '6478487364',
  );
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Ads Loading
      await getIt<AdService>().initBannerAds(context);
      await getIt<AdService>().loadInterstitialAd();
      AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
      appLifecycleReactor =
          AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
      if (appLifecycleReactor != null) {
        appLifecycleReactor!.listenToAppStateChanges();
      }

      bool shouldShow = await shouldShowPopup();
      if (shouldShow) {
        rateMyApp.init().then((value) {
          ShowRateUsPopup();
        });
      }
      final info = await PackageInfo.fromPlatform();
      packageInfo = info;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return UpgradeAlert(
      child: Scaffold(
        key: _sideMenuKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  new Color(0xFF2343DC),
                  new Color(0xFF01B7DC),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 1.0),
              ),
            ),
            child: AppBar(
              elevation: 10.0,
              actions: [
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    _sideMenuKey.currentState!.openEndDrawer();
                  },
                ),
              ],
              backgroundColor: Colors.transparent,
              title: Text('Smart Learning - Skill Growth'),
            ),
          ),
        ),
        endDrawer: Drawer(
          child: Container(
            color: Colors.blue,
            child: buildMenu(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                key: Key('banner'),
                padding: EdgeInsets.only(bottom: 5.0),
                height: height / 3,
                child: myCarousel,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (getIt<AdService>().bannerAd != null) {
                          await getIt<AdService>().bannerAd!.dispose();
                          await getIt<AdService>().initBannerAds(context);
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Detail(
                                  title: 'Behavioural Based',
                                )));
                      },
                      child: Image.asset(
                        'assets/images/Behavioural Based.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (getIt<AdService>().bannerAd != null) {
                          await getIt<AdService>().bannerAd!.dispose();
                          await getIt<AdService>().initBannerAds(context);
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Detail(
                                  title: 'Situational Based',
                                )));
                      },
                      child: Image.asset(
                        'assets/images/communications Based.png',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (getIt<AdService>().bannerAd != null) {
                          await getIt<AdService>().bannerAd!.dispose();
                          await getIt<AdService>().initBannerAds(context);
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Detail(
                                  title: 'Opinion Based',
                                )));
                      },
                      child: Image.asset(
                        'assets/images/opinion Based.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        if (getIt<AdService>().bannerAd != null) {
                          await getIt<AdService>().bannerAd!.dispose();
                          await getIt<AdService>().initBannerAds(context);
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Detail(
                                  title: 'Performance Based',
                                )));
                      },
                      child: Image.asset(
                        'assets/images/performance Based.png',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Detail(
                            title: 'Brainteasers',
                          )));
                },
                child: Image.asset(
                  'assets/images/Brainteasers.png',
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => (banner.value == true)
              ? getIt<AdService>().isBannerLoaded == true
                  ? getIt<AdService>().getBannerAds()
                  : SizedBox()
              : SizedBox(),
        ),
      ),
    );
  }

  ///creating a carousel using carousel pro library.
  final myCarousel = CarouselSlider(
    options: CarouselOptions(
      height: 400.0,
      autoPlay: true,
      autoPlayCurve: Curves.easeInOut,
      autoPlayAnimationDuration: Duration(seconds: 2),
    ),
    items: [
      Image.asset('assets/images/card1.png'),
      Image.asset('assets/images/card3.png'),
      Image.asset('assets/images/card4.png'),
      Image.asset('assets/images/card2.png'),
    ],
  );

  buildMenu() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: Text('Share the App', style: Style.drawerTextStyle),
            leading: Icon(Icons.share, color: Colors.white),
            onTap: () => _sharer(),
          ),
          ListTile(
            title: Text('Rate Us', style: Style.drawerTextStyle),
            leading: Icon(Icons.star_rate, color: Colors.white),
            onTap: () => _rateUs(),
          ),
          ListTile(
            title: Text('Privacy Policy', style: Style.drawerTextStyle),
            leading: Icon(Icons.privacy_tip, color: Colors.white),
            onTap: () => _privacyPolicy(),
          ),
          ListTile(
            title: Text('More App', style: Style.drawerTextStyle),
            leading: Icon(Icons.apps, color: Colors.white),
            onTap: () => _moreApp(),
          ),
          Spacer(),
          Text("Version Name: " + packageInfo.version,
              style: Style.drawerTextStyle),
        ],
      ),
    );
  }

  _sharer() {
    if (Platform.isIOS) {
      Share.share(
          "Skills 101/Smart Learning - Skill Growth - Test your knowledge.\n" +
              "The app that will make you an amazing candidate for any job.\n"
                  "Are you ready?\n"
                  "Download it now\n"
                  "https://apps.apple.com/in/app/smart-learning-skill-growth/id6478487364");
    } else {
      Share.share(
          "Skills 101/Smart Learning - Skill Growth - Test your knowledge.\n" +
              "The app that will make you an amazing candidate for any job.\n"
                  "Are you ready?\n"
                  "Download it now\n"
                  "https://play.google.com/store/apps/details?id=interview.preparation.question.answer");
    }
    Navigator.pop(context);
  }

  _moreApp() async {
    final Uri _url = Uri.parse((Platform.isIOS)
        ? "https://apps.apple.com/in/developer/deep-jerajbhai-davara/id1683267123?see-all=i-phonei-pad-apps"
        : 'https://play.google.com/store/apps/developer?id=UniqueApp+Technologies&hl=en-IN');
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
    Navigator.pop(context);
  }

  _rateUs() {
    rateMyApp.init().then((value) {
      rateMyApp.launchStore();
      Navigator.pop(context);
    });
  }

  Future<bool> shouldShowPopup() async {
    String lastDisplayDate = box.read("lastDisplayDate") ?? "";
    if (lastDisplayDate.isEmpty) {
      String currentDate = DateTime.now().toString();
      box.write("lastDisplayDate", currentDate);
      return true;
    } else {
      DateTime currentDate = DateTime.now();
      DateTime lastDate = DateTime.parse(lastDisplayDate);
      int differenceInDays = currentDate.difference(lastDate).inDays;
      if (differenceInDays >= 7) {
        box.write("lastDisplayDate", currentDate.toString());
        return true;
      } else {
        return false;
      }
    }
  }

  ShowRateUsPopup() {
    rateMyApp.showRateDialog(
      context,
      title: 'Rate this app',
      message:
          'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
      rateButton: 'RATE',
      noButton: 'NO THANKS',
      laterButton: 'MAYBE LATER',
      listener: (button) {
        switch (button) {
          case RateMyAppDialogButton.rate:
            print('Clicked on "Rate".');
            break;
          case RateMyAppDialogButton.later:
            print('Clicked on "Later".');
            break;
          case RateMyAppDialogButton.no:
            print('Clicked on "No".');
            break;
        }
        return true;
      },
      ignoreNativeDialog: Platform.isAndroid,
      dialogStyle: DialogStyle(),
      onDismissed: () =>
          rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
    );
  }

  _privacyPolicy() async {
    final Uri _url = Uri.parse(
        'https://sites.google.com/view/uniqueapp-privacy-policy/policy');
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
    Navigator.pop(context);
  }
}
