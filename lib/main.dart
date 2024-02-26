import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toughest_new/constants/api_constants.dart';
import 'package:toughest_new/constants/app_module.dart';
import 'package:toughest_new/constants/sizeConstant.dart';
import 'package:toughest_new/database/FirebaseDatabase_controller.dart';
import 'package:toughest_new/ui/splashscreen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabaseHelper().adsVisible();
  setUp();
  if (isNullEmptyOrFalse(box.read(ArgumentConstant.isStartTime))) {
    box.write(ArgumentConstant.isStartTime, 0);
  }
  if (isNullEmptyOrFalse(box.read(ArgumentConstant.isAppOpenStartTime))) {
    box.write(ArgumentConstant.isAppOpenStartTime, 0);
  }
  runApp(Home());
}

bool appOpen = false;
bool banner = false;
bool interstitial = false;
bool appOpenAdRunning = false;
bool interStitialAdRunning = false;
String AppOpenID = "";
String BannerID = "";
String InterstitialID = "";
int interShowTime = 0;
int appOpenShowTime = 0;
bool adaptiveBannerSize = false;

final box = GetStorage();
final getIt = GetIt.instance;

//ignore: must_be_immutable
class Home extends StatefulWidget {
  String? title;

  Home({this.title});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = MethodChannel('samples.flutter.dev/firebase');

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        await platform.invokeMethod('setId').then((value) async {
          if (value == "Success") {
            await MobileAds.instance.initialize();
            MobileAds.instance.updateRequestConfiguration(
              RequestConfiguration(
                tagForChildDirectedTreatment:
                    TagForChildDirectedTreatment.unspecified,
                testDeviceIds: kDebugMode
                    ? [
                        "921ECDEF8D5D6B5B6CD6F3BC93FF97D7",
                        "DD9CCC2321C6DDFC5D8E4B67B469A4A7",
                      ]
                    : [],
              ),
            );
          }
        });
      } on PlatformException catch (e) {
        print(e);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Josefin Sans',
        appBarTheme: AppBarTheme(
          centerTitle: false,
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
