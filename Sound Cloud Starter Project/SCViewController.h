//
//  SCViewController.h
//  Sound Cloud Starter Project
//
//  Created by Romy on 4/8/13.
//  Copyright (c) 2013 Snowyla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *playTracksButton;
- (IBAction)loginButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)playTracksButtonPressed:(UIButton *)sender;
@end
