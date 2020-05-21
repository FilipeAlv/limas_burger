import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:limas_burger/main.dart';
import 'package:limas_burger/util/util.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(Splash()));
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Serra China',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Serra China'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: AfterSplash(),
      title: Text(
        'Bem vindo',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: MyColors.secondaryColor),
      ),
      image: Image.asset('assets/images/logo_400-400-red.png'),
      photoSize: 150.0,
      loaderColor: MyColors.secondaryColor,
    );
  }
}

class AfterSplash extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return LimasBurger.getInstance();
  }
}
