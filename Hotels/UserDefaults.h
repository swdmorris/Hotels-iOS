//
//  UserDefaults.h
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UserDefaults : NSObject

#pragma mark- Hotels
+ (NSArray *)hotels;

#pragma mark- Location
+ (void)setLastKnownLocation:(CLLocation *)location;
+ (CLLocation *)lastKnownLocation;

@end
