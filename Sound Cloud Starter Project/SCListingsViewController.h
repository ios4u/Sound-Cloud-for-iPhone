//
//  SCListingsViewController.h
//  Sound Cloud Starter Project
//
//  Created by Romy on 4/8/13.
//  Copyright (c) 2013 Snowyla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SCListingsViewController : UITableViewController <AVAudioPlayerDelegate>
@property (nonatomic, strong) NSArray *tracks;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
- (IBAction)closeButtonPressed:(UIBarButtonItem *)sender;
@end
