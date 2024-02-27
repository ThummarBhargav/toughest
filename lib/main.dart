import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
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
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await GdprDialog.instance
      .showDialog(isForTest: false, testDeviceId: '')
      .then((onValue) {
    print('result === $onValue');
  });
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

RxBool appOpen = false.obs;
RxBool banner = false.obs;
RxBool interstitial = false.obs;
RxBool native = false.obs;
bool appOpenAdRunning = false;
RxBool interStitialAdRunning = false.obs;
RxString AppOpenID = "".obs;
RxString BannerID = "".obs;
RxString InterstitialID = "".obs;
RxString NativeID = "".obs;
RxString androidAdsId = "".obs;
RxString iOSAdsId = "".obs;
RxInt interShowTime = 0.obs;
RxInt appOpenShowTime = 0.obs;
RxBool adaptiveBannerSize = false.obs;

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
