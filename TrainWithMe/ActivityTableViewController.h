//
//  ActivityTableViewController.h
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityVCDelegate <NSObject>

-(void)activityVCObjectsSelected:(NSArray*)objects asActivity:(BOOL)isActivity;
-(void)activityVCCancelled;

@end

@interface ActivityTableViewController : UITableViewController
-(id)initWithSelectedTypes:(NSArray*)selectedObjects asActivity:(BOOL)isActivity;

@property (nonatomic, weak) id <ActivityVCDelegate> delegate;
@end
