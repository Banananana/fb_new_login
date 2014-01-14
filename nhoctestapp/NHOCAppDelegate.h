//
//  NHOCAppDelegate.h
//  nhoctestapp
//
//  Created by Fernando Fernandes on 3/18/13.
//  Copyright (c) 2013 Nhoc!. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FB_SESSION_CHANGE_NOTIFICATION @"FBSessionChangeNotification"

@interface NHOCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)openActiveSessionWithLoginUI:(BOOL)allowLoginUI;

@end
