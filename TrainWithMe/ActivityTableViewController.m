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
@property (nonatomic, strong) NSMutableArray *activityTypes; //array of dictionaries
@end

@implementation ActivityTableViewController

-(id)initWithSelectedTypes:(NSArray *)selectedObjects {
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.activityTypes = [[NSMutableArray alloc] init];
	
	PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (!error) {
			for (PFObject *object in objects) {
				NSDictionary *type = @{
									   @"name" : object[@"name"],
									   @"checked" : @NO
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
		NSMutableArray *savedObjects = [[NSMutableArray alloc] init];
		for (NSDictionary *activity in self.activityTypes) {
			if ([activity[@"checked"] boolValue]) {
				[savedObjects addObject:activity];
			}
		}
		
		[self.delegate activityVCObjectsSelected:savedObjects];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    // Configure the cell...
	cell.textLabel.text = self.activityTypes[indexPath.row][@"name"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
