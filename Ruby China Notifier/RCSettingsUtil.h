//
//  RCUserDefaults.h
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-7.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCSettingsUtil : NSObject

// 初始化默认值
+ (void) initDefaults;

+ (void) token:(NSString *) token;
+ (NSString *) token;
+ (void) soundEnable:(bool) isEnable;
+ (bool) soundEnable;

+ (BOOL) willStartAtLogin;
+ (void) setStartAtLogin: (BOOL)enabled;
+ (NSURL *) appURL;
@end
