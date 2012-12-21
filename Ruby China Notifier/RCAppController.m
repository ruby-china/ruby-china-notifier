//
//  RCAppController.m
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-3.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import "RCAppController.h"

@implementation RCAppController

// @synthesize statusItem, statusImage, statusHighlightImage, statusMenu, reconnectMenu;

- (void)awakeFromNib {
    
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    
    statusImage = [NSImage imageNamed:@"status"];
    statusHighlightImage = [NSImage imageNamed:@"status_offline"];
    
    [statusItem setImage:statusHighlightImage];
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"Ruby China Notifier"];
    
    [statusItem setHighlightMode:true];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    
    if ([RCSettingsUtil token] == @"") {
        [self settingAction:self];
    }
    else {
        [self connectionFayeServer:self];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFayeServer:) name:@"RCAccessTokenChanged" object:nil];
}

- (void) connectionFayeServer:(id)sender {
    NSLog(@"initFayeClient");
    if (fayeClient != nil) {
        NSLog(@"disconnectFromServer old FayeClient.");
        [fayeClient disconnectFromServer];
    }
    NSURL *url = [NSURL URLWithString:  [NSString stringWithFormat:@"%@?token=%@",[RCUrlUtil webAppUrlWithPath:@"/api/users/temp_access_token"],[RCSettingsUtil token]]];
    NSString *res = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dict = [res objectFromJSONString];
    if([dict objectForKey:@"temp_access_token"] == nil){
        return;
    }

    NSLog(@"Authorize successed.");
    NSString *user_channel_id = [dict objectForKey:@"temp_access_token"];
    NSLog(@"faye url: %@", [RCUrlUtil fayeAppUrlWithPath:@"/faye"]);
    
    fayeClient = [[FayeClient alloc] initWithURLString: [RCUrlUtil fayeAppUrlWithPath:@"/faye"] channel: [NSString stringWithFormat: @"/notifications_count/%@", user_channel_id]];
    fayeClient.delegate = self;
    [fayeClient connectToServer];
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
    [preferencesController.window center];
    [NSApp activateIgnoringOtherApps:YES];
    [preferencesController showWindow:self];
}


- (void) messageReceived:(NSDictionary *)messageDict {
    NSLog(@"Received message: %@, %@", [messageDict objectForKey:@"count"], [messageDict objectForKey:@"count"] );
    NSString *title = [messageDict objectForKey:@"title"];
    NSString *content = [messageDict objectForKey:@"content"];
    NSString *contentPath = [messageDict objectForKey:@"content_path"];
    [self deliverUserNotificationWithTitle:title withContent:content withContentPath:contentPath];
    
    if([messageDict objectForKey:@"count"] > 0){
        [[NSApp dockTile] setBadgeLabel:[NSString stringWithFormat:@"%@",[messageDict objectForKey:@"count"]]];
    }
}


- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *) notification{
    NSLog(@"userNotificationCenter");
    [center removeDeliveredNotification:notification];
    switch (notification.activationType) {
		case NSUserNotificationActivationTypeActionButtonClicked:
			NSLog(@"Reply Button was clicked -> quick reply");
			[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[notification.userInfo valueForKey:@"url"]]];
			break;
		case NSUserNotificationActivationTypeContentsClicked:
			NSLog(@"Notification body was clicked -> redirect to item");
			[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[notification.userInfo valueForKey:@"url"]]];
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

- (void) connectedToServer {
    NSLog(@"Faye connected.");
    [reconnectMenu setTitle:@"已连接"];
    [statusItem setImage:statusImage];
    [reconnectMenu setEnabled:NO];    
}

- (void)disconnectedFromServer{
    NSLog(@"Faye disconnected.");
    [reconnectMenu setTitle:@"重新连接"];
    [reconnectMenu setEnabled:YES];
    [statusItem setImage:statusHighlightImage];
    [self deliverUserNotificationWithTitle:@"Ruby China" withContent:@"连接通知服务器失败。" withContentPath:nil];
}

- (void)subscriptionFailedWithError:(NSString *)error {
    NSLog(@"subscriptionFailedWithError");
    [self disconnectedFromServer];
}

- (void) deliverUserNotificationWithTitle: (NSString *) title withContent: (NSString *) content withContentPath: (NSString *) contentPath {
    NSUserNotification *notify = [[NSUserNotification alloc] init];
    notify.title = title;
    notify.informativeText = content;
    if (contentPath != nil) {
        notify.userInfo = @{ @"url" : [RCUrlUtil webAppUrlWithPath: contentPath] };
        notify.hasActionButton = true;
        notify.actionButtonTitle = @"点击查看";
    }
    if([RCSettingsUtil soundEnable]) {
        [notify setSoundName:NSUserNotificationDefaultSoundName];
    }
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notify];
}




@end
