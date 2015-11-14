//
//  ViewController.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.nameLabel.text = @"Testing!!";
	self.nameLabel.text = @"Alex";
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
