//
//  NHOCLoggedViewController.m
//  nhoctestapp
//
//  Created by Fernando Fernandes on 3/25/13.
//  Copyright (c) 2013 Nhoc!. All rights reserved.
//

#import "NHOCLoggedVC.h"
#import "NHOCAppDelegate.h"

@interface NHOCLoggedVC ()
@property (strong, nonatomic) NHOCAppDelegate *appDelegate;
@end

@implementation NHOCLoggedVC

- (NHOCAppDelegate *)appDelegate
{
    NSLog(@"appDelegate in NHOCLoggedVC");
    if (!_appDelegate) _appDelegate = [[UIApplication sharedApplication] delegate];
    return _appDelegate;
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad in NHOCLoggedVC");
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear: in NHOCLoggedVC");
    NSLog(@"NHOCLoggedVC added to the Notification Center.");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:FB_SESSION_CHANGE_NOTIFICATION
                                               object:nil];
}

- (void)sessionStateChanged:(NSNotification*)notification
{
    NSLog(@"sessionStateChanged: in NHOCLoggedVC");
    if (FBSession.activeSession.isOpen) {
        //
        // You still have a valid session. :-) Stay opened.
        //
        
    } else {
        //
        // You are disconnected from FB.
        // Maybe she pressed the Home Button, went to settings and deauthorized your app.
        // Life is hard. Remove yourself from the Notification Center, dismiss this view
        // and finally show the login view again.
        //
        NSLog(@"NHOCLoggedVC removed from the Notification Center.");
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self performSegueWithIdentifier:@"fbLoginSegue" sender:self];
    }
}
- (IBAction)postHiButtonTapped:(id)sender {
    NSLog(@"postHiButtonTapped: in NHOCLoggedVC");
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       @"https://github.com/Belzebul/fb-sdk-storyboards", @"link",
                                       @"http://f.cl.ly/items/300W3b092f1P2o3C1j1M/Dolan.jpg", @"picture",
                                       @"Hi!", @"name",
                                       @"\n\"Posted by the fbsdksb app.\nfak u\"- Dolan", @"description",
                                       nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:postParams
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"FAK! error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Your first post was POSTED! \nYou rock!"];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
    
}

- (IBAction)fbLogoutButtonTapped:(id)sender
{
    NSLog(@"fbLogoutButtonTapped: in NHOCLoggedVC");
    [FBSession.activeSession closeAndClearTokenInformation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
