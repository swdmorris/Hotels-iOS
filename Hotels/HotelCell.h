//
//  HotelCell.h
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelCell : UITableViewCell

- (void)setHotelName:(NSString *)hotelName price:(NSNumber *)price starRating:(NSNumber *)starRating distance:(NSNumber *)distance andThumbnailUrl:(NSURL *)thumbnailURL;

@end
