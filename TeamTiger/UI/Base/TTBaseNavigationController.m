//
//  TTBaseNavigationController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseNavigationController.h"

@interface TTBaseNavigationController ()

@end

@implementation TTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = [UIColor colorWithRed:21/255.0f green:27/255.0f blue:39/255.0f alpha:1.0f];
    //开启滑动返回手势
    self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
