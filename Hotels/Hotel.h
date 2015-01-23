//
//  Hotel.h
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hotel : NSObject

- (id)initWithDictionary:(NSDictionary *)data;

- (NSString *)name;
- (NSString *)streetAddress;
- (NSNumber *)nightlyRate;
- (NSNumber *)promotedNightlyRate;
- (NSNumber *)totalRate;
- (NSNumber *)promotedTotalRate;
- (NSNumber *)latitude;
- (NSNumber *)longitude;
- (NSNumber *)reviewScore;
- (NSNumber *)starRating;
- (NSURL *)thumbnailURL;

@end
