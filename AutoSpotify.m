//
//  AutoSpotify.m
//  AutoSpotify
//
//  Created by Elyx0 on 17/12/2013.
//  Copyright (c) 2013 Elyx0. All rights reserved.
//

#import "AutoSpotify.h"
#import <Adium/AIContentObject.h>
#import <Adium/AIContentMessage.h>


@implementation AutoSpotify

- (void) installPlugin
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(willReceiveContent:)
												 name:Content_WillReceiveContent
											   object:nil];
    AILog(@"INSTALLED AUTOSPOTIFY 1.1 autospotify");
}

- (void) uninstallPlugin
{
    
}

- (void)willReceiveContent:(NSNotification *)notification
{
    AILog(@"[Autospotify] Notification ok");
    AIContentObject		*contentObject = [[notification userInfo] objectForKey:@"Object"];
    AILog(@"[Autospotify] Received AutoSpotify --> %@",contentObject.message);
    AILog(@"[Autospotify] Received AutoSpotify(String) --> %@",contentObject.message.string);
    
    NSRange effectiveRange;
    effectiveRange = NSMakeRange(0, 0);
    NSString *url = [contentObject.message attribute:NSLinkAttributeName atIndex:1 effectiveRange:&effectiveRange];
    AILog(@"Received AutoSpotify URL --> %@",url);
    if (url.length < 1) {
        AILog(@"[Autospotify] No URL for this message");
    }
    else {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.*?)\\s+[pl|play|dino|dinosaure]"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:contentObject.message.string
                                                            options:0
                                                              range:NSMakeRange(0, [contentObject.message.string length])];
        
        if (numberOfMatches > 0) {
        
        AILog(@"[Autospotify] Launch OASCRIPT");
        NSString *fullScript = [NSString stringWithFormat:
                                @"tell application \"Spotify\" to play track \"%@\" \n",url];
        NSAppleScript *script = [[NSAppleScript alloc] initWithSource: fullScript];
        NSAppleEventDescriptor *returnData = [script executeAndReturnError:nil];
        
        AILog(@"[Autospotify] Result: %@",returnData);
        AILog(@"[Autospotify] Launched -- OASCRIPT");
        }
    }
}
@end
