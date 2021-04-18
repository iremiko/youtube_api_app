import 'package:flutter/material.dart';
import 'package:youtube_app/pages/channel/channel_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFE62117, color);
    return MaterialApp(
      title: 'Youtube App',
      theme: ThemeData(
          primarySwatch: colorCustom,
          backgroundColor: Colors.white,
          textTheme: TextTheme(
            headline6: TextStyle(fontSize: 18, color: Colors.black87),
            subtitle1: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            subtitle2: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            bodyText1: TextStyle(fontSize: 14, color: Colors.black45),
            bodyText2: TextStyle(fontSize: 14, color: Colors.black87),
            caption: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          iconTheme: IconThemeData(
            color: colorCustom,
          )),
      home: ChannelPage(),
    );
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(230, 33, 23, .1),
  100: Color.fromRGBO(230, 33, 23, .2),
  200: Color.fromRGBO(230, 33, 23, .3),
  300: Color.fromRGBO(230, 33, 23, .4),
  400: Color.fromRGBO(230, 33, 23, .5),
  500: Color.fromRGBO(230, 33, 23, .6),
  600: Color.fromRGBO(230, 33, 23, .7),
  700: Color.fromRGBO(230, 33, 23, .8),
  800: Color.fromRGBO(230, 33, 23, .9),
  900: Color.fromRGBO(230, 33, 23, 1),
};
