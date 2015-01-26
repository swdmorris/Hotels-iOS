//
//  HotelListVC.m
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "HotelListVC.h"
#import "HotelCell.h"
#import "Hotel.h"

#define kIndexPrice 0
#define kIndexLocation 1
#define kIndexRating 2

@interface HotelListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;

@property (strong, nonatomic) NSMutableArray *hotels;

@end

@implementation HotelListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // sort hotels based on initial selected segment
    [self sortCategoryChanged:self.sortSegmentedControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (NSMutableArray *)hotels
{
    if (! _hotels) {
        _hotels = [[UserDefaults hotels] mutableCopy];
    }
    
    return _hotels;
}

#pragma mark- UITableView datasource/delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hotels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotelCell"];
    
    Hotel *hotel = [self.hotels objectAtIndex:indexPath.row];
    [cell setHotelName:hotel.name price:hotel.totalRate starRating:hotel.starRating distance:hotel.distance andThumbnailUrl:hotel.thumbnailURL];
    
    return cell;
}
#pragma mark- Actions

- (IBAction)sortCategoryChanged:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == kIndexPrice) {
        
        [self.hotels sortUsingComparator:^NSComparisonResult(Hotel *hotel1, Hotel *hotel2) {
            return [hotel1.totalRate compare:hotel2.totalRate];
        }];
        
    } else if  (segmentedControl.selectedSegmentIndex == kIndexLocation) {
        
        [self.hotels sortUsingComparator:^NSComparisonResult(Hotel *hotel1, Hotel *hotel2) {
            return [hotel1.distance compare:hotel2.distance];
        }];
        
    } else if (segmentedControl.selectedSegmentIndex == kIndexRating) {
        
        [self.hotels sortUsingComparator:^NSComparisonResult(Hotel *hotel1, Hotel *hotel2) {
            if ([hotel1.starRating isEqualToNumber:hotel2.starRating]) {
                return [hotel1.name compare:hotel2.name];
            } else {
                return [hotel2.starRating compare:hotel1.starRating];
            }
        }];
        
    }
    
    [self.tableView reloadData];
}

@end
