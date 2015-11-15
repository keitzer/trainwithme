//
//  MapViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/15/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "MapViewController.h"
#import <ArcGIS/ArcGIS.h>
#import "Color.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"

// http://arcg.is/1MK4RyI

@interface MapViewController () <AGSWebMapDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet AGSMapView *mapView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AGSWebMap *webMap;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSMutableArray *allLocations;
@end

@implementation MapViewController

-(id)initWithSavedLocations:(NSArray *)locations {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	self = [storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
	self.locations = [locations mutableCopy];
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	//Add a basemap tiled layer
	NSURL* url = [NSURL URLWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/Canvas/World_Light_Gray_Base/MapServer"];
	AGSTiledMapServiceLayer *tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
	[self.mapView addMapLayer:tiledLayer withName:@"Basemap Tiled Layer"];
	
	AGSCredential *credential = [[AGSCredential alloc] initWithUser:@"keitzer" password:@"io55T77t" authenticationType:AGSAuthenticationTypeToken];
	self.webMap = [AGSWebMap webMapWithItemId:@"e558e392a4dd4b3daf87cb65b2b2ce06" credential:credential];
	self.webMap.delegate = self;
	[self.webMap openIntoMapView:self.mapView];
	
	self.navigationController.navigationBar.barTintColor = [UIColor colorTeal];
	self.navigationItem.title = @"Location";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
	
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	self.allLocations = [[NSMutableArray alloc] init];
	
	PFQuery *query = [PFQuery queryWithClassName:@"Location"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		[SVProgressHUD dismiss];
		
		if (!error) {
			for (PFObject *loc in objects) {
				BOOL shouldBeChecked = NO;
				for (NSDictionary *savedLoc in self.locations) {
					shouldBeChecked = [savedLoc[@"id"] isEqualToString:loc.objectId];
					if (shouldBeChecked) {
						break;
					}
				}
				
				NSDictionary *type = @{
									   @"id" : loc.objectId,
									   @"name" : loc[@"name"],
									   @"checked" : @(shouldBeChecked)
									   };
				[self.allLocations addObject:type];
			}
			[self.tableView reloadData];
		}
		else {
			
		}
	}];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[SVProgressHUD showWithStatus:@"Loading Map..."];
}

-(void)savePressed {
	NSMutableArray *savedLocations = [[NSMutableArray alloc] init];
	for (NSDictionary *loc in self.allLocations) {
		if ([loc[@"checked"] boolValue]) {
			[savedLocations addObject:@{
										@"id" : loc[@"id"],
										@"name" : loc[@"name"]
										}];
		}
	}
	
	if (self.delegate) {
		[self.delegate mapVCSavedLocation:savedLocations];
	}
}

-(void)cancelPressed {
	if (self.delegate) {
		[self.delegate mapVCCancelled];
	}
}


- (void) webMapDidLoad:(AGSWebMap*) webMap {
	//webmap data was retrieved successfully
	NSLog(@"success!");
	[SVProgressHUD dismiss];
}

- (void) webMap:(AGSWebMap *)webMap didFailToLoadWithError:(NSError *)error {
	//webmap data was not retrieved
	//alert the user
	NSLog(@"Error while loading webmap: %@",[error localizedDescription]);
}

-(void)didOpenWebMap:(AGSWebMap*)webMap intoMapView:(AGSMapView*)mapView{
	//web map finished opening
}

-(void)webMap:(AGSWebMap*)wm didLoadLayer:(AGSLayer*)layer{
	//layer in web map loaded properly
}

-(void)webMap:(AGSWebMap*)wm didFailToLoadLayer:(NSString*)layerTitle url:(NSURL*)url baseLayer:(BOOL)baseLayer federated:(BOOL)federated withError:(NSError*)error{
	NSLog(@"Error while loading layer: %@",[error localizedDescription]);
	
	//you can skip loading this layer
	//[self.webMap continueOpenAndSkipCurrentLayer];
	
	//or you can try loading it with proper credentials if the error was security related
	//[self.webMap continueOpenWithCredential:credential];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.allLocations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
	// Configure the cell...
	cell.textLabel.font = [UIFont fontWithName:@"Comfortaa-Regular" size:18];
	cell.textLabel.text = self.allLocations[indexPath.row][@"name"];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor colorTeal] : [UIColor colorDarkTeal];
	
	BOOL checked = [self.allLocations[indexPath.row][@"checked"] boolValue];
	if (checked) {
		UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coloredCheckmark.png"]];
		checkmark.frame = CGRectMake(0, 0, 40, 40);
		cell.accessoryView = checkmark;
	}
	else {
		cell.accessoryView = nil;
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BOOL checked = ![self.allLocations[indexPath.row][@"checked"] boolValue];
	self.allLocations[indexPath.row] = @{
										 @"id" : self.allLocations[indexPath.row][@"id"],
										 @"name" : self.allLocations[indexPath.row][@"name"],
										 @"checked" : @(checked)
										};
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	
	if (checked) {
		UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coloredCheckmark.png"]];
		checkmark.frame = CGRectMake(0, 0, 40, 40);
		cell.accessoryView = checkmark;
	}
	else {
		cell.accessoryView = nil;
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
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
