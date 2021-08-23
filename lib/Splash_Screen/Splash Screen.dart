import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:radionlp/Check_Connection/No%20Internet.dart';
import 'package:radionlp/Check_Connection/check_internet.dart';
import 'package:radionlp/Home_Page/HomePage.dart';
import 'package:radionlp/Page_Controller/Pages_With_Bottom_Navbar.dart';
import 'package:radionlp/Push%20Notification/pushNotification.dart';


class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {

  FirebaseNotifcation? firebase;
  handleAsync() async {
    await firebase!.initialize();
    String? token = await firebase!.getToken();
    print("Firebase token : $token");
  }

  int checkInt = 0;

  @override
  void initState() {
    super.initState();
    firebase = FirebaseNotifcation();
    handleAsync();

    Future<int> a = CheckInternet().checkInternetConnection();
    a.then((value) {
      if (value == 0) {
        setState(() {
          checkInt = 0;
        });
        print('No internet connect');
        Timer(
            Duration(seconds: 2),
                () =>
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => No_Internet_Connection()),
                        (route) => false));
      } else {
        setState(() {
          checkInt = 1;
        });
        Timer(
            Duration(seconds: 30),
                () =>
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Nav_bar()),
                        (route) => false));

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.white
    // ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Container(
                height: 200,
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    "assets/logo.png",
                  ),
                )),
          ),
          Text("Radio NLP",
              style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.black)),
          SizedBox(
            height: 85,
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget> [


              SizedBox(width: 1,),

              Container(
                height: 70,
                width: 100,
                child: GlowButton(child: Text("Spanish",style: TextStyle(color: Colors.white),),color: Colors.black,glowColor: Colors.black54, onPressed: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(url: 'http://www.radiopnl.org/')),
                          (route) => false);
                }),
              ),

              Container(
                height: 70,
                width: 100,
                child: GlowButton(child: Text("English",style: TextStyle(color: Colors.white),),color: Colors.black,glowColor: Colors.black54, onPressed: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(url: 'http://www.nlpradio.org/')),
                          (route) => false);
                }),
              ),

              Container(
                height: 70,
                width: 100,
                child: GlowButton(child: Text("فارسی",style: TextStyle(color: Colors.white),),color: Colors.black,glowColor: Colors.black54, onPressed: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(url: 'http://www.radionlp.org/')),
                          (route) => false);
                }),

              ),

              SizedBox(width: 1,),



            ],

          ),


          SizedBox(height: 60,),

          SpinKitSquareCircle(
            color: Colors.black,
            size: 25.0,
            controller: AnimationController(
                duration: const Duration(milliseconds: 1300), vsync: this),
          ),



        ],
      ),
    );
  }
}
