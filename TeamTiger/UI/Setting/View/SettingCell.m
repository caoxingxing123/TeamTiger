//
//  SettingCell.m
//  TeamTiger
//
//  Created by xxcao on 16/7/28.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "SettingCell.h"
#import "UITextField+HYBMasonryKit.h"
#import "UIButton+HYBHelperBlockKit.h"
#import "TTFadeSwitch.h"
#import "UITextView+PlaceHolder.h"

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCell:(id)obj {
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
    self.titleLab.text = dic[@"TITLE"];

    switch ([dic[@"TYPE"] intValue]) {
        case ECellTypeTextField:{
            self.textField = [UITextField hyb_textFieldWithHolder:@"请输入名称" text:nil delegate:self superView:self.contentView constraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLab.mas_right).offset(-20);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            }];
            self.textField.textColor = [UIColor whiteColor];
            self.textField.tintColor = [UIColor whiteColor];
            [self.textField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
            self.textField.font = [UIFont systemFontOfSize:15];
            break;
        }
        case ECellTypeTextView:{
            [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(16);
                make.top.mas_equalTo(self.contentView.mas_top).offset(28);
                make.width.equalTo(@68);
            }];
            self.textView = [[UITextView alloc] init];
            self.textView.showsVerticalScrollIndicator = NO;
            self.textView.showsHorizontalScrollIndicator = NO;
            self.textView.scrollEnabled = NO;
            self.textView.delegate = self;
            self.textView.textColor = [UIColor whiteColor];
            self.textView.font = [UIFont systemFontOfSize:15];
            self.textView.backgroundColor = [UIColor clearColor];
            self.textView.tintColor = [UIColor whiteColor];
            [self.contentView addSubview:self.textView];
            [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLab.mas_right).offset(-24);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            }];
            
            self.textView.placeholder = @"请输入描述";
            break;
        }

        case ECellTypeSwitch:{
            // Fade mode
            self.tSwitch = [[TTFadeSwitch alloc] init];
            self.tSwitch.thumbImage = [UIImage imageNamed:@"switchToggle"];
            self.tSwitch.thumbHighlightImage = [UIImage imageNamed:@"switchToggleHigh"];
            self.tSwitch.trackMaskImage = [UIImage imageNamed:@"switchMask"];
            self.tSwitch.trackImageOn = [UIImage imageNamed:@"switchGreen"];
            self.tSwitch.trackImageOff = [UIImage imageNamed:@"switchRed"];
            self.tSwitch.thumbInsetX = -3.0;
            self.tSwitch.thumbOffsetY = 0.0;
            [self.contentView addSubview:self.tSwitch];
            [self.tSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.width.equalTo(@70);
                make.height.equalTo(@24);
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
            __weak __typeof(self)wself = self;
            self.tSwitch.changeHandler = ^(BOOL on){
                if (wself.actionBlock) {
                    wself.actionBlock(wself,ECellTypeSwitch,@(on));
                }
            };
            break;
        }

        case ECellTypeAccessory:{
            self.accessoryImgV = [[UIImageView alloc] init];
            self.accessoryImgV.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:self.accessoryImgV];
            [self.accessoryImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.width.equalTo(@20);
                make.height.equalTo(@20);
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
            
            [UIButton hyb_buttonWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 100, 0, 0));
            } touchUp:^(UIButton *sender) {
                if (self.actionBlock) {
                    self.actionBlock(self,ECellTypeAccessory,nil);
                }
            }];
            break;
        }
            
        default:
            break;
    }
}


- (void)textViewDidChange:(UITextView *)textView {
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}


@end
