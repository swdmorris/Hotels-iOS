//
//  HotelCell.m
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "HotelCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HotelCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;

@end

@implementation HotelCell

- (void)setHotelName:(NSString *)hotelName andThumbnailUrl:(NSURL *)thumbnailURL
{
    self.nameLabel.text = hotelName;
    [self.thumbnailImageView sd_setImageWithURL:thumbnailURL placeholderImage:[UIImage imageNamed:@"bkg_hotel.jpg"]];
}

@end
