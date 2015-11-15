//
//  MapViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/15/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "MapViewController.h"
#import <ArcGIS/ArcGIS.h>

// http://arcg.is/1MK4RyI

@interface MapViewController () <AGSWebMapDelegate>
@property (nonatomic, weak) IBOutlet AGSMapView *mapView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AGSWebMap *webMap;
@property (nonatomic, strong) NSMutableArray *locations;
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
	self.webMap = [AGSWebMap webMapWithItemId:@"768f7b14e385444897c075b60a0e2996" credential:credential];
	self.webMap.delegate = self;
	[self.webMap openIntoMapView:self.mapView];
}


- (void) webMapDidLoad:(AGSWebMap*) webMap {
	//webmap data was retrieved successfully
	NSLog(@"success!");
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
