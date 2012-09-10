//
//  RCAppController.m
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-3.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import "RCAppController.h"

@implementation RCAppController

@synthesize statusItem, statusImage, statusHighlightImage, statusMenu, settingWindow;

- (void)awakeFromNib {
    
    
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    NSBundle *bundle = [NSBundle mainBundle];
    
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"status0" ofType:@"png"]];
    statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"status1" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    // [statusItem setAlternateImage:statusHighlightImage];
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"Ruby China Notifier"];
    
    [statusItem setHighlightMode:true];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [[NSApp dockTile] display];
    
    if ([RCSettingsUtil readToken] == @"") {
        [self settingAction:self];
        NSLog(@"after setting action");
    }
    
    NSString *user_channel_id = [self tempAccessTokenFromRemote];
    FayeClient *client = [[FayeClient alloc] initWithURLString: [RCUrlUtil fayeAppUrlWithPath:@"/faye"] channel: [NSString stringWithFormat: @"/notifications_count/%@", user_channel_id]];
    client.delegate = self;
    [client connectToServer];
}

- (NSString *) tempAccessTokenFromRemote {
    NSURL *url = [NSURL URLWithString:  [NSString stringWithFormat:@"%@?token=%@",[RCUrlUtil webAppUrlWithPath:@"/api/users/temp_access_token"],[RCSettingsUtil readToken]]];
    NSString *res = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dict = [res objectFromJSONString];
    if([dict objectForKey:@"error"] != @""){
        NSLog(@"Authorize failed.");
        return @"";
    }
    else {
        NSLog(@"UnAuthorize failed.");
        return [dict objectForKey:@"temp_access_token"];
    }
}

- (void)dealloc{
    [statusImage release];
    [statusHighlightImage release];
    [statusMenu release];
    [statusItem release];
    [super dealloc];
}

- (void)about:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[RCUrlUtil webAppUrlWithPath:@""]]];
}

- (void)settingAction:(id)sender {
    if (preferencesController == nil) {
        preferencesController = [[RCPreferencesWindowController alloc] initWithWindowNibName:@"Preferences"];
    }
    [preferencesController showWindow:self];
}


- (void) messageReceived:(NSDictionary *)messageDict {
    NSLog(@"Received message: %@, %@", [messageDict objectForKey:@"count"], [messageDict objectForKey:@"count"] );
    NSString *title = [messageDict objectForKey:@"title"];
    NSString *content = [messageDict objectForKey:@"content"];
    NSString *contentPath = [messageDict objectForKey:@"content_path"];
    NSUserNotification *notify = [[NSUserNotification alloc] init];
    notify.title = title;
    notify.informativeText = content;
    notify.userInfo = @{ @"url" : [RCUrlUtil webAppUrlWithPath: contentPath] };
    [notify setSoundName:NSUserNotificationDefaultSoundName];
    notify.hasActionButton = true;
    notify.actionButtonTitle = @"点击查看";
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notify];
    
    if([messageDict objectForKey:@"count"] > 0){
        [[NSApp dockTile] setBadgeLabel:[NSString stringWithFormat:@"%@",[messageDict objectForKey:@"count"]]];
        [statusItem setHighlightMode:true];
    }
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *) notification{
    [center removeDeliveredNotification:notification];
    switch (notification.activationType) {
		case NSUserNotificationActivationTypeActionButtonClicked:
			NSLog(@"Reply Button was clicked -> quick reply");
			[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:notification.userInfo[@"url"]]];
			break;
		case NSUserNotificationActivationTypeContentsClicked:
			NSLog(@"Notification body was clicked -> redirect to item");
			[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:notification.userInfo[@"url"]]];
			break;
		default:
			NSLog(@"Notfiication appears to have been dismissed!");
			break;
	}
}


- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
	return !notification.isPresented;
}

- (void)connectedToServer {
    
}

- (void)disconnectedFromServer{
    
}



@end
