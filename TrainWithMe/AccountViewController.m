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
#import "Color.h"
#import "TimeViewController.h"
#import "MapViewController.h"

@interface AccountViewController () <ActivityVCDelegate, TimeVCDelegate, MapVCDelegate>
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *weightTextField;
@property (nonatomic, weak) IBOutlet UIButton *activityButton;
@property (nonatomic, weak) IBOutlet UIButton *intensityButton;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;
@property (nonatomic, weak) IBOutlet UIButton *timeButton;
@property (nonatomic, strong) UITapGestureRecognizer *tapper;

@property (nonatomic, strong) NSMutableArray *activityArray;
@property (nonatomic, strong) NSMutableArray *intensityArray;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
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
	self.intensityArray = currentUser[@"intensities"];
	if (!self.activityArray) {
		self.activityArray = [[NSMutableArray alloc] init];
	}
	if (!self.intensityArray) {
		self.intensityArray = [[NSMutableArray alloc] init];
	}
	[self updateActivityButtonText];
	[self updateIntensityButtonText];
	
	self.startTime = currentUser[@"startTime"];
	self.endTime = currentUser[@"endTime"];
	if (!self.startTime) {
		self.startTime = [NSDate date];
	}
	if (!self.endTime) {
		self.endTime = [NSDate date];
	}
	[self updateTimeButtonText];
	
	self.locationArray = currentUser[@"locations"];
	if (!self.locationArray) {
		self.locationArray = [[NSMutableArray alloc] init];
	}
	[self updateLocationButtonText];
	
	self.navigationItem.title = @"Profile";
	
	self.tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:self.tapper];
	[[UINavigationBar appearance] setBarTintColor:[UIColor colorRed]];
}

- (void)hideKeyboard {
	[self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBar.barTintColor = [UIColor colorRed];
}

-(void)savePressed {
	[SVProgressHUD showWithStatus:@"Saving..."];
	
	PFUser *currentUser = [PFUser currentUser];
	currentUser[@"name"] = [self.nameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	currentUser[@"weight"] = @([[self.weightTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] integerValue]);
	
	currentUser[@"activities"] = self.activityArray;
	currentUser[@"intensities"] = self.intensityArray;
	currentUser[@"startTime"] = self.startTime;
	currentUser[@"endTime"] = self.endTime;
	currentUser[@"locations"] = self.locationArray;
	
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

-(void)updateIntensityButtonText {
	NSString *intensityString = @"";
	if ([self.intensityArray count] > 2) {
		intensityString = [NSString stringWithFormat:@"%zd Intensities", [self.intensityArray count]];
	}
	else if ([self.intensityArray count] == 2) {
		intensityString = [NSString stringWithFormat:@"%@, %@", self.intensityArray[0], self.intensityArray[1]];
	}
	else if ([self.intensityArray count] == 1) {
		intensityString = self.intensityArray[0];
	}
	else {
		intensityString = @"Tap to Choose Intensities";
	}
	[self.intensityButton setTitle:intensityString forState:UIControlStateNormal];
}

-(void)updateTimeButtonText {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"h:mm a"];
	
	NSString *timeLabel = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:self.startTime], [formatter stringFromDate:self.endTime]];
	[self.timeButton setTitle:timeLabel forState:UIControlStateNormal];
}

-(void)updateLocationButtonText {
	NSString *locationString = @"";
	if (self.locationArray.count > 1) {
		locationString = [NSString stringWithFormat:@"%zd Locations", self.locationArray.count];
	}
	else if (self.locationArray.count == 1) {
		locationString = self.locationArray[0][@"name"];
	}
	else {
		locationString = @"Tap to Choose Location";
	}
	
	[self.locationButton setTitle:locationString forState:UIControlStateNormal];
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
	ActivityTableViewController *activityVC = [[ActivityTableViewController alloc] initWithSelectedTypes:self.activityArray asActivity:YES];
	activityVC.delegate = self;
	[self.navigationController pushViewController:activityVC animated:YES];
}

-(IBAction)intensityPressed {
	ActivityTableViewController *intensityVC = [[ActivityTableViewController alloc] initWithSelectedTypes:self.intensityArray asActivity:NO];
	intensityVC.delegate = self;
	[self.navigationController pushViewController:intensityVC animated:YES];
}

-(IBAction)locationPressed {
	MapViewController *mapVC = [[MapViewController alloc] initWithSavedLocations:self.locationArray];
	mapVC.delegate = self;
	[self.navigationController pushViewController:mapVC animated:YES];
}

-(IBAction)timePressed {
	TimeViewController *timeVC = [[TimeViewController alloc] initWithStartTime:self.startTime endTime:self.endTime];
	timeVC.delegate = self;
	[self.navigationController pushViewController:timeVC animated:YES];
}


-(void)activityVCCancelled {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)activityVCObjectsSelected:(NSArray *)objects asActivity:(BOOL)isActivity {
	if (isActivity) {
		self.activityArray = [objects mutableCopy];
		[self updateActivityButtonText];
	}
	else {
		self.intensityArray = [objects mutableCopy];
		[self updateIntensityButtonText];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)timeVCTimesSaved:(NSDate *)startTime endTime:(NSDate *)endTime {
	self.startTime = startTime;
	self.endTime = endTime;
	[self updateTimeButtonText];
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)timeVCTimesCancelled {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)mapVCCancelled {
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)mapVCSavedLocation:(NSArray *)locations {
	self.locationArray = [locations mutableCopy];
	[self updateLocationButtonText];
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
