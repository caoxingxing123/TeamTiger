//
//  ViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeViewController.h"
#import "NetworkManager.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //配置网络
    [NetworkManager configerNetworking];
    
    Api1 *api1 = [[Api1 alloc] init];
    api1.cacheInvalidTime = 60;//需要缓存
    api1.requestArgument = @{@"lat":@"34.345",@"lng":@"113.678"};
    LCRequestAccessory *accessary = [[LCRequestAccessory alloc] initWithShowVC:self];
    [api1 addAccessory:accessary];
    [api1 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@",request.responseJSONObject);
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
