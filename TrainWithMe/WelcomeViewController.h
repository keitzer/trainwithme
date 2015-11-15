//
//  WelcomeViewController.h
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WelcomeVCDelegate <NSObject>

-(void)signUpSuccess;

@end

@interface WelcomeViewController : UIViewController

@property (nonatomic, weak) id <WelcomeVCDelegate> delegate;
@end
