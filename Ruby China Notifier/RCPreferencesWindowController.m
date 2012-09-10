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
    [toolbar setSelectedItemIdentifier:@"base"];
    [tokenField setStringValue:[RCSettingsUtil readToken]];
}


- (IBAction)selectBasePanel:(id)sender {
    [toolbar setSelectedItemIdentifier:@"base"];
}

- (IBAction)openUserSettingsWebPage:(id)sender {
     [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://ruby-china.org/account/edit"]];
}

- (BOOL)windowShouldClose:(id)sender {
    NSLog(@"Will to save info");
    [RCSettingsUtil writeToken:[tokenField stringValue]];
    return YES;
}

@end
