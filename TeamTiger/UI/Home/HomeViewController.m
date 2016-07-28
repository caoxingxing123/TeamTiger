//
//  ViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/19.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeViewController.h"
#import "NetworkManager.h"
#import "UIButton+HYBHelperBlockKit.h"
#import "TTSettingViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //配置网络
//    [NetworkManager configerNetworking];
//    
//    Api1 *api1 = [[Api1 alloc] init];
//    api1.cacheInvalidTime = 60;//需要缓存
//    api1.requestArgument = @{@"lat":@"34.345",@"lng":@"113.678"};
//    LCRequestAccessory *accessary = [[LCRequestAccessory alloc] initWithShowVC:self];
//    [api1 addAccessory:accessary];
//    [api1 startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
//        NSLog(@"%@",request.responseJSONObject);
//    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
//        NSLog(@"%@",error.description);
//    }];
        
    //
    UIButton *btn = [UIButton hyb_buttonWithTitle:@"TEST" superView:self.view constraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    } touchUp:^(UIButton *sender) {
        TTSettingViewController *settingVC = [[TTSettingViewController alloc] initWithNibName:@"TTSettingViewController" bundle:nil];
        [self.navigationController pushViewController:settingVC animated:YES];
    }];
    btn.backgroundColor = [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
