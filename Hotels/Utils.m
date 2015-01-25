//
//  Utils.m
//  Hotels
//
//  Created by Spencer Morris on 1/24/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSNumber *)numberFromString:(NSString *)string
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [f numberFromString:string];
}

@end
