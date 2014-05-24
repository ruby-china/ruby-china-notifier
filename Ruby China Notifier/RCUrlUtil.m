//
//  RCUrlUtil.m
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-10.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import "RCUrlUtil.h"

@implementation RCUrlUtil

+ (NSString *) webAppUrlWithPath: (NSString *) path {
    return [[NSString stringWithFormat:@"https://%@", WEB_APP_DOMAIN] stringByAppendingPathComponent:path];
}

+ (NSString *)fayeAppUrlWithPath:(NSString *)path {
    return [NSString stringWithFormat:@"ws://%@", [FAYE_APP_DOMAIN stringByAppendingPathComponent:path]];
}

@end
