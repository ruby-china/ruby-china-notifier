//
//  RCAppDelegate.m
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-3.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import "RCAppDelegate.h"
#import <Sparkle/Sparkle.h>

@implementation RCAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [RCSettingsUtil initDefaults];
    
    [self initAutoUpdate];
    [[SUUpdater sharedUpdater] checkForUpdatesInBackground];
}

- (void) initAutoUpdate {
    NSString *feedUrl = @"http://update.labs.etao.com/ruby-china-notifier/updates.xml";
    
    [[SUUpdater sharedUpdater] setFeedURL:[NSURL URLWithString:feedUrl]];
}

@end
