//
//  RCPreferencesWindowController.h
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-7.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RCSettingsUtil.h"

@interface RCPreferencesWindowController : NSWindowController <NSWindowDelegate> {
    IBOutlet NSToolbar *toolbar;
    IBOutlet NSView  *basePrefsView;
    IBOutlet NSTextField *tokenField;
    IBOutlet NSButton *viewProfileButton;
}

- (IBAction)selectBasePanel:(id)sender;
- (IBAction)openUserSettingsWebPage:(id)sender;

@end
