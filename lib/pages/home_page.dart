import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../screens/playlist_screen.dart';
import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInternetConnetion = true;
  List allVideoList;
  var notification;
  final databaseReference = FirebaseDatabase.instance.reference();
  bool _progressController = true;

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
    super.initState();

    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6104141650729462~2357889277");
    myBanner = buildBannerAd()..load();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  void checkINternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isInternetConnetion = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isInternetConnetion = false;
      });
    }
  }

  Future<List> readChapersData() async {
    var videolists;
    var valueToBack = await databaseReference
        .child("data")
        .child("chapters")
        .once()
        .then((DataSnapshot snapshot) {
      List<dynamic> extractedData = snapshot.value;
      videolists = extractedData;
      return videolists;
    });
    return valueToBack;
  }

  Future<String> readNotificationsData() async {
    var notification;
    var valueToBack = await databaseReference
        .child("data")
        .child("notification")
        .once()
        .then((DataSnapshot snapshot) {
      String extractedData = snapshot.value;
      notification = extractedData;
      return notification;

      // allVideoList = extractedData;
    });
    return valueToBack;
  }

  Future<dynamic> getAllInfomation() async {
    var chapters = await readChapersData();
    // await setInitialUserData(phone);
    var noti = await readNotificationsData();

    return [chapters, noti];
  }

  void _showDialog(var noti) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(
            noti,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    checkINternet();
    getAllInfomation().then((value) {
      setState(() {
        allVideoList = value[0];
        notification = value[1];
        _progressController = false;
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF0F2F5),
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Image.asset('images/logo.jpg'),
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text("Facebook Profile"),
                  trailing: Icon(
                    Icons.arrow_forward,
                  ),
                  onTap: () async {
                    const url = 'https://facebook.com/Mustafiz.ruet';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.group),
                  title: Text("Facebook Group"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () async {
                    const url = 'https://facebook.com/groups/414560019940245/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About"),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/about');
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Color(0xffFFFFFF),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
            ),
            notification == ""
                ? IconButton(
                    icon: Icon(
                      Icons.notifications_active,
                      color: Colors.transparent,
                    ),
                    onPressed: null,
                  )
                : IconButton(
                    icon: Icon(
                      Icons.notifications_active,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _showDialog(notification);
                    },
                  ),
          ],
        ),
        body: isInternetConnetion
            ? Container(
                child: _progressController
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemBuilder: (cxt, index) {
                          return Card(
                            color: Colors.white,
                            child: ListTile(
                              onTap: () {
                                if (myBanner != null) {
                                  myBanner.dispose();
                                  myBanner = null;
                                }

                                Navigator.of(context).pushNamed(
                                    PlaylistScreen.routeName,
                                    arguments: [
                                      allVideoList[index]['videolists'],
                                      allVideoList[index]['name']
                                    ]);
                              },
                              leading: Icon(
                                Icons.video_library,
                                color: Color(0xffF02849),
                              ),
                              title: Text(
                                allVideoList[index]['name'],
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                  allVideoList[index]['duration_and_lessons'],
                                  style: TextStyle(color: Color(0xff606266))),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xff606266),
                              ),
                            ),
                          );
                        },
                        itemCount: allVideoList.length == null
                            ? 0
                            : allVideoList.length,
                      ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "No internet connection!",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 20.0),
                    FlatButton(
                      color: Colors.black87,
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                      child: Text(
                        "Reload",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ));
  }
}
