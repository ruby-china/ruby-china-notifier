//
//  RCUserDefaults.m
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-7.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import "RCSettingsUtil.h"

@implementation RCSettingsUtil

+ (NSString *)readToken {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:@"user_token"];
    if(value == nil){
        value = @"";
    }
    return value;
}

+ (void)writeToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"user_token"];
}

@end
