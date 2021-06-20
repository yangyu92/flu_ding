import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flu_ding/flu_ding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _dingtalkVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String dingtalkVersion;
    try {
      dingtalkVersion =
          await FluDing.openAPIVersion ?? 'Unknown platform version';
      bool isSupport = await FluDing.registerApp("dingu6xwfjbghhqtwwzu");
      print("注册成功: $isSupport");
    } on PlatformException {
      dingtalkVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _dingtalkVersion = dingtalkVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dingtalk SDK Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('dingtalkVersion: $_dingtalkVersion\n'),
              TextButton(
                onPressed: () {
                  FluDing.isDingTalkInstalled.then((value) {
                    print("是否安装了钉钉: $value");
                  });
                },
                child: Text('DingTalkInstalled'),
              ),
              TextButton(
                onPressed: () {
                  FluDing.isDingTalkSupportSSO.then((value) {
                    print("是否支持登录: $value");
                  });
                },
                child: Text('isDingTalkSupportSSO'),
              ),
              TextButton(
                onPressed: () {
                  FluDing.openDingTalk
                      .then((value) => print("打开钉钉App: $value"));
                },
                child: Text('openDingTalk'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
