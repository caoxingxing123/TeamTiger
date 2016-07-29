//
//  TTSettingViewController.m
//  TeamTiger
//
//  Created by xxcao on 16/7/27.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTSettingViewController.h"
#import "SettingCell.h"
#import "IQKeyboardManager.h"
@interface TTSettingViewController ()

@end

@implementation TTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目设置";
    [Common removeExtraCellLines:self.contentTable];
    
    [self hyb_setNavLeftButtonTitle:@"返回" onCliked:^(UIButton *sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.contentTable.estimatedRowHeight = 77;
    self.contentTable.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"CellIdentify";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = LoadFromNib(@"SettingCell");
    }
    [cell reloadCell:self.datas[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

#pragma -mark UITextView Delegate
#pragma -mark getters
- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray arrayWithObjects:
  @{@"NAME":@"fsfdfdfdfdfdfdfdfd",@"TITLE":@"名称",@"TYPE":@"0"},
  @{@"NAME":@"ffgfgfgfgfgfgfggf大大大大大大大大大大大大",@"TITLE":@"描述",@"TYPE":@"1"},
  @{@"NAME":@"飞凤飞飞如果认购人跟人沟通",@"TITLE":@"私有",@"TYPE":@"2"},
  @{@"NAME":@"个体户头昏眼花与银行业和银行业和银行业测试",@"TITLE":@"添加成员",@"TYPE":@"3"},nil];
    }
    return _datas;
}

@end
