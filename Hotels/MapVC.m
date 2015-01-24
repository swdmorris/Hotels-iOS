//
//  MapVC.m
//  Hotels
//
//  Created by Spencer Morris on 1/23/15.
//  Copyright (c) 2015 SpencerMorris. All rights reserved.
//

#import "MapVC.h"
#import "Hotel.h"
#import "HotelAnnotationView.h"
#import "HotelGroupAnnotationView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MapVC ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSMutableArray *hotelGroups;
@property MKCoordinateSpan lastMapCoordinateSpan;

@end

@implementation MapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupAnnotations];
    [self zoomToAnnotations];
}

- (void)setupAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // figure out map region so hotels near each other can be grouped
    CGFloat mapLatDelta = self.mapView.region.span.latitudeDelta;
    CGFloat mapLngDelta = self.mapView.region.span.longitudeDelta;
    
    // group close hotels
    CGFloat groupingDistanceThreshold = 0.05 * (mapLatDelta + mapLngDelta);
    self.hotelGroups = [NSMutableArray new];
    for (Hotel *hotel in [UserDefaults hotels]) {
        BOOL groupFound = NO;
        
        for (NSMutableArray *hotelList in self.hotelGroups) {
            if (! groupFound) {
                for (Hotel *groupHotel in hotelList) {
                    if (ABS(hotel.latitude.floatValue - groupHotel.latitude.floatValue) + ABS(hotel.longitude.floatValue - groupHotel.longitude.floatValue) < groupingDistanceThreshold) {
                        groupFound = YES;
                    }
                }
                if (groupFound) {
                    [hotelList addObject:hotel];
                }
            }
        }
        
        if (! groupFound) {
            [self.hotelGroups addObject:[NSMutableArray arrayWithObject:hotel]];
        }
    }
    
    for (NSArray *hotels in self.hotelGroups) {
        
        if (hotels.count > 1) {
            HotelGroupAnnotationView *annotationView = [[HotelGroupAnnotationView alloc] init];
            Hotel *hotel = [hotels firstObject]; // use first hotel for location
            annotationView.tag = [self.hotelGroups indexOfObject:hotels]; // save index for accessing hotel
            [annotationView setCoordinate:CLLocationCoordinate2DMake(hotel.latitude.floatValue, hotel.longitude.floatValue)];
            [self.mapView addAnnotation:annotationView];
        } else {
            HotelAnnotationView *annotationView = [[HotelAnnotationView alloc] init];
            Hotel *hotel = [hotels firstObject];
            annotationView.tag = [self.hotelGroups indexOfObject:hotels]; // save index for accessing hotel
            [annotationView setCoordinate:CLLocationCoordinate2DMake(hotel.latitude.floatValue, hotel.longitude.floatValue)];
            [self.mapView addAnnotation:annotationView];
        }
    }
}

- (void)zoomToAnnotations
{
    CGFloat minLat = CGFLOAT_MAX;
    CGFloat maxLat = - CGFLOAT_MAX;
    CGFloat minLng = CGFLOAT_MAX;
    CGFloat maxLng = - CGFLOAT_MAX;
    
    for (HotelAnnotationView *annotationView in self.mapView.annotations) {
        minLat = MIN(minLat, annotationView.coordinate.latitude);
        maxLat = MAX(maxLat, annotationView.coordinate.latitude);
        minLng = MIN(minLng, annotationView.coordinate.longitude);
        maxLng = MAX(maxLng, annotationView.coordinate.longitude);
    }
    
    CGFloat centerLat = (maxLat - minLat) / 2.0 + minLat;
    CGFloat centerLng = (maxLng - minLng) / 2.0 + minLng;
    CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake(centerLat, centerLng);
    CGFloat paddingRatio = 1.5;
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake((maxLat - minLat) * paddingRatio, (maxLng - minLng) * paddingRatio);
    [self.mapView setRegion:MKCoordinateRegionMake(centerCoord, coordinateSpan) animated:YES];
}

#pragma mark- MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[HotelAnnotationView class]]) {
        HotelAnnotationView *annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hotelAnnotation"];
        [annotationView setImage:[UIImage imageNamed:@"icon_pin"]];
        
        // setup hotel image
        NSArray *hotels = [self.hotelGroups objectAtIndex:annotationView.tag];
        Hotel *hotel = hotels.firstObject;
        UIImageView *hotelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [hotelImageView setContentMode:UIViewContentModeScaleAspectFill];
        [hotelImageView setClipsToBounds:YES];
        [hotelImageView sd_setImageWithURL:hotel.thumbnailURL placeholderImage:[UIImage imageNamed:@"bkg_hotel.jpg"]];
        [annotationView setLeftCalloutAccessoryView:hotelImageView];
        
        // setup hotel name label
        UILabel *hotelNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150.0, 40.0)];
        hotelNameLabel.text = hotel.name;
        annotationView.rightCalloutAccessoryView = hotelNameLabel;
        
        return annotationView;
    } else if ([annotation isKindOfClass:[HotelGroupAnnotationView class]]) {
        HotelGroupAnnotationView *annotationView = [[HotelGroupAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hotelGroupAnnotation"];
        annotationView.tag = ((UIView *) annotation).tag;
        [annotationView setImage:[UIImage imageNamed:@"icon_group_pin"]];
        
        NSArray *hotels = [self.hotelGroups objectAtIndex:annotationView.tag];
        CGRect labelFrame = CGRectMake(0.0, 4.0, annotationView.frame.size.width, annotationView.frame.size.height / 2.0);
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:labelFrame];
        numberLabel.text = [NSString stringWithFormat:@"%i", (int) hotels.count];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.layer.cornerRadius = labelFrame.size.height / 2.0;
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.minimumScaleFactor = 0.5;
        [annotationView addSubview:numberLabel];
        
        return annotationView;
    } else {
        return [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userLocation"];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"Map region changed");
    if (ABS(mapView.region.span.latitudeDelta - self.lastMapCoordinateSpan.latitudeDelta) / mapView.region.span.latitudeDelta > 0.01
        || ABS(mapView.region.span.longitudeDelta - self.lastMapCoordinateSpan.longitudeDelta) / mapView.region.span.longitudeDelta > 0.01) {
        // only set annotations if zoom level (region span) changes somewhat significantly
        [self setupAnnotations];
        self.lastMapCoordinateSpan = mapView.region.span;
    }
}

#pragma mark- End of lifecycle methods

- (void)dealloc
{
    self.mapView.delegate = nil;
}

@end
