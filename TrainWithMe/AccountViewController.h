//
//  AccountViewController.h
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountVCDelegate <NSObject>

-(void)accountVCSaved;
-(void)accountVCLoggedOut;

@end

@interface AccountViewController : UIViewController
@property (nonatomic, weak) id <AccountVCDelegate> delegate;
@end
