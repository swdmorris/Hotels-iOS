//
//  Hotel.m
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "Hotel.h"
#import "Utils.h"

@interface Hotel ()

@property (strong, nonatomic) NSDictionary *data;

@end

@implementation Hotel

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            // make sure data passed in is dictionary
            // (sometimes data from API can be NSNull)
            self.data = data;
        }
    }
    
    return self;
}

- (NSString *)name
{
    return [self.data objectForKey:@"name"];
}

- (NSString *)streetAddress
{
    return [self.data objectForKey:@"street_address"];
}

- (NSNumber *)totalRate
{
    NSString *totalRateString = [self.data objectForKey:@"total_rate"];
    
    if ([totalRateString isKindOfClass:[NSString class]]) {
        return [Utils numberFromString:totalRateString];
    } else if ([totalRateString isKindOfClass:[NSNumber class]]) {
        return (NSNumber *) totalRateString;
    } else {
        return nil;
    }
}

- (NSNumber *)latitude
{
    return [self.data objectForKey:@"latitude"];
}

- (NSNumber *)longitude
{
    return [self.data objectForKey:@"longitude"];
}

- (NSNumber *)reviewScore
{
    NSString *reviewScoreString = [self.data objectForKey:@"review_score"];
    
    if ([reviewScoreString isKindOfClass:[NSString class]]) {
        return [Utils numberFromString:reviewScoreString];
    } else if ([reviewScoreString isKindOfClass:[NSNumber class]]) {
        return (NSNumber *) reviewScoreString;
    } else {
        return nil;
    }
}

- (NSNumber *)starRating
{
    NSString *starRatingString = [self.data objectForKey:@"star_rating"];
    
    if ([starRatingString isKindOfClass:[NSString class]]) {
        return [Utils numberFromString:starRatingString];
    } else if ([starRatingString isKindOfClass:[NSNumber class]]) {
        return (NSNumber *) starRatingString;
    } else {
        return nil;
    }
}

- (NSNumber *)distance
{
    NSString *distanceString = [self.data objectForKey:@"distance"];
    
    if ([distanceString isKindOfClass:[NSString class]]) {
        return [Utils numberFromString:distanceString];
    } else if ([distanceString isKindOfClass:[NSNumber class]]) {
        return (NSNumber *) distanceString;
    } else {
        return nil;
    }
}

- (NSURL *)thumbnailURL
{
    NSString *thumbnailUrlString = [self.data objectForKey:@"thumbnail"];
    
    if ([thumbnailUrlString isKindOfClass:[NSString class]] && thumbnailUrlString.length > 0) {
        // check url because an NSNull or empty string will cause URLWithString to crash
        return [NSURL URLWithString:thumbnailUrlString];
    } else {
        return nil;
    }
}

@end


//"distance":"0.07",
//"direction":"S",
//"star_rating":"5",
//"name":"The Peninsula Chicago",
//"nightly_rate":"625.00",
//"promoted_nightly_rate":"625.00",
//"total_rate":"1439.10",
//"longitude":-87.625,
//"key":"160098_null_null_null_A2:0",
//"promoted_total_rate":"1439.10",
//"latitude":41.895200000000003,
//"master_id":160098,
//"thumbnail":"http://www.tnetnoc.com//hotelimages/298/84298/12556121/TBNL0-20100125-100011-293.jpg",
//"street_address":"108 East Superior Street",
//"review_score":5.0