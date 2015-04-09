//
//  AppDelegate.m
//  DaiStorage
//
//  Created by DaidoujiChen on 2015/4/8.
//  Copyright (c) 2015年 DaidoujiChen. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [MainViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
