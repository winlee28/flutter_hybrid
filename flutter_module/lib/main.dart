import 'package:flutter/material.dart';
import 'dart:ui';

void main() => runApp(MyApp(
      //通过window.defaultRouteName获取从native传递过来的参数
      initParams: window.defaultRouteName,
    ));

class MyApp extends StatelessWidget {
  final String initParams;

  MyApp({Key key, this.initParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter_Android_iOS混合开发',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(initParams: initParams),
    );
  }
}

class HomePage extends StatefulWidget {
  final String initParams;

  const HomePage({Key key, this.initParams}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetRoute(widget.initParams),
      ),
    );
  }
}

///路由转发
Widget _widgetRoute(String route) {
  print(route);
  switch (route) {
    case "route1":
      return route1Widget();
    case "route2":
      return route2Widget();
    default:
      return notFoundWidget();
  }
}

Widget route1Widget() {
  return Center(
    child: Text(
      "this is route1Widget",
      style: TextStyle(color: Colors.red, fontSize: 20),
    ),
  );
}

Widget route2Widget() {
  return Center(
    child: Text(
      "this is route2Widget",
      style: TextStyle(color: Colors.blue, fontSize: 20),
    ),
  );
}

Widget notFoundWidget() {
  return Center(
    child: Text(
      "未匹配到路由",
      style: TextStyle(fontSize: 40),
    ),
  );
}
