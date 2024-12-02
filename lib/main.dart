import 'package:EDS/src/feacture/home/home_scren.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



void main() {
  runApp(MyApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp( MyApp());
  });
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App QR BI de Angola',
      theme: ThemeData(
       useMaterial3: true,
       primaryColorDark: Colors.black,
       primaryColorLight: Colors.black
      ),
      home: HomeScreen(),
    );
  }
}
