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
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *starRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation HotelCell

- (void)setHotelName:(NSString *)hotelName price:(NSNumber *)price starRating:(NSNumber *)starRating distance:(NSNumber *)distance andThumbnailUrl:(NSURL *)thumbnailURL
{
    self.nameLabel.text = hotelName;
    [self.thumbnailImageView sd_setImageWithURL:thumbnailURL placeholderImage:[UIImage imageNamed:@"bkg_hotel.jpg"]];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    self.priceLabel.text = [numberFormatter stringFromNumber:price];
    
    self.starRatingLabel.text = [NSString stringWithFormat:@"%i/5 Stars", starRating.intValue];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", distance.floatValue];
}

@end
