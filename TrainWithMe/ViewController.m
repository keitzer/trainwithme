//
//  ViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "ViewController.h"
#import "WelcomeViewController.h"
#import "BuddyTableViewCell.h"
#import <Parse/Parse.h>

@interface ViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) NSMutableArray *buddyArray;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.nameLabel.text = @"Alex";
	
	self.buddyArray = [[NSMutableArray alloc] init];
	
	for (NSInteger x = 0; x < 20; ++x) {
		NSDictionary *newBuddy = @{
								   @"name" : [NSString stringWithFormat:@"Name %zd", x+1],
								   @"location" : @"Columbus"
								   };
		[self.buddyArray addObject:newBuddy];
	}
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	PFUser *currentUser = [PFUser currentUser];
	if (currentUser) {
		// do stuff with the user
	} else {
		// show the signup or login screen
		[self presentWelcomeVC];
	}
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	PFObject *gym = [PFObject objectWithClassName:@"Gym"];
	gym[@"Name"] = textField.text;
	[gym saveInBackground];
	
	return YES;
}

-(IBAction)logOut {
	[PFUser logOut];
	[self presentWelcomeVC];
}

-(void)presentWelcomeVC {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	WelcomeViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"welcomeVC"];
	UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
	
	[self presentViewController:navBar animated:YES completion:nil];
}

#pragma mark - Table View Stuff

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"tapped index: %zd", indexPath.row);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BuddyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
	[cell setName:self.buddyArray[indexPath.row][@"name"]];
	[cell setPicture:[UIImage imageNamed:@"profile.png"]];
	
	return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.buddyArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [BuddyTableViewCell cellHeight];
}

@end
