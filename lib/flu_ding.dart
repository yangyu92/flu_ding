import 'dart:async';

import 'package:flutter/services.dart';

class FluDing {
  static const MethodChannel _channel = const MethodChannel('flu_ding');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> registerApp(String appId) async {
    final bool isSupport = await _channel.invokeMethod('registerApp', {
      "appId": appId,
    });
    return isSupport;
  }

  static Future<String?> get openAPIVersion async {
    final String? version = await _channel.invokeMethod('openAPIVersion');
    return version;
  }

  static Future<bool> get isDingTalkInstalled async {
    final bool isOpenDingTalk =
        await _channel.invokeMethod('isDingTalkInstalled');
    return isOpenDingTalk;
  }

  static Future<bool> get isDingTalkSupportSSO async {
    final bool isDingTalkSupportSSO =
        await _channel.invokeMethod('isDingTalkSupportSSO');
    return isDingTalkSupportSSO;
  }

  static Future<bool?> get openDingTalk async {
    final bool? isOpenDingTalk = await _channel.invokeMethod('openDingTalk');
    return isOpenDingTalk;
  }
}
