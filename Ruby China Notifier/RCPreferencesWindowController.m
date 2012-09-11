//
//  RCPreferencesWindowController.m
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-7.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import "RCPreferencesWindowController.h"

@interface RCPreferencesWindowController ()

@end


@implementation RCPreferencesWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        
    }
    
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.window.delegate = self;
    [self selectBasePanel:nil];
    [tokenField setStringValue:[RCSettingsUtil readToken]];
    [versionField setObjectValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [autoStartButton setState:[RCSettingsUtil willStartAtLogin]];
}

- (void) removeAllViewFormRootView {
    [aboutPrefsView removeFromSuperview];
    [basePrefsView removeFromSuperview];
}

- (IBAction)selectBasePanel:(id)sender {
    [self removeAllViewFormRootView];
    [rootView addSubview:basePrefsView];
    [basePrefsView setFrame:rootView.frame];
    [toolbar setSelectedItemIdentifier:@"base"];
}

- (IBAction)selectAboutPanel:(id)sender {
    [self removeAllViewFormRootView];
    [rootView addSubview:aboutPrefsView];
    [aboutPrefsView setFrame:rootView.frame];
    [toolbar setSelectedItemIdentifier:@"about"];
}

- (IBAction)autoStartCheckboxChanged:(id)sender {
    // Insert the item at the bottom of Login Items list.
    if (autoStartButton.state == 1) {
        [RCSettingsUtil setStartAtLogin:YES];
    }
    else {
        [RCSettingsUtil setStartAtLogin:NO];
    }
}

- (IBAction)openUserSettingsWebPage:(id)sender {
     [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://ruby-china.org/account/edit"]];
}

- (BOOL)windowShouldClose:(id)sender {
    NSLog(@"Will to save info");
    if ([tokenField stringValue] != [RCSettingsUtil readToken]) {
        [RCSettingsUtil writeToken:[tokenField stringValue]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RCAccessTokenChanged" object:nil];
    }
    return YES;
}

@end
