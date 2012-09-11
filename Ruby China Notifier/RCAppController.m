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
    NSBundle *bundle = [NSBundle mainBundle];
    
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"status0" ofType:@"png"]];
    statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"status1" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"Ruby China Notifier"];
    
    [statusItem setHighlightMode:true];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [[NSApp dockTile] display];
    
    if ([RCSettingsUtil readToken] == @"") {
        [self settingAction:self];
    }
    else {
        [self connectionFayeServer:self];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFayeServer:) name:@"RCAccessTokenChanged" object:nil];
}

- (void) connectionFayeServer:(id)sender {
    NSLog(@"initFayeClient");
    NSURL *url = [NSURL URLWithString:  [NSString stringWithFormat:@"%@?token=%@",[RCUrlUtil webAppUrlWithPath:@"/api/users/temp_access_token"],[RCSettingsUtil readToken]]];
    NSString *res = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dict = [res objectFromJSONString];
    if([dict objectForKey:@"temp_access_token"] == nil){
        NSLog(@"Authorize failed. %@", res);
        [reconnectMenu setTitle:@"重新连接"];
        [reconnectMenu setEnabled:YES];
        [self deliverUserNotificationWithTitle:@"Ruby China" withContent:@"连接失败，请重试." withContentPath:nil];
        return;
    }

    NSLog(@"Authorize successed.");
    NSString *user_channel_id = [dict objectForKey:@"temp_access_token"];
    NSLog(@"faye url: %@", [RCUrlUtil fayeAppUrlWithPath:@"/faye"]);
    if (fayeClient != nil) {
        [fayeClient disconnectFromServer];
        NSLog(@"Disconnect old client.");
    }
    
    fayeClient = [[FayeClient alloc] initWithURLString: [RCUrlUtil fayeAppUrlWithPath:@"/faye"] channel: [NSString stringWithFormat: @"/notifications_count/%@", user_channel_id]];
    fayeClient.delegate = self;
    [fayeClient connectToServer];
    NSLog(@"Faye Server connectioned.");
    [reconnectMenu setTitle:@"已连接"];
    [self deliverUserNotificationWithTitle:@"Ruby China" withContent:@"通知中心连接成功." withContentPath:nil];
    [reconnectMenu setEnabled:NO];
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
        [statusItem setImage:statusHighlightImage];
    }
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *) notification{
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
    [statusItem setImage:statusImage];
}


- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
	return !notification.isPresented;
}

- (void)connectedToServer {
    
}

- (void)disconnectedFromServer{
    
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
    [notify setSoundName:NSUserNotificationDefaultSoundName];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notify];
}



@end
