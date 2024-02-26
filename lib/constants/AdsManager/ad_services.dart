// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:toughest_new/constants/api_constants.dart';
import 'package:toughest_new/main.dart';

class AdService {
  static RxBool isVisible = false.obs;
  BannerAd? bannerAd;
  bool isBannerLoaded = false;
  InterstitialAd? interstitialAds;
  AnchoredAdaptiveBannerAdSize? size;

  // BannerAds
  initBannerAds(context) async {
    isVisible.value = banner;
    if (isVisible.isTrue) {
      size = await anchoredAdaptiveBannerAdSize(context);

      bannerAd = BannerAd(
          size: (adaptiveBannerSize)
              ? size!
              : AdSize.banner,
          adUnitId: BannerID.toString().trim(),
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              isBannerLoaded = true;
            },
            onAdFailedToLoad: (ad, error) {
              print('Ad load failed (code=${error.code} message=${error.message})');
              ad.dispose();
              initBannerAds(context);
            },
          ),
          request: AdRequest())
        ..load();
    }
  }

  Widget getBannerAds() {
    return SizedBox(
      width: bannerAd!.size.width.toDouble(),
      height: bannerAd!.size.height.toDouble(),
      child: bannerAd != null ? AdWidget(ad: bannerAd!) : SizedBox(),
    );
  }

  // InterstitialAds Load & Show
  showInterstitialAd() {
    isVisible.value = interstitial;
    if (isVisible.isTrue) {
      interStitialAdRunning = true;
      if (interStitialAdRunning == true) {
        interstitialAds?.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (ad) =>
              print('Ad showed fullscreen content.'),
          onAdDismissedFullScreenContent: (ad) {
            box.write(ArgumentConstant.isStartTime, DateTime.now().millisecondsSinceEpoch.toString());
            interstitialAds?.dispose();
            interStitialAdRunning = false;
            loadInterstitialAd();
            print('Ad dismissed fullscreen content.');
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            interStitialAdRunning = false;
            print('Ad failed to show fullscreen content: $error');
          },
        );
        interstitialAds?.show();
      } else {
        print('Interstitial ad is not loaded yet.');
        loadInterstitialAd(); // Load a new ad if not already loaded
      }
    }
  }

  loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: InterstitialID.toString().trim(),
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAds = ad;
        },
        onAdFailedToLoad: (error) {
          interStitialAdRunning = false;
          print('InterstitialAd failed to load: $error');
          print("InterstitialID:-  " + InterstitialID.toString().trim());
        },
      ),
    );
  }

  // Get Difference Time For Interstitial
  getDifferenceTime() {
    if (box.read(ArgumentConstant.isStartTime) != null) {
      String startTime = box.read(ArgumentConstant.isStartTime).toString();
      String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      int difference = int.parse(currentTime) - int.parse(startTime);
      print("Difference := $difference");
      print("StartTime := $startTime");
      print("currentDate := $currentTime");
      int differenceTime = difference ~/ 1000;
      if (differenceTime > interShowTime) {
        showInterstitialAd();
      }
    }
  }

  // Get Difference Time For AppOpen
  bool getDifferenceAppOpenTime() {
    if (box.read(ArgumentConstant.isAppOpenStartTime) != null) {
      String startTime = box.read(ArgumentConstant.isAppOpenStartTime).toString();
      String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      int difference = int.parse(currentTime) - int.parse(startTime);
      print("Difference := $difference");
      print("StartTime := $startTime");
      print("currentDate := $currentTime");
      int differenceTime = difference ~/ 1000;
      if (differenceTime > appOpenShowTime) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // Dispose
  dispose() {
    bannerAd?.dispose().then((value) => isBannerLoaded = false);
  }
}

Future<AnchoredAdaptiveBannerAdSize?> anchoredAdaptiveBannerAdSize(context) async {
  return await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.of(context).size.width.toInt());
}