//
//  UserDefaults.m
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults
static NSArray *hotels;

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
            
        }
        hotels = [mutableHotels copy];
    }
    
    return hotels;
}

@end
