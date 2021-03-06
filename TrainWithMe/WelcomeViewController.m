//
//  WelcomeViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "WelcomeViewController.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "AccountViewController.h"
#import <Parse/Parse.h>

@interface WelcomeViewController () <SignUpViewControllerDelegate, AccountVCDelegate>
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.navigationItem.title = @"Welcome!";
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signupPressed {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	SignUpViewController *signupVC = [storyboard instantiateViewControllerWithIdentifier:@"signupVC"];
	signupVC.delegate = self;
	[self.navigationController pushViewController:signupVC animated:YES];
}

-(IBAction)loginPressed {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	LoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
	[self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - Signup VC

-(void)signUpViewControllerSucceeded {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	AccountViewController *accountVC = [storyboard instantiateViewControllerWithIdentifier:@"accountVC"];
	accountVC.delegate = self;
	
	[self.navigationController pushViewController:accountVC animated:YES];
}

-(void)accountVCCancelled {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)accountVCSaved {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)accountVCLoggedOut {
	[PFUser logOut];
	[self dismissViewControllerAnimated:YES completion:^{
		//[self presentWelcomeVC];
	}];
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
