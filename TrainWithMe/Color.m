//
//  Color.m
//  TrainWithMe
//
//  Created by Alex Ogorek on 11/15/15.
//  Copyright © 2015 OHIOHack. All rights reserved.
//

#import "Color.h"

@implementation UIColor (Train)

+(UIColor *)colorBlue {
	return [UIColor colorWithHexString:@"657FFF"];
}

+(UIColor *)colorDarkBlue {
	return [UIColor colorWithHexString:@"5e76ed"];
}

+(UIColor *)colorRed {
	return [UIColor colorWithHexString:@"F55971"];
}

+(UIColor *)colorOrange {
	return [UIColor colorWithHexString:@"FDA319"];
}

+(UIColor *)colorTeal {
	return [UIColor colorWithHexString:@"60E8B1"];
}

+(UIColor *)colorDarkTeal {
	return [UIColor colorWithHexString:@"59d6a3"];
}

+(UIColor *)colorYellow {
	return [UIColor colorWithHexString:@"FFFA5D"];
}

+ (UIColor*)colorWithHexString:(NSString*)hex
{
	NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 6 or 8 characters
	if ([cString length] < 6) return [UIColor grayColor];
	
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
	
	if ([cString length] != 6) return  [UIColor grayColor];
	
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	float fr = (float)r;
	float fg = (float)g;
	float fb = (float)b;
	
	UIColor *color = [UIColor colorWithRed:((float) fr / 255.0f)
									 green:((float) fg / 255.0f)
									  blue:((float) fb / 255.0f)
									 alpha:1.0f];
	return color;
}
@end
