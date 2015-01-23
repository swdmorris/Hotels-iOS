//
//  Hotel.m
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "Hotel.h"

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

- (NSNumber *)nightlyRate
{
    return [self.data objectForKey:@"nightly_rate"];
}

- (NSNumber *)promotedNightlyRate
{
    return [self.data objectForKey:@"promoted_nightly_rate"];
}

- (NSNumber *)totalRate
{
    return [self.data objectForKey:@"total_rate"];
}

- (NSNumber *)promotedTotalRate
{
    return [self.data objectForKey:@"promoted_total_rate"];
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
    return [self.data objectForKey:@"review_score"];
}

- (NSNumber *)starRating
{
    return [self.data objectForKey:@"star_rating"];
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