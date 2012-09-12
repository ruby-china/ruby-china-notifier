//
//  RCUserDefaults.m
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-7.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import "RCSettingsUtil.h"

NSString *const UserTokenKey = @"UserToken";
NSString *const SoundEnableKey = @"SoundEnable";

@implementation RCSettingsUtil

+ (void) initDefaults {
    NSDictionary *defaultUserDefaults = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],SoundEnableKey, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultUserDefaults];
}

+ (NSString *) token {
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:UserTokenKey];
    if(value == nil){
        value = @"";
    }
    return value;
}

+ (void) token:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:UserTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (bool) soundEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SoundEnableKey];
}

+ (void) soundEnable:(bool)isEnable {
    [[NSUserDefaults standardUserDefaults] setBool:isEnable forKey:SoundEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSURL *) appURL {
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
}

+ (BOOL) willStartAtLogin {
    Boolean foundIt=false;
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems) {
        UInt32 seed = 0U;
        NSArray *currentLoginItems = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seed)) autorelease];
        for (id itemObject in currentLoginItems) {
            LSSharedFileListItemRef item = (LSSharedFileListItemRef)itemObject;
            
            UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
            CFURLRef URL = NULL;
            OSStatus err = LSSharedFileListItemResolve(item, resolutionFlags, &URL, /*outRef*/ NULL);
            if (err == noErr) {
                foundIt = CFEqual(URL, [self appURL]);
                CFRelease(URL);
                
                if (foundIt)
                    break;
            }
        }
        CFRelease(loginItems);
    }
    return (BOOL)foundIt;
}

+ (void) setStartAtLogin: (BOOL)enabled {
    LSSharedFileListItemRef existingItem = NULL;
    
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems) {
        UInt32 seed = 0U;
        NSArray *currentLoginItems = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seed)) autorelease];
        for (id itemObject in currentLoginItems) {
            LSSharedFileListItemRef item = (LSSharedFileListItemRef)itemObject;
            
            UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
            CFURLRef URL = NULL;
            OSStatus err = LSSharedFileListItemResolve(item, resolutionFlags, &URL, /*outRef*/ NULL);
            if (err == noErr) {
                Boolean foundIt = CFEqual(URL, [self appURL]);
                CFRelease(URL);
                
                if (foundIt) {
                    existingItem = item;
                    break;
                }
            }
        }
        
        if (enabled && (existingItem == NULL)) {
            LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst,
                                          NULL, NULL, (CFURLRef)[self appURL], NULL, NULL);
            
        } else if (!enabled && (existingItem != NULL))
            LSSharedFileListItemRemove(loginItems, existingItem);
        
        CFRelease(loginItems);
    }       
}

@end
