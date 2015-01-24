//
//  HotelGroupAnnotationView.m
//  Hotels
//
//  Created by Spencer Morris on 1/24/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "HotelGroupAnnotationView.h"

@interface HotelGroupAnnotationView ()

@property CLLocationCoordinate2D coordinate;

@end

@implementation HotelGroupAnnotationView

@synthesize coordinate = _coordinate, title = _title;

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
}

- (NSString *)title
{
    return _title;
}

- (BOOL)canShowCallout
{
    return YES;
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        // TODO: show callout
    } else {
        // TOOD: hide callout
    }
}

@end
