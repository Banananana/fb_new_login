//
//  NHOCViewController.m
//  nhoctestapp
//
//  Created by Fernando Fernandes on 3/18/13.
//  Copyright (c) 2013 Nhoc!. All rights reserved.
//

#import "NHOCLoginVC.h"
#import "NHOCAppDelegate.h"

@interface NHOCLoginVC ()
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NHOCAppDelegate *appDelegate;
@end

@implementation NHOCLoginVC

- (NHOCAppDelegate *)appDelegate
{
    NSLog(@"appDelegate in NHOCLoginVC");
    if (!_appDelegate) _appDelegate = [[UIApplication sharedApplication] delegate];
    return _appDelegate;
}

- (void)viewDidLoad
{
   NSLog(@"viewDidLoad in NHOCLoginVC");
    [super viewDidLoad];
    self.status.hidden = true;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear: in NHOCLoginVC");
    NSLog(@"NHOCLoginVC added to the Notification Center.");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:FB_SESSION_CHANGE_NOTIFICATION
                                               object:nil];
    //
    // Check the session for a cached token to show the proper authenticated UI.
    // However, since this is not user intitiated, do not show the login UX.
    //
    [self.appDelegate openActiveSessionWithLoginUI:NO];
}

#pragma mark - Facebook Stuff

- (IBAction)fbLoginButtonTapped:(id)sender
{
    NSLog(@"fbLoginButtonTapped: in NHOCLoginVC");
    self.status.hidden = TRUE;
    [self.spinner startAnimating];
    [self.appDelegate openActiveSessionWithLoginUI:YES];
}

- (void)sessionStateChanged:(NSNotification*)notification
{
    NSLog(@"sessionStateChanged: in NHOCLoginVC");
    if (FBSession.activeSession.isOpen) {
        //
        // You got a session. :-)
        // Another view will take place. Remove this one from Notification Center.
        // (Remember that viewdidLoad and viewWillUnload are deprecated in iOS 6.0)
        //
        NSLog(@"NHOCLoginVC removed from the Notification Center.");
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        NSLog(@"Performing \"fbLoggedSegue\"");
        [self performSegueWithIdentifier:@"fbLoggedSegue" sender:self];
        
    } else {
        //
        // Fail to get a session! :-(
        //
        self.status.hidden = FALSE;
    }
    
    [self.spinner stopAnimating];
}

#pragma mark - Google Stuff


@end