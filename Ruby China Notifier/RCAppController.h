//
//  RCAppController.h
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-3.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FayeClient.h"
#import "RCPreferencesWindowController.h"
#import "RCUrlUtil.h"
#import "JSONKit.h"

@interface RCAppController : NSStatusBar <FayeClientDelegate, NSUserNotificationCenterDelegate> {
    RCPreferencesWindowController *preferencesController;
    FayeClient *fayeClient;
    IBOutlet NSMenuItem *reconnectMenu;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
}



- (IBAction)about: (id)sender;
- (IBAction)settingAction:(id)sender;
- (IBAction)connectionFayeServer:(id)sender;

@end
