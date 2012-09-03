//
//  RCAppController.m
//  Ruby China Notifier
//
//  Created by Jason Lee on 12-9-3.
//  Copyright (c) 2012年 Ruby China. All rights reserved.
//

#import "RCAppController.h"

@implementation RCAppController

#ifdef DEBUG
    static NSString * APP_DOMAIN = @"127.0.0.1";
#else
    static NSString * APP_DOMAIN = @"ruby-china.org";
#endif

@synthesize statusItem, statusImage, statusHighlightImage, statusMenu;

- (void)awakeFromNib {
    
    
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    NSBundle *bundle = [NSBundle mainBundle];
    
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"status0" ofType:@"png"]];
    statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"status1" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"Ruby China Notifier"];
    
    [statusItem setHighlightMode:false];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [[NSApp dockTile] display];
    NSLog(@".........................");
    
    // Insert code here to initialize your application
    NSString *user_token = @"265c6e03e5223ca312c8aaa1e3263184";
    FayeClient *client = [[FayeClient alloc] initWithURLString: [NSString stringWithFormat:@"ws://%@:8080/faye", APP_DOMAIN] channel: [NSString stringWithFormat: @"/notifications_count/%@", user_token]];
    client.delegate = self;
    [client connectToServer];
}

- (void)dealloc{
    [statusImage release];
    [statusHighlightImage release];
    [statusMenu release];
    [statusItem release];
    [super dealloc];
}

- (void)about:(id)sender{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://ruby-china.org"]];
}


- (void) messageReceived:(NSDictionary *)messageDict {
    NSLog(@"Received message: %@, %@", [messageDict objectForKey:@"count"], [messageDict objectForKey:@"count"] );
    NSString *title = [messageDict objectForKey:@"title"];
    NSString *content = [messageDict objectForKey:@"content"];
    NSString *contentPath = [messageDict objectForKey:@"content_path"];
    NSUserNotification *notify = [[NSUserNotification alloc] init];
    notify.title = title;
    notify.informativeText = content;
    notify.userInfo = @{ @"url" : [NSString stringWithFormat: @"http://%@%@",APP_DOMAIN, contentPath] };
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
