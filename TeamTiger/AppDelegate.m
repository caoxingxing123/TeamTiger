//
//  AppDelegate.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "UIImage+TYLaunchImage.h"
#import "UIView+TYLaunchAnimation.h"
#import "TYLaunchFadeScaleAnimation.h"
#import "TTBaseNavigationController.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if(!self.window){
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    [self initialMethods];
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    TTBaseNavigationController *rootNavi = [[TTBaseNavigationController alloc] initWithRootViewController:homeVc];
    self.window.rootViewController = rootNavi;
    [self.window makeKeyAndVisible];
    //launch image
    UIImageView *screenImageView = [[UIImageView alloc] initWithImage:[UIImage ty_getLaunchImage]];
    [screenImageView showInWindowWithAnimation:[TYLaunchFadeScaleAnimation fadeScaleAnimation]
                                    completion:^(BOOL finished) {
                                        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                                    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma -mark initial methods
- (void)initialMethods {
    //DataBase
    [SQLITEMANAGER setDataBasePath:SYSTEM];
    [SQLITEMANAGER createDataBaseIsNeedUpdate:YES isForUser:NO];
    
    //IQKeyboardManager
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

@end
