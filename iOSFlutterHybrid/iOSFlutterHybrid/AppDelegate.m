//
//  AppDelegate.m
//  iOSFlutterHybrid
//
//  Created by ppd-03020339 on 2019/11/12.
//  Copyright © 2019 hybrid. All rights reserved.
//

#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h> // 如果你需要用到Flutter插件时
#include "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.flutterEngine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
  [self.flutterEngine runWithEntrypoint:nil];
  [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine]; //如果你需要用到Flutter插件时
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
