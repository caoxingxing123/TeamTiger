//
//  NetworkManager.h
//  TeamTiger
//
//  Created by xxcao on 16/7/22.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCBaseRequest.h"
#import "LCRequestAccessory.h"

@interface NetworkManager : NSObject

+ (void)configerNetworking;

@end

@interface Api1 : LCBaseRequest<LCAPIRequest>

@end

@interface ImageUploadApi : LCBaseRequest<LCAPIRequest>

@end
