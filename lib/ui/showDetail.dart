import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';
import 'package:toughest_new/commons/textStyle.dart';
import 'package:toughest_new/widgets/my_elevated_button.dart';

import '../constants/AdsManager/ad_services.dart';
import '../main.dart';

class ShowDetail extends StatefulWidget {
  final String quest, ans;
  static var randomNumber = Random();

  ShowDetail({required this.quest, required this.ans});

  static final List<Color> _colors = [
    Colors.red,
    Colors.teal,
    Colors.orange,
    Colors.green,
    Colors.pink,
    Colors.purple,
    Colors.blue,
  ];

  @override
  ShowDetailState createState() {
    return ShowDetailState();
  }
}

class ShowDetailState extends State<ShowDetail> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  share(String question, String answer) {
    Share.share("Q:" +
        question +
        "\n\n" +
        "A:" +
        answer +
        "\n\nDownload the app for more amazing Q/A\n " +
        "https://play.google.com/store/apps/details?id=interview.preparation.question.answer");
  }

  ///add details in card.
  Widget cardDetail(String text) {
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
              borderRadius: BorderRadius.circular(9.0),
              color: ShowDetail._colors[ShowDetail.randomNumber.nextInt(100) %
                  ShowDetail._colors.length],
            ),
            margin: EdgeInsets.all(8.0),
            child: Text(
              text,
              style: Style.commonTextStyle,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (getIt<AdService>().bannerAd != null) {
          await getIt<AdService>().bannerAd!.dispose();
          await getIt<AdService>().initBannerAds(context);
        }
        getIt<AdService>().getDifferenceTime();
        return await true;
      },
      child: Scaffold(
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
              backgroundColor: Colors.transparent,
              title: Text('Answer'),
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8.0),
              child: Text(
                "Question :",
                style: Style.headerTextStyle,
              ),
            ),
            cardDetail(widget.quest),
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Text(
                'Answer :',
                style: Style.headerTextStyle,
              ),
            ),
            Stack(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.ans,
                  style: Style.regularTextStyle,
                ),
              ),
              Lottie.asset(
                'assets/confetti.json',
                controller: _controller,
                repeat: false,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ]),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    new Color(0xFF2343DC),
                    new Color(0xFF01B7DC),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                ),
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: MyElevatedButton(
                padding: EdgeInsets.all(5),
                shape: BeveledRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
                splashColor: const Color(0xff382151),
                elevation: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Share answer with your friends",
                      style:
                          Style.regularTextStyle.copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.share, color: Colors.white, size: 20.0),
                  ],
                ),
                color: Colors.transparent,
                onPressed: () => share(widget.quest, widget.ans),
              ),
            ),
            SizedBox(height: 20.0),
          ],
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
}
