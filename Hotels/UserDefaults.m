//
//  UserDefaults.m
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "UserDefaults.h"
#import "Hotel.h"

@implementation UserDefaults
static NSArray *hotels;

#pragma mark- Hotels
+ (NSArray *)hotels
{
    if (! hotels) {
        // read json from file
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hotels" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        // get hotel array
        NSArray *hotelDictionaries = [json objectForKey:@"hotels"];
        // create Hotel objects from hotel dictionaries
        NSMutableArray *mutableHotels = [NSMutableArray new];
        for (NSDictionary *hotelDictionary in hotelDictionaries) {
            [mutableHotels addObject:[[Hotel alloc] initWithDictionary:hotelDictionary]];
        }
        hotels = [mutableHotels copy];
    }
    
    return hotels;
}

#pragma mark- Location
#define LOCATION_LAT_KEY @"location_latitude"
#define LOCATION_LNG_KEY @"location_longitude"
+ (void)setLastKnownLocation:(CLLocation *)location
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:location.coordinate.latitude forKey:LOCATION_LAT_KEY];
    [userDefaults setFloat:location.coordinate.longitude forKey:LOCATION_LNG_KEY];
    [userDefaults synchronize];
}

+ (CLLocation *)lastKnownLocation
{
    float lat = [[NSUserDefaults standardUserDefaults] floatForKey:LOCATION_LAT_KEY];
    float lng = [[NSUserDefaults standardUserDefaults] floatForKey:LOCATION_LNG_KEY];
    
    if (lat != 0.0 && lng != 0.0) {
        return [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    } else {
        return nil;
    }
}

@end
