//
//  HotelAnnotationView.m
//  Hotels
//
//  Created by Spencer Morris on 1/24/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "HotelAnnotationView.h"

@interface HotelAnnotationView ()

@property CLLocationCoordinate2D coordinate;

@end

@implementation HotelAnnotationView

@synthesize coordinate = _coordinate;

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

@end
