//
//  RCUrlUtil.h
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-10.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
static NSString * WEB_APP_DOMAIN = @"127.0.0.1:3000";
static NSString * FAYE_APP_DOMAIN = @"127.0.0.1:8080";
#else
static NSString * WEB_APP_DOMAIN = @"ruby-china.org";
static NSString * FAYE_APP_DOMAIN = @"ruby-china.org:8080";
#endif

@interface RCUrlUtil : NSObject
+ (NSString *) webAppUrlWithPath: (NSString *) path ;
+ (NSString *) fayeAppUrlWithPath: (NSString *) path ;
@end
