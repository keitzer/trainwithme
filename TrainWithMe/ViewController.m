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

@interface ViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AccountVCDelegate>
@property (nonatomic, strong) NSMutableArray *buddyArray;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.buddyArray = [[NSMutableArray alloc] init];
	self.navigationItem.title = @"TrainWithMe";
	self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
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
	UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
	
	[self presentViewController:navBar animated:YES completion:nil];
}

-(IBAction)profilePressed {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	AccountViewController *accountVC = [storyboard instantiateViewControllerWithIdentifier:@"accountVC"];
	accountVC.delegate = self;
	UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:accountVC];
	
	[self presentViewController:navBar animated:YES completion:nil];
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
