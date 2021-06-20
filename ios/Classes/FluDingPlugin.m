#import "FluDingPlugin.h"
#import <DTShareKit/DTOpenKit.h>

@implementation FluDingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flu_ding"
                                     binaryMessenger:[registrar messenger]];
    FluDingPlugin* instance = [[FluDingPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"registerApp" isEqualToString:call.method]) {
        [self registerApp: call result:result];
    } else if ([@"openAPIVersion" isEqualToString:call.method]) {
        NSString *version = [DTOpenAPI openAPIVersion];
        result(version);
    } else if ([@"isDingTalkInstalled" isEqualToString:call.method]) {
        BOOL isInstalled = [DTOpenAPI isDingTalkInstalled];
        result(@(isInstalled));
    } else if ([@"isDingTalkSupportSSO" isEqualToString:call.method]) {
        BOOL isDingTalkSupportSSO = [DTOpenAPI isDingTalkSupportSSO];
        result(@(isDingTalkSupportSSO));
    } else if ([@"openDingTalk" isEqualToString:call.method]) {
        BOOL isOpenDingTalk = [DTOpenAPI openDingTalk];
        result(@(isOpenDingTalk));
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)registerApp:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *appId = call.arguments[@"appId"];
    if ([self isBlank:appId]) {
        result([FlutterError errorWithCode:@"invalid app id" message:@"are you sure your app id is correct ? " details:appId]);
        return;
    }
    // register AppId;
    BOOL isSupport = [DTOpenAPI registerApp:appId];
    result(@(isSupport));
}

- (BOOL)isBlank:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0;
}

@end
