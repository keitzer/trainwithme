//
//  SignUpViewController.h
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignUpViewControllerDelegate <NSObject>

-(void)signUpViewControllerSucceeded;

@end

@interface SignUpViewController : UIViewController

@property (nonatomic, weak) id <SignUpViewControllerDelegate> delegate;
@end
