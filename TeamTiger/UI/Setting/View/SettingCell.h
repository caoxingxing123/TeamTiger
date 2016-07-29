//
//  SettingCell.h
//  TeamTiger
//
//  Created by xxcao on 16/7/28.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ECellType) {
    ECellTypeTextField = 0,
    ECellTypeTextView,
    ECellTypeSwitch,
    ECellTypeAccessory,
};

@class SettingCell;
@class TTFadeSwitch;

typedef void(^NeedActionblock)(SettingCell *settingCell, ECellType type, id obj);

@interface SettingCell : UITableViewCell<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) TTFadeSwitch *tSwitch;
@property (strong, nonatomic) UIImageView *accessoryImgV;

@property (copy, nonatomic) NeedActionblock actionBlock;

- (void)reloadCell:(id)obj;

@end
