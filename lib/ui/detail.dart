import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toughest_new/ui/showDetail.dart';
import 'dart:convert';

import '../commons/textStyle.dart';
import '../constants/AdsManager/ad_services.dart';
import '../main.dart';
import '../models/items.dart';

class Detail extends StatelessWidget {
  final data, title;
  Detail({this.data, this.title});

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
        appBar: AppBar(
          elevation: 20.0,
          backgroundColor: Color(0xff1764db),
          title: Text(
            'Questions',
          ),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Flexible(
              child: Container(
                child: buildListItems(),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: <Color>[
                    new Color(0xFF2343DC),
                    new Color(0xFF0969CF),
                    new Color(0xFF2577ED),
                    new Color(0xFF12B6D3),
                    new Color(0xFF01B7DC),
                  ],
                  // stops: [1.0,1.0,0.9],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                )),
              ),
            ),
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

  //our list of questions type.
  List list() {
    String type;
    if (title == 'Behavioural Based') {
      type = "Behaviour";
    } else if (title == 'Communications Based') {
      type = "Communication";
    } else if (title == 'Opinion Based') {
      type = "Opinion";
    } else if (title == 'Performance Based') {
      type = "Performance";
    } else {
      type = "Brainteasures";
    }
    var list;
    list = data[type] as List;
    print(list);
    List<Item> typeList = list.map((i) => Item.fromJson(i)).toList();
    return typeList;
  }

  share(String title) {
    Share.share("Answer this question\n\n" + title);
  }

  ///Takes the local json file,
  ///because that contains, Q/A data.
  _retrieveLocalData() async {
    return await rootBundle.loadString('assets/local.json');
  }

  ///take the asset and decode json file.
  Future<List<Item>> loadData() async {
    late ItemList itemList;
    try {
      String type;

      if (title == 'Behavioural Based') {
        type = "Behaviour";
      } else if (title == 'Communications Based') {
        type = "Communication";
      } else if (title == 'Opinion Based') {
        type = "Opinion";
      } else if (title == 'Performance Based') {
        type = "Performance";
      } else {
        type = "Brainteasures";
      }
      String jsonString = await _retrieveLocalData();
      final jsonResponse = json.decode(jsonString);
      final jsonData = jsonResponse[type];
      itemList = ItemList.fromJson(jsonData);
    } catch (e) {
      print(e);
    }
    return itemList.list;
  }

  ///List of questions uses futurBuilder.
  Widget buildListItems() {
    return FutureBuilder(
      future: loadData(),
      builder: (context, AsyncSnapshot<List<Item>> snapshot) {
        if (!snapshot.hasData)
          return Center(child: new CircularProgressIndicator());
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, i) {
            String quest, ans;
            quest = snapshot.data![i].question;
            ans = snapshot.data![i].answer;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      quest,
                      style: Style.commonTextStyle,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Color(0xFF56cfdf),
                      ),
                      iconSize: 18.0,
                      onPressed: () => share(quest),
                    ),
                    onTap: () async {
                      if (getIt<AdService>().bannerAd != null) {
                        await getIt<AdService>().bannerAd!.dispose();
                        await getIt<AdService>().initBannerAds(context);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowDetail(
                                quest: quest,
                                ans: ans,
                              )));
                    },
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Divider(
                        color: Colors.white,
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
