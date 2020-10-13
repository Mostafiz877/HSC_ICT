import 'package:flutter/material.dart';
import './playvideo_screen.dart';
import 'package:firebase_admob/firebase_admob.dart';

class PlaylistScreen extends StatefulWidget {
  static const routeName = '/playlist';

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'game',
      'software',
      'hosting',
      'degree',
      'groceries',
      'computer',
      'health',
      'website',
      'Electronics'
    ],
    childDirected: true,
    nonPersonalizedAds: true,
  );

  BannerAd myBanner;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: "ca-app-pub-6104141650729462/6547226350",
        // adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6104141650729462~2357889277");
    myBanner = buildBannerAd()..load();

    super.initState();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;

    var videoList = arguments[0];
    final titleinfo = arguments[1];

    return Scaffold(
      backgroundColor: Color(0xffF0F2F5),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Color(0xffFFFFFF),
        centerTitle: true,
        title: Text(
          titleinfo,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemBuilder: (cxt, index) {
            return Container(
              child: Column(
                children: <Widget>[
                  Ink(
                    padding: EdgeInsets.symmetric(vertical: 9),
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                        if (myBanner != null) {
                          myBanner.dispose();
                          myBanner = null;
                        }
                        Navigator.of(context)
                            .pushNamed(PlayvideoScreen.routeName, arguments: [
                          index,
                          videoList,
                        ]);
                      },
                      leading: Icon(
                        Icons.play_circle_filled,
                        color: Color(0xffF02849),
                      ),
                      title: Text(
                        videoList[index]['title'],
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Text(
                        videoList[index]['duration'],
                        style: TextStyle(
                          color: Color(0xff606266),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: videoList.length,
        ),
      ),
    );
  }
}
