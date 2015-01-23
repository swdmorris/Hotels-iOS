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

@interface HotelListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *hotels;

@end

@implementation HotelListVC

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
    [cell setHotelName:hotel.name andThumbnailUrl:hotel.thumbnailURL];
    
    return cell;
}

@end
