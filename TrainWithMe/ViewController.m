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
#import "AccountViewController.h"
#import <Parse/Parse.h>
#import "Color.h"
#import "SearchViewController.h"

@interface ViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AccountVCDelegate, WelcomeVCDelegate>
@property (nonatomic, strong) NSMutableArray *buddyArray;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.buddyArray = [[NSMutableArray alloc] init];
	self.navigationItem.title = @"TrainWithMe";
	self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
	
	self.searchButton.layer.cornerRadius = self.searchButton.frame.size.width/2;
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	PFUser *currentUser = [PFUser currentUser];
	if (currentUser) {
		[[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			// do stuff with the user
			PFQuery *buddyQuery = [PFUser query];
			PFUser *currentUser = [PFUser currentUser];
			NSArray *friends = currentUser[@"friends"];
			if (!friends) {
				return;
			}
			
			[buddyQuery whereKey:@"objectId" containedIn:currentUser[@"friends"]];
			[buddyQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
				if (!error) {
					[self.buddyArray removeAllObjects];
					
					for (PFObject *object in objects) {
						NSDictionary *newBuddy = @{
												   @"name" : object[@"name"]
												   };
						[self.buddyArray addObject:newBuddy];
					}
					
					[self.tableView reloadData];
				}
				else {
					
				}
			}];
		}];
		
	} else {
		// show the signup or login screen
		[self presentWelcomeVC];
	}
	
}

-(void)presentWelcomeVC {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	WelcomeViewController *welcomeVC = [storyboard instantiateViewControllerWithIdentifier:@"welcomeVC"];
	welcomeVC.delegate = self;
	UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
	
	[self presentViewController:navBar animated:YES completion:nil];
}

-(void)signUpSuccess {
	//[self dismissViewControllerAnimated:NO completion:nil];
	//[self showProfileAnimated:NO];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	AccountViewController *accountVC = [storyboard instantiateViewControllerWithIdentifier:@"accountVC"];
	accountVC.delegate = self;
	UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:accountVC];
	
	[self.navigationController pushViewController:accountVC animated:YES];
}

-(IBAction)profilePressed {
	[self showProfileAnimated:YES];
}

-(void)showProfileAnimated:(BOOL)isAnimted {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	AccountViewController *accountVC = [storyboard instantiateViewControllerWithIdentifier:@"accountVC"];
	accountVC.delegate = self;
	UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:accountVC];
	
	[self presentViewController:navBar animated:isAnimted completion:nil];
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

-(IBAction)newSearchPressed {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	SearchViewController *searchVC = [storyboard instantiateViewControllerWithIdentifier:@"searchVC"];
	
	[self presentViewController:searchVC animated:YES completion:nil];
}

#pragma mark - Table View Stuff

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"tapped index: %zd", indexPath.row);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BuddyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
	[cell setName:self.buddyArray[indexPath.row][@"name"]];
	[cell setPicture:[UIImage imageNamed:@"profile.png"]];
	cell.backgroundColor = (indexPath.row %2 == 0) ? [UIColor colorBlue] : [UIColor colorDarkBlue];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
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
