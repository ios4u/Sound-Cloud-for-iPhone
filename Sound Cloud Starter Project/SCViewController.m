//
//  SCViewController.m
//  Sound Cloud Starter Project
//
//  Created by Romy on 4/8/13.
//  Copyright (c) 2013 Snowyla. All rights reserved.
//

#import "SCViewController.h"
#import "SCListingsViewController.h"
#import "SCUI.h"

@interface SCViewController ()
@property (strong, nonatomic) NSArray *tracks;
@end

@implementation SCViewController
@synthesize tracks=_tracks;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SCAccount *account = [SCSoundCloud account];
    
    if(account ==nil) {
        _loginLabel.hidden=YES;
        _loginButton.enabled=YES;
        _playTracksButton.hidden=YES;
    }
    else {
        _loginLabel.text=@"You're Logged In!";
        _playTracksButton.hidden=NO;
        _loginButton.enabled=NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@""]) {
        SCListingsViewController *listingsViewController = [segue destinationViewController];
        
        _tracks=listingsViewController.tracks;
    }
}

- (IBAction)loginButtonPressed:(UIBarButtonItem *)sender {
    
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"SoundCloud"
                                                         message:@"Sorry couldn't Log You In!"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
            [av show];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"SoundCloud"
                                                         message:@"You're Logged into SoundCloud!"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
            [av show];
            
            // check to see if they're logged in
            SCAccount *account = [SCSoundCloud account];
            
            if(account) {
                _playTracksButton.hidden=NO;
            }
            
            NSLog(@"Done!");
        }
    };
    
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                      completionHandler:handler];
        
        [self presentViewController:loginViewController
                           animated:YES
                         completion:^{
                             //
                         }];
         
    }];
    
}

- (IBAction)playTracksButtonPressed:(UIButton *)sender {
    
    SCAccount *account = [SCSoundCloud account];
    
    if(account==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Logged In"
                                                        message:@"You must login first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if(!jsonError && [jsonResponse isKindOfClass:[NSArray class]] ) {
        
            [self performSegueWithIdentifier:@"TrackListing" sender:self];
        }
    };
    
    NSString *resourceURL = kSoundCloudFaveTracks;
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    
  
}


@end
