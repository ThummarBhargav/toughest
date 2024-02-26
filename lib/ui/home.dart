import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:toughest_new/constants/AdsManager/ad_services.dart';
import 'package:toughest_new/constants/AdsManager/app_lifecycle_reactor.dart';
import 'package:toughest_new/constants/AdsManager/app_open_ad_manager.dart';
import 'package:toughest_new/main.dart';
import 'package:toughest_new/ui/detail.dart';
import 'package:toughest_new/commons/textStyle.dart';
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
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
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
            title: Text('Smart skills Learn and Grow'),
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
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text('Share the App', style: Style.drawerTextStyle),
              leading: const Icon(Icons.share, color: Colors.white),
              onTap: () => _sharer(),
            ),
            ListTile(
              title: Text('More App', style: Style.drawerTextStyle),
              leading: const Icon(Icons.bug_report, color: Colors.white),
              onTap: () => _moreApp(),
            ),
          ],
        ));
  }

  _sharer() {
    Share.share("Skills 101/Smart skills Learn and Grow - Test your knowledge.\n" +
        "The app that will make you an amazing candidate for any job.\n"
            "Are you ready?\n"
            "Download it now\n"
            "https://play.google.com/store/apps/details?id=interview.preparation.question.answer");
  }

  _moreApp() async {
    final Uri _url = Uri.parse(
        'https://play.google.com/store/apps/developer?id=UniqueApp+Technologies&hl=en-IN');
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
