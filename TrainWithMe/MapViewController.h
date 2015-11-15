//
//  MapViewController.h
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/15/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapVCDelegate <NSObject>

-(void)mapVCSavedLocation:(NSArray*)locations;
-(void)mapVCCancelled;

@end

@interface MapViewController : UIViewController
-(id)initWithSavedLocations:(NSArray*)locations;
@property (nonatomic, weak) id <MapVCDelegate> delegate;
@end
