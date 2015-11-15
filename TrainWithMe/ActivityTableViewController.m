//
//  ActivityTableViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "ActivityTableViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"

@interface ActivityTableViewController ()
@property (nonatomic, strong) NSMutableArray *savedTypes; //array of strings (names)
@property (nonatomic, strong) NSMutableArray *activityTypes; //array of dictionaries
@property (nonatomic, assign) BOOL isActivity;
@end

@implementation ActivityTableViewController

-(id)initWithSelectedTypes:(NSArray *)selectedObjects asActivity:(BOOL)isActivity {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	ActivityTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"activityVC"];
	vc.savedTypes = [selectedObjects mutableCopy];
	vc.isActivity = isActivity;
	
	return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.activityTypes = [[NSMutableArray alloc] init];
	
	[SVProgressHUD showWithStatus:@"Loading Activities..."];
	
	NSString *className = @"Activity";
	if (!self.isActivity) {
		className = @"Intensity";
		self.navigationItem.title = @"Intensities";
	}
	else {
		self.navigationItem.title = @"Activities";
	}
	PFQuery *query = [PFQuery queryWithClassName:className];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		[SVProgressHUD dismiss];
		
		if (!error) {
			for (PFObject *object in objects) {
				BOOL shouldBeChecked = [self.savedTypes containsObject:object[@"name"]];
				
				NSDictionary *type = @{
									   @"name" : object[@"name"],
									   @"checked" : @(shouldBeChecked)
									   };
				[self.activityTypes addObject:type];
			}
			[self.tableView reloadData];
		}
		else {
			
		}
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.activityTypes.count;
}

-(IBAction)cancelPressed {
	if (self.delegate) {
		[self.delegate activityVCCancelled];
	}
}

-(IBAction)savePressed {
	if (self.delegate) {
		[self.savedTypes removeAllObjects];
		for (NSDictionary *activity in self.activityTypes) {
			if ([activity[@"checked"] boolValue]) {
				[self.savedTypes addObject:activity[@"name"]];
			}
		}
		
		[self.delegate activityVCObjectsSelected:self.savedTypes asActivity:self.isActivity];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    // Configure the cell...
	cell.textLabel.text = self.activityTypes[indexPath.row][@"name"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	BOOL checked = [self.activityTypes[indexPath.row][@"checked"] boolValue];
	if (checked) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BOOL checked = ![self.activityTypes[indexPath.row][@"checked"] boolValue];
	self.activityTypes[indexPath.row] = @{
										  @"name" : self.activityTypes[indexPath.row][@"name"],
										  @"checked" : @(checked)
										  };
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if (checked) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
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
