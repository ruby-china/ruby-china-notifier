//
//  RCAppController.h
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-3.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FayeClient.h"

@interface RCAppController : NSStatusBar <FayeClientDelegate, NSUserNotificationCenterDelegate>

@property (retain) IBOutlet NSMenu *statusMenu;
@property (retain) NSStatusItem *statusItem;
@property (retain) NSImage *statusImage;
@property (retain) NSImage *statusHighlightImage;

- (IBAction)about: (id)sender;


@end
