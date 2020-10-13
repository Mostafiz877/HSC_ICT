import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class PlayvideoScreen extends StatefulWidget {
  //this is for git checking
  static const routeName = '/playvideo';

  @override
  _PlayvideoScreenState createState() => _PlayvideoScreenState();
}

class _PlayvideoScreenState extends State<PlayvideoScreen> {
  bool isInternetConnetion = true;
  @override
  void initState() {
    checkINternet();

    super.initState();
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

  bool isLoading = true;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    var islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final indexAndvideolist =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    final index = indexAndvideolist[0];
    final videoList = indexAndvideolist[1];
    final videoLink = videoList[index]['link'];
    final satckOfVideo = Stack(
      children: <Widget>[
        WebView(
          key: _key,
          onPageFinished: (finish) {
            setState(() {
              isLoading = false;
            });
          },
          initialUrl: Uri.dataFromString(
                  '<html><head><style>body{margin:0;padding:0;}</style></head><body bgcolor="#18191A">$videoLink</body></html>',
                  mimeType: 'text/html')
              .toString(),
          javascriptMode: JavascriptMode.unrestricted,
        ),
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(),
      ],
    );
    final appBar = PreferredSize(
      preferredSize:
          islandscape ? Size.fromHeight(35.0) : Size.fromHeight(50.0),
      child: AppBar(
        backgroundColor: Color(0xff242526),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.skip_previous,
                color: (index - 1) >= 0 ? Colors.white : Colors.blueGrey),
            onPressed: (index - 1) >= 0
                ? () {
                    Navigator.of(context).pushReplacementNamed(
                        PlayvideoScreen.routeName,
                        arguments: [
                          index - 1,
                          videoList,
                        ]);
                    // do something
                  }
                : null,
          ),
          IconButton(
            icon: Icon(
              Icons.skip_next,
              color: (index + 1) < videoList.length
                  ? Colors.white
                  : Colors.blueGrey,
            ),
            onPressed: index + 1 < videoList.length
                ? () {
                    Navigator.of(context).pushReplacementNamed(
                        PlayvideoScreen.routeName,
                        arguments: [
                          index + 1,
                          videoList,
                        ]);

                    // do something
                  }
                : null,
          ),
          IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            onPressed: () {
              listInModal(context, videoList, index);

              // do something
            },
          ),
          islandscape
              ? IconButton(
                  icon: Icon(
                    Icons.fullscreen_exit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    SystemChrome.setEnabledSystemUIOverlays(
                        SystemUiOverlay.values);

                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.fullscreen,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // SystemChrome.setEnabledSystemUIOverlays(
                    //     SystemUiOverlay.values);

                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.landscapeLeft,
                    ]);
                    SystemChrome.setEnabledSystemUIOverlays([]);
                  },
                ),
        ],
      ),
    );

    var deviceHeight = (MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top) *
        1;

    var deviceWidth = islandscape
        ? deviceHeight * 1.77
        : MediaQuery.of(context).size.width * 1;

    return WillPopScope(
      onWillPop: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

        Navigator.of(context).pop();
        return null;
      },
      child: Scaffold(
        backgroundColor: Color(0xff18191A),
        appBar: appBar,
        body: isInternetConnetion
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black),
                      ),
                  width: deviceWidth,
                  child: satckOfVideo,
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "No internet connection!",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20.0),
                    FlatButton(
                      color: Colors.black87,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Back to playlist",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  void listInModal(context, var videoList, int outsideIndex) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return ListView.builder(
            itemBuilder: (cxt, index) {
              return Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      enabled: true,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed(
                            PlayvideoScreen.routeName,
                            arguments: [
                              index,
                              videoList,
                            ]);
                      },
                      leading: index == outsideIndex
                          ? Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                            )
                          : Icon(
                              Icons.ondemand_video,
                              color: Colors.transparent,
                            ),
                      title: Text(
                        videoList[index]['title'],
                        style: TextStyle(color: Colors.black87),
                      ),
                      trailing: Text(
                        videoList[index]['duration'],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              );
            },
            itemCount: videoList.length,
          );
        });
  }
}
