import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:radionlp/Check_Connection/No%20Internet.dart';
import 'package:radionlp/Home_Page/HomePage.dart';
import 'package:radionlp/Home_Page/HomePage2.dart';
import 'package:radionlp/Home_Page/HomePage3.dart';

// final String url;

class Nav_bar extends StatefulWidget {
  // Nav_bar({Key? key, required this.url}) : super(key: key);

  @override
  _Nav_barState createState() => _Nav_barState();
}

class _Nav_barState extends State<Nav_bar> {

  int checkInt = 0;
  late ConnectivityResult previous;
  InAppWebViewController? _webViewController;

  double progress = 0;
  String url = '';

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        useOnDownloadStart: true,
      ),
      android: AndroidInAppWebViewOptions(
        initialScale: 100,
        useShouldInterceptRequest: true,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();




  int _selectedIndex = 1;
  List<Widget> _widgetOptions = <Widget>[
    HomePageX(url: 'http://www.radiopnl.org/'),
    HomePage(url: 'http://www.nlpradio.org/'),
    HomePageXX(url: 'http://www.radionlp.org/'),

 ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;


      print('${index}');
    });
  }




  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.yellow[800]),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController?.reload();
        } else if (Platform.isIOS) {
          _webViewController?.loadUrl(
              urlRequest: URLRequest(url: await _webViewController?.getUrl()));
        }
      },
    );


    Connectivity().onConnectivityChanged.listen((
        ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => No_Internet_Connection()), (
            route) => false);
      } else if (previous == ConnectivityResult.none) {
        // internet conn
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => No_Internet_Connection()), (
            route) => false);
      }

      previous = connresult;
    });
  }


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Do you want to exit Radio NLP ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'No',
              style: TextStyle(color: Colors.green[800]),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text(
              'Yes',
              style: TextStyle(color: Colors.red[800]),
            ),
          ),
        ],
      ),
    )) ??
        false;
  }



  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white70
    ));

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(38, 38, 38, 1),
          title:
                Text(
                  'Radio NLP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),


          actions: <Widget>[
            IconButton(
              onPressed: () {
                _webViewController?.goBack();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                _webViewController?.reload();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,

              ),

            ),
            IconButton(
              onPressed: () {
                _webViewController?.goForward();
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),

            SizedBox(width: 10),
          ],
        ),

        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Color.fromRGBO(38,38,38, 1),
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                icon: Icon(Icons.g_translate),
                title: Text("Spanish"),
                activeColor: Colors.white,
                inactiveColor: Colors.black54),
            BottomNavyBarItem(
                icon: Icon(Icons.dashboard_rounded),
                title: Text("English"),
                activeColor: Colors.white,
                inactiveColor: Colors.black54),
            BottomNavyBarItem(
                icon: Icon(Icons.g_translate),
                title: Text("فارسی"),
                activeColor: Colors.white,
                inactiveColor: Colors.black54),
          ],
        ),



      ),
    );
  }
}
