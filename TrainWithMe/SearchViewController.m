//
//  SearchViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/15/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "SearchViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"

@interface SearchViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *profilePicture;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet UIButton *acceptButton;
@property (nonatomic, weak) IBOutlet UIButton *rejectButton;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *workoutTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *intensityLabel;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.profilePicture.layer.masksToBounds = YES;
	self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
	self.backButton.layer.cornerRadius = self.backButton.frame.size.width/2;
	self.acceptButton.layer.cornerRadius = self.acceptButton.frame.size.width/2;
	self.rejectButton.layer.cornerRadius = self.rejectButton.frame.size.width/2;
}

-(IBAction)backButtonPressed {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)acceptPressed {
	[SVProgressHUD showImage:[UIImage imageNamed:@"LaunchIcon"] status:@"You've Been Matched!"];
}

-(IBAction)rejectPressed {
	
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
