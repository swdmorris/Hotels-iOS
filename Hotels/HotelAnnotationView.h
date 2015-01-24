//
//  HotelAnnotationView.h
//  Hotels
//
//  Created by Spencer Morris on 1/24/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface HotelAnnotationView : MKAnnotationView <MKAnnotation>

- (CLLocationCoordinate2D)coordinate;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (NSString *)title;
- (void)setTitle:(NSString *)title;

@end
