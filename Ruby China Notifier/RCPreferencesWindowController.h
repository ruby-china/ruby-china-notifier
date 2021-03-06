//
//  RCPreferencesWindowController.h
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-7.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RCSettingsUtil.h"
#import <Sparkle/Sparkle.h>

@interface RCPreferencesWindowController : NSWindowController <NSWindowDelegate> {
    IBOutlet NSToolbar *toolbar;
    IBOutlet NSView *rootView;
    IBOutlet NSView  *basePrefsView;
    IBOutlet NSView  *aboutPrefsView;
    IBOutlet NSTextField *tokenField;
    IBOutlet NSButton *viewProfileButton;
    IBOutlet NSButton *autoStartButton;
    IBOutlet NSButton *soundEnableButton;
    IBOutlet NSTextField *versionField;
}

- (IBAction)selectBasePanel:(id)sender;
- (IBAction)selectAboutPanel:(id)sender;
- (IBAction)openUserSettingsWebPage:(id)sender;
- (IBAction)autoStartCheckboxChanged:(id)sender;
- (IBAction)soundEnableCheckboxChanged:(id)sender;
- (void) setToFront;
@end
