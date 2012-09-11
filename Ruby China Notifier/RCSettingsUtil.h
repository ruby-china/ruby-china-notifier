//
//  RCUserDefaults.h
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-7.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCSettingsUtil : NSObject


+ (void) writeToken:(NSString *) token;
+ (NSString *) readToken;
+ (BOOL) willStartAtLogin;
+ (void) setStartAtLogin: (BOOL)enabled;
+ (NSURL *) appURL;
@end
