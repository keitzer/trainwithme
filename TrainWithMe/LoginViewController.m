//
//  LoginViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(IBAction)loginPressed {
	[PFUser logInWithUsernameInBackground:self.usernameTextField.text
								 password:self.passwordTextField.text
									block:^(PFUser *user, NSError *error) {
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
