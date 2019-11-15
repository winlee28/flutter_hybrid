import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'dart:io';

/// 说明：
/// 三种channel的调用已经封装在了在_onPressed和initState方法中，可以通过打开相对应的注释来打开相关方法调用
/// 需要配合在MainActivity中打开相对应的方法配合调用
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
  final TextEditingController _controller = new TextEditingController();

  String showMessage = "";
  String response = "";
  int batteryLevel;
  StreamSubscription streamSubscription;

  ///BasicMessageChannel start

  // init
  static const BasicMessageChannel<String> _basicMessageChannel =
      BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());

  // receive
  void handleBasicMessageChannelReceive() {
    _basicMessageChannel
        .setMessageHandler((String message) => Future<String>(() {
              setState(() {
                showMessage = message;
              });
              return "收到Native的消息：接受成功";
            }));
  }

  //send
  void handleBasicMessageChannelSend() async {
    response = await _basicMessageChannel.send(_controller.text);
    setState(() {
      showMessage = response;
    });
  }

  ///BasicMessageChannel end

  ///MethodChannel start

  // init
  static const MethodChannel _methodChannel =
      MethodChannel("MethodChannelPlugin");

  // receive
  void handleMethodChannelReceive() {
    Future<dynamic> platformCallHandler(MethodCall call) async {
      switch (call.method) {
        case "getPlatform":
          return getPlatformName(); //调用success方法
//          return PlatformException(code: '1002',message: "出现异常"); //调用error
          break;
      }
    }

    _methodChannel.setMethodCallHandler(platformCallHandler);
//    _methodChannel.setMethodCallHandler(null); //调用notImplemented
  }

  // send
  void handleMethodChannelSend() async {
    try {
      response = await _methodChannel.invokeMethod("getBatteryLevel");
      print(response);
      setState(() {
        showMessage = response;
      });
    } catch (e) {
      //捕获error和notImplemented异常
      setState(() {
        showMessage = e.message;
      });
    }
  }

  ///MethodChannel end

  ///EventChannel start

  //init
  static const EventChannel _eventChannel = EventChannel("EventChannelPlugin");

  //receive
  void handleEventChannelReceive() {
    streamSubscription = _eventChannel
        .receiveBroadcastStream()//可以携带参数
        .listen(_onData, onError: _onError, onDone: _onDone);
  }

  void _onDone() {
    setState(() {
      showMessage = "endOfStream";
    });
  }

  _onError(error) {
    setState(() {
      PlatformException platformException = error;
      showMessage = platformException.message;
    });
  }

  void _onData(message) {
    setState(() {
      showMessage = message;
    });
  }

  ///EventChannel end

  void _onPressed() async {
    ///BasicMessageChannel send
    //handleBasicMessageChannelSend();

    ///MethodChannel send
    //handleMethodChannelSend();
  }

  @override
  void initState() {
    ///BasicMessageChannel receive
    //handleBasicMessageChannelReceive();

    ///MethodChannel receive
    //handleMethodChannelReceive();

    ///MethodChannel receive
    handleEventChannelReceive();

    super.initState();
  }

  @override
  void dispose() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
      streamSubscription = null;
    }

    super.dispose();
  }

  String getPlatformName() {
    if (Platform.isIOS) {
      return "iOS platform";
    } else if (Platform.isAndroid) {
      return "Android platform";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: TextField(
              controller: _controller,
              decoration: new InputDecoration(
                hintText: '传递给Native的数据',
              ),
            ),
          ),
          RaisedButton(
            onPressed: _onPressed,
            child: Text("Msg To Native"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "来自native的消息：",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                Text(
                  showMessage,
                  style: TextStyle(color: Colors.red, fontSize: 15),
                )
              ],
            ),
          ),
        ],
      ),
    )

        //集成时打开
//      Center(
//        child: _widgetRoute(widget.initParams),
//      ),
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
