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

@property (nonatomic, strong) NSMutableArray *allUsers;
@property (nonatomic, strong) NSMutableArray *usersToShow;
@property (nonatomic, assign) NSInteger counter;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.allUsers = [[NSMutableArray alloc] init];
	self.usersToShow = [[NSMutableArray alloc] init];
	
	self.profilePicture.layer.masksToBounds = YES;
	self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
	self.backButton.layer.cornerRadius = self.backButton.frame.size.width/2;
	self.acceptButton.layer.cornerRadius = self.acceptButton.frame.size.width/2;
	self.rejectButton.layer.cornerRadius = self.rejectButton.frame.size.width/2;
	
	[SVProgressHUD showWithStatus:@"Loading Users..."];
	PFQuery *query = [PFUser query];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error) {
			self.allUsers = [objects mutableCopy];
			[self runAlgorithm];
			[self showNextUser];
		}
		else {
			[SVProgressHUD dismiss];
			[self alertWithTitle:@"Issue" andMessage:@"Could not retrieve users. Please try again later."];
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	}];
}

-(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
	[self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)backButtonPressed {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)acceptPressed {
	//[SVProgressHUD showImage:[UIImage imageNamed:@"LaunchIcon"] status:@"You've Been Matched!"];
	++self.counter;
	if (self.counter >= self.usersToShow.count) {
		[self alertWithTitle:@"No More Users!" andMessage:@"You went through everyone on the app. Go work out!"];
	}
	else {
		[self showNextUser];
	}
}

-(IBAction)rejectPressed {
	PFUser *currentUser = [PFUser currentUser];
	NSMutableArray *myRejected = [currentUser[@"rejected"] mutableCopy];
	if (!myRejected) {
		myRejected = [[NSMutableArray alloc] init];
	}
	[myRejected addObject:((PFUser*)(self.usersToShow[self.counter])).objectId];
	currentUser[@"rejected"] = myRejected;
	[currentUser saveInBackground];
	
	++self.counter;
	if (self.counter >= self.usersToShow.count) {
		[self alertWithTitle:@"No More Users!" andMessage:@"You went through everyone on the app. Go work out!"];
	}
	else {
		[self showNextUser];
	}
}

-(void)runAlgorithm {
	CGFloat relevanceScore = 0;
	
	unsigned int flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
	NSCalendar* calendar = [NSCalendar currentCalendar];
	
	PFUser *currentUser = [PFUser currentUser];
	NSArray *myLocations = currentUser[@"locations"];
	NSArray *myWorkoutTypes = currentUser[@"activities"];
	NSArray *myIntensities = currentUser[@"intensities"];
	NSInteger myWeight = [currentUser[@"weight"] integerValue];
	NSDate *myStartTime = currentUser[@"startTime"];
	NSDateComponents* myStartComponents = [calendar components:flags fromDate:myStartTime];
	NSDate* myStartTimeOnly = [calendar dateFromComponents:myStartComponents];
	
	NSDate *myEndTime = currentUser[@"endTime"];
	NSDateComponents* myEndComponents = [calendar components:flags fromDate:myEndTime];
	NSDate* myEndTimeOnly = [calendar dateFromComponents:myEndComponents];
	
	NSArray *myBuddies = currentUser[@"friends"];
	NSArray *myAccepted = currentUser[@"accepted"];
	NSArray *myRejected = currentUser[@"rejected"];
	
	[self.usersToShow removeAllObjects];
	for (PFUser *u in self.allUsers) {
		if ([myBuddies containsObject:u.objectId] || [myAccepted containsObject:u.objectId] || [myRejected containsObject:u.objectId] || [currentUser.objectId isEqualToString:u.objectId]) {
			continue;
		}
		
		BOOL locationOverlap = NO;
		for (NSDictionary *loc in u[@"locations"]) {
			if ([myLocations containsObject:loc]) {
				locationOverlap = YES;
			}
		}
		
		BOOL activityOverlap = NO;
		for (NSString *activity in u[@"activities"]) {
			if ([myWorkoutTypes containsObject:activity]) {
				activityOverlap = YES;
			}
		}
		
		BOOL intensityOverlap = NO;
		for (NSString *intensity in u[@"intensities"]) {
			if ([myIntensities containsObject:intensity]) {
				intensityOverlap = YES;
			}
		}
		
		CGFloat timeOverlap = 0;
		NSDate *hisStartTime = u[@"startTime"];
		NSDate *hisEndTime = u[@"endTime"];
		if (!hisStartTime || !hisEndTime) {
			timeOverlap = 0;
		}
		else {
			NSDateComponents* myStartComponents = [calendar components:flags fromDate:hisStartTime];
			NSDate* hisStartTimeOnly = [calendar dateFromComponents:myStartComponents];
			
			NSDateComponents* myEndComponents = [calendar components:flags fromDate:hisEndTime];
			NSDate* hisEndTimeOnly = [calendar dateFromComponents:myEndComponents];
			
			NSDate *startDateToUse;
			if ([myStartTimeOnly compare:hisStartTimeOnly] == NSOrderedDescending) {
				startDateToUse = myStartTimeOnly;
			} else {
				startDateToUse = hisStartTimeOnly;
			}
			
			NSDate *endDateToUse;
			if ([myEndTimeOnly compare:hisEndTimeOnly] == NSOrderedDescending) {
				endDateToUse = hisEndTimeOnly;
			}
			else {
				endDateToUse = myEndTimeOnly;
			}
			
			NSTimeInterval numerator = [endDateToUse timeIntervalSinceDate:startDateToUse];
			if (numerator < 0) {
				numerator = 0;
			}
			NSTimeInterval denom = [myEndTimeOnly timeIntervalSinceDate:myStartTimeOnly];
			if (denom == 0) {
				denom = 1;
			}
			timeOverlap = numerator / denom;
		}
		
		
		NSInteger hisWeight = [u[@"weight"] integerValue];
		NSInteger weightDiff = abs(myWeight - hisWeight);
		NSInteger weightValue = 0;
		if (weightDiff <= 10) {
			weightValue = 45;
		}
		else if (weightDiff <= 20) {
			weightValue = 35;
		}
		else if (weightDiff <= 30) {
			weightValue = 15;
		}
		else if (weightDiff <= 40) {
			weightValue = 5;
		}
		
		relevanceScore = ((locationOverlap) ? 1 : 0) * timeOverlap * (weightValue + (activityOverlap ? 30 : 5) + (intensityOverlap ? 25 : 10));
		
		u[@"relevance"] = @(relevanceScore);
		[self.usersToShow addObject:u];
	}
	
	NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"relevance"
																 ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
	self.usersToShow = [[self.usersToShow sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
	
	[SVProgressHUD dismiss];
	[self showNextUser];
}

-(void)showNextUser {
	self.nameLabel.text = self.usersToShow[self.counter][@"name"];
	
	NSString *intensityString = ([self.usersToShow[self.counter][@"intensities"] count] > 0) ? self.usersToShow[self.counter][@"intensities"][0] : @"";
	for (NSInteger x = 1; x < [self.usersToShow[self.counter][@"intensities"]count]; ++x) {
		NSString *str = self.usersToShow[self.counter][@"intensities"][x];
		intensityString = [NSString stringWithFormat:@"%@, %@", intensityString, str];
	}
	if (intensityString.length == 0) {
		intensityString = @"No Intensity Preference";
	}
	
	self.intensityLabel.text = intensityString;
	
	
	NSString *activityString = ([self.usersToShow[self.counter][@"activities"] count] > 0) ? self.usersToShow[self.counter][@"activities"][0] : @"";
	for (NSInteger x = 1; x < [self.usersToShow[self.counter][@"activities"]count]; ++x) {
		NSString *str = self.usersToShow[self.counter][@"activities"][x];
		activityString = [NSString stringWithFormat:@"%@, %@", activityString, str];
	}
	if (activityString.length == 0) {
		activityString = @"No Activity Preference";
	}
	
	self.workoutTypeLabel.text = activityString;
	
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"h:mm a"];
	
	NSString *timeString = [NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:self.usersToShow[self.counter][@"startTime"]], [formatter stringFromDate:self.usersToShow[self.counter][@"endTime"]]];
	self.timeLabel.text = timeString;
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
