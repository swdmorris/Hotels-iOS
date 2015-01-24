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
#import <SDWebImage/UIImageView+WebCache.h>

@interface MapVC ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSMutableArray *hotels;

@end

@implementation MapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hotels = [[UserDefaults hotels] mutableCopy];
    [self setupAnnotations];
    [self zoomToAnnotations];
}

- (void)setupAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (Hotel *hotel in self.hotels) {
        HotelAnnotationView *annotationView = [[HotelAnnotationView alloc] init];
        annotationView.tag = [self.hotels indexOfObject:hotel]; // save index for accessing hotel
        [annotationView setCoordinate:CLLocationCoordinate2DMake(hotel.latitude.floatValue, hotel.longitude.floatValue)];
        [self.mapView addAnnotation:annotationView];
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
        Hotel *hotel = [self.hotels objectAtIndex:annotationView.tag];
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
    } else {
        return [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"userLocation"];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"Map region changed");
}

#pragma mark- End of lifecycle methods

- (void)dealloc
{
    self.mapView.delegate = nil;
}

@end
