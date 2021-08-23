import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:radionlp/Check_Connection/No%20Internet.dart';

class HomePageXX extends StatefulWidget {
  final String url;

  HomePageXX({Key? key, required this.url}) : super(key: key);

  @override
  _HomePageXXState createState() => _HomePageXXState();
}

class _HomePageXXState extends State<HomePageXX> {
  int checkInt = 0;
  late ConnectivityResult previous;



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










  InAppWebViewController? _webViewController;

  String url = '';

  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        useShouldOverrideUrlLoading: true,
        useOnDownloadStart: true,
        supportZoom: false,
      ),
      android: AndroidInAppWebViewOptions(
        initialScale: 100,
        useShouldInterceptRequest: true,
        displayZoomControls: false,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  final urlController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

          Expanded(
            child: InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: Uri.parse(widget.url),
                headers: {},
              ),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  // this.progress = progress / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
          ),
        ],
      ),
    );

    //   Scaffold(
    //   // appBar: AppBar(
    //   //   backgroundColor: Color.fromRGBO(243, 215, 171, 1),
    //   //   title: Shimmer.fromColors(
    //   //     baseColor: Colors.lightGreen,
    //   //     highlightColor: Color.fromRGBO(255, 146, 72, 1),
    //   //     child: Column(
    //   //       children: [
    //   //         Text(
    //   //           'Ghanaphy',
    //   //           textAlign: TextAlign.center,
    //   //           style: TextStyle(
    //   //             fontSize: 22.0,
    //   //             fontFamily: "Poppins",
    //   //             fontWeight: FontWeight.bold,
    //   //           ),
    //   //         ),
    //   //       ],
    //   //     ),
    //   //   ),
    //   //   actions: <Widget>[
    //   //     IconButton(
    //   //       onPressed: () {
    //   //         _webViewController?.goBack();
    //   //       },
    //   //       icon: Icon(
    //   //         Icons.arrow_back_ios,
    //   //         color: Colors.white,
    //   //       ),
    //   //     ),
    //   //     IconButton(
    //   //       onPressed: () {
    //   //         _webViewController?.reload();
    //   //       },
    //   //       icon: Icon(
    //   //         Icons.refresh,
    //   //         color: Colors.white,
    //   //
    //   //       ),
    //   //
    //   //     ),
    //   //     IconButton(
    //   //       onPressed: () {
    //   //         _webViewController?.goForward();
    //   //       },
    //   //       icon: Icon(
    //   //         Icons.arrow_forward_ios,
    //   //         color: Colors.white,
    //   //       ),
    //   //     ),
    //   //
    //   //     SizedBox(width: 10),
    //   //   ],
    //   // ),
    //   // floatingActionButton: FloatingActionButton(
    //   //   onPressed: () {
    //   //     _webViewController?.reload();
    //   //   },
    //   //   child: Icon(
    //   //     Icons.refresh, color: Colors.white,
    //   //
    //   //   ),
    //   //   backgroundColor: Color.fromRGBO(109, 108, 98, 1),
    //   // ),
    //   body:
    //   // bottomNavigationBar: DotNavigationBar(
    //   //   margin: EdgeInsets.only(left: 10, right: 10),
    //   //   // currentIndex: _SelectedTab.values.indexOf(_selectedTab),
    //   //   currentIndex: _selectedIndex,
    //   //   onTap: _onItemTap,
    //   //   backgroundColor: Color.fromRGBO(243, 215, 171, 1),
    //   //    dotIndicatorColor: Color.fromRGBO(243, 215, 171, 1),
    //   //   unselectedItemColor: Colors.grey,
    //   //   enableFloatingNavBar: false,
    //   //   // onTap: _handleIndexChanged,
    //   //   items: [
    //   //     /// Home
    //   //     DotNavigationBarItem(
    //   //       icon: Icon(Icons.home),
    //   //        selectedColor: Colors.white,
    //   //     ),
    //   //
    //   //     /// Likes
    //   //     DotNavigationBarItem(
    //   //       icon: Icon(Icons.message),
    //   //        selectedColor: Colors.white,
    //   //     ),
    //   //
    //   //     /// Search
    //   //     DotNavigationBarItem(
    //   //       icon: Icon(Icons.notifications),
    //   //        selectedColor: Colors.white,
    //   //     ),
    //   //
    //   //     /// Profile
    //   //     DotNavigationBarItem(
    //   //       icon: Icon(Icons.person),
    //   //        selectedColor: Colors.white,
    //   //     ),
    //   //   ],
    //   // ),
    //
    //
    // );
  }
}
