//
//  AccountViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "AccountViewController.h"
#import <Parse/Parse.h>

@interface AccountViewController ()
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *heightTextField;
@property (nonatomic, weak) IBOutlet UITextField *weightTextField;
@property (nonatomic, weak) IBOutlet UIButton *activityButton;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;
@property (nonatomic, weak) IBOutlet UIButton *timeButton;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
}

-(IBAction)savePressed {
	if (self.delegate) {
		[self.delegate accountVCSaved];
	}
}

-(IBAction)logOutPressed {
	if (self.delegate) {
		[self.delegate accountVCLoggedOut];
	}
}

-(IBAction)activityPressed {
	NSLog(@"activity pressed");
}

-(IBAction)locationPressed {
	NSLog(@"location pressed");
}

-(IBAction)timePressed {
	NSLog(@"time pressed");
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
