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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white),
        ),
        image: Image.asset('assets/images/logo_serra.png'),
        photoSize: 200.0,
        backgroundColor: MyColors.secondaryColor,
        loaderColor: Colors.white);
  }
}

class AfterSplash extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return new LimasBurger();
  }
}
