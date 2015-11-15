//
//  AccountViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "AccountViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "ActivityTableViewController.h"

@interface AccountViewController () <ActivityVCDelegate>
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *weightTextField;
@property (nonatomic, weak) IBOutlet UIButton *activityButton;
@property (nonatomic, weak) IBOutlet UIButton *intensityButton;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;
@property (nonatomic, weak) IBOutlet UIButton *timeButton;
@property (nonatomic, strong) UITapGestureRecognizer *tapper;

@property (nonatomic, strong) NSMutableArray *activityArray;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
	
	PFUser *currentUser = [PFUser currentUser];
	self.nameTextField.text = currentUser[@"name"];
	self.weightTextField.text = [NSString stringWithFormat:@"%zd", [currentUser[@"weight"] integerValue]];
	self.activityArray = currentUser[@"activities"];
	[self updateActivityButtonText];
	
	
	self.tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:self.tapper];
}

- (void)hideKeyboard {
	[self.view endEditing:YES];
}

-(void)savePressed {
	[SVProgressHUD showWithStatus:@"Saving..."];
	
	PFUser *currentUser = [PFUser currentUser];
	currentUser[@"name"] = [self.nameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	currentUser[@"weight"] = @([[self.weightTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] integerValue]);
	
	currentUser[@"activities"] = self.activityArray;
	
	[currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		
		if (succeeded) {
			[SVProgressHUD dismiss];
			if (self.delegate) {
				[self.delegate accountVCSaved];
			}
		}
		else {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Failed" message:@"Saving your info failed. Would you like us to try again?" preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				[self savePressed];
			}]];
			[alert addAction:[UIAlertAction actionWithTitle:@"Nevermind" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
				[SVProgressHUD dismiss];
				if (self.delegate) {
					[self.delegate accountVCCancelled];
				}
			}]];
			[self presentViewController:alert animated:YES completion:nil];
		}
	}];
	
	
}

-(void)updateActivityButtonText {
	
	NSString *activityString = @"";
	if ([self.activityArray count] > 2) {
		activityString = [NSString stringWithFormat:@"%zd Activities", [self.activityArray count]];
	}
	else if ([self.activityArray count] == 2) {
		activityString = [NSString stringWithFormat:@"%@, %@", self.activityArray[0], self.activityArray[1]];
	}
	else if ([self.activityArray count] == 1) {
		activityString = self.activityArray[0];
	}
	else {
		activityString = @"Tap to Choose Activities";
	}
	[self.activityButton setTitle:activityString forState:UIControlStateNormal];
}

-(void)cancelPressed {
	if (self.delegate) {
		[self.delegate accountVCCancelled];
	}
}

-(IBAction)logOutPressed {
	if (self.delegate) {
		[self.delegate accountVCLoggedOut];
	}
}

-(IBAction)activityPressed {
	ActivityTableViewController *activityVC = [[ActivityTableViewController alloc] initWithSelectedTypes:self.activityArray];
	activityVC.delegate = self;
	[self.navigationController pushViewController:activityVC animated:YES];
}

-(IBAction)intensityPressed {
	NSLog(@"intensity pressed");
}

-(IBAction)locationPressed {
	NSLog(@"location pressed");
}

-(IBAction)timePressed {
	NSLog(@"time pressed");
}


-(void)activityVCCancelled {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)activityVCObjectsSelected:(NSArray *)objects {
	self.activityArray = [objects mutableCopy];
	[self updateActivityButtonText];
	
	[self.navigationController popViewControllerAnimated:YES];
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
