//
//  BuddyTableViewCell.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/14/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "BuddyTableViewCell.h"

@interface BuddyTableViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profilePicture;
@end

@implementation BuddyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)cellHeight {
	return 70;
}

-(void)setName:(NSString *)name {
	self.nameLabel.text = name;
}

-(void)setPicture:(UIImage *)image {
	self.profilePicture.layer.masksToBounds = YES;
	self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
	self.profilePicture.image = image;
}

@end
