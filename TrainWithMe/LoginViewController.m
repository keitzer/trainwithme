//
//  LoginViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "Color.h"

@interface LoginViewController ()
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) UITapGestureRecognizer *tapper;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.navigationItem.title = @"Log In";
	if ([self.usernameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
		self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
	}
	if ([self.passwordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
		self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
	}
	
	self.tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:self.tapper];
	self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
}

- (void)hideKeyboard {
	[self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//[[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(IBAction)loginPressed {
	[SVProgressHUD showWithStatus:@"Logging In..."];
	
	[PFUser logInWithUsernameInBackground:self.usernameTextField.text
								 password:self.passwordTextField.text
									block:^(PFUser *user, NSError *error) {
										[SVProgressHUD dismiss];
										
										if (user) {
											// Do stuff after successful login.
											[self dismissViewControllerAnimated:YES completion:nil];
										} else {
											// The login failed. Check error to see why.
											UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Fail" message:@"Something went wrong when loggin in. Please try again." preferredStyle:UIAlertControllerStyleAlert];
											[alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
											[self presentViewController:alert animated:YES completion:nil];

										}
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
