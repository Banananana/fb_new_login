//
//  NHOCAppDelegate.m
//  nhoctestapp
//
//  Created by Fernando Fernandes on 3/18/13.
//  Copyright (c) 2013 Nhoc!. All rights reserved.
//

#import "NHOCAppDelegate.h"
#import "NHOCLoginVC.h"

@implementation NHOCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"application:didFinishLaunchingWithOptions: in NHOCAppDelegate");
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive: in NHOCAppDelegate");
    //
    // The flow back to your app may be interrupted (for ex: if the user clicks the Home button
    // while if authenticating via the Facebook for iOS app).
    // If this happens, the Facebook SDK can take care of any cleanup that may include starting a fresh session.
    //
    [FBSession.activeSession handleDidBecomeActive];
    [self checkPermissionSettings];
}

//
// Verify if the user pressed the Home Button, went to Settings and deauthorized the app via "Allow These Apps to Use Your Account..."
// If so, redirect him to the login screen (this happens automagically, see below).
//
- (void)checkPermissionSettings
{
    NSLog(@"checkPermissionSettings: in NHOCAppDelegate");
    //
    // Now 'startForMeWithCompletionHandler' may return 'FBSessionStateClosed' (meaning that the user probably unauthorized the app in Settings).
    //
    // If that is the case:
    //
    //  - Hide the 'logged' View Controller
    //  - Remove it (NHOCLoggedVC) from the Notification Center
    //  - Show the 'login' View Controller
    //  - And finally add it (NHOCLoginVC) to the Notification Center, closing the loop
    //
    // Check the console for further info.
    //
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *error) {
        
        if (!error) {
            //
            // Everything went fine... The app is in good shape.
            // Notice that 'user.location' requires user_location permission
            //
            NSLog(@"user.location: %@: ", [user.location objectForKey:@"name"]);
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate: in NHOCAppDelegate");
    //
    // Called when the application is about to terminate.
    // Save data if appropriate. See also applicationDidEnterBackground:.
    //
    [FBSession.activeSession close];
}

//
// Invokes the FBSession class method openActiveSessionWithReadPermissions:allowLoginUI:completionHandler:.
// The authentication flow is initiated.
//
// The handler defined for the SDK authorization call, sessionStateChanged:state:error:,
// will be responsible for handling the success and error scenarios.
//
// It will also publish an app-wide notification when the session's state changes.
// This way other parts of the app can react without hard-coding that dependency in the session state handler.
//
- (void)openActiveSessionWithLoginUI:(BOOL)allowLoginUI
{
    NSLog(@"openActiveSessionWithLoginUI: %d in NHOCAppDelegate", allowLoginUI);
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    NSLog(@"sessionStateChanged:state:error: in NHOCAppDelegate");
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                //
                // We have a valid session
                //
                NSLog(@"FBSessionStateOpen");
            }
            break;

        case FBSessionStateClosed:
            NSLog(@"FBSessionStateClosed");
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
            
        case FBSessionStateClosedLoginFailed:
            NSLog(@"FBSessionStateClosedLoginFailed");
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FB_SESSION_CHANGE_NOTIFICATION object:session];
    
    if (error) {
        NSLog(@"Some nasty error! <o> (Tip: check if the app is allowed in Settings / Facebook / Allow these apps...)");
        //
        // Do something... Or don't. :)
        //
    }
}

//
// During the Login with FB flow, the app passes control to the Facebook iOS app or Facebook in mobile Safari.
// After the user is authenticated, the app will be called back with the session information.
// This method calls the Facebook session object that handles the incoming URL.
//
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *) sourceApplication annotation:(id)annotation
{
    NSLog(@"application:openURL:sourceApplication:annotation: in NHOCAppDelegate");
    return [FBSession.activeSession handleOpenURL:url];
}

@end
