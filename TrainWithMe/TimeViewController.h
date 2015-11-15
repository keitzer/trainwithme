//
//  TimeViewController.h
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/15/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeVCDelegate <NSObject>

-(void)timeVCTimesSaved:(NSDate*)startTime endTime:(NSDate*)endTime;
-(void)timeVCTimesCancelled;

@end

@interface TimeViewController : UIViewController

-(id)initWithStartTime:(NSDate*)startTime endTime:(NSDate*)endTime;

@property (nonatomic, weak) id <TimeVCDelegate> delegate;
@end
