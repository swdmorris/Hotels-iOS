//
//  HotelCalloutView.m
//  Hotels
//
//  Created by Spencer Morris on 1/25/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "HotelCalloutView.h"

@implementation HotelCalloutView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
}

@end
