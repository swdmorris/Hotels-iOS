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
#import "HotelCalloutView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MapVC ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) HotelCalloutView *calloutView;
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

- (HotelCalloutView *)calloutView
{
    if (! _calloutView) {
        _calloutView = [[[NSBundle mainBundle] loadNibNamed:@"HotelCalloutView" owner:self options:nil] firstObject];
        _calloutView.frame = CGRectMake(0.0, - _calloutView.frame.size.height, _calloutView.frame.size.width, _calloutView.frame.size.height);
    }
    
    return _calloutView;
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
            
            // find average position of hotels
            CGFloat totalLatitude = 0.0, totalLongitude = 0.0;
            for (Hotel *hotel in hotels) {
                totalLatitude += hotel.latitude.floatValue;
                totalLongitude += hotel.longitude.floatValue;
            }
            CGFloat avgLatitude = totalLatitude / hotels.count;
            CGFloat avgLongitude = totalLongitude / hotels.count;
            
            annotationView.tag = [self.hotelGroups indexOfObject:hotels]; // save index for accessing hotel
            [annotationView setCoordinate:CLLocationCoordinate2DMake(avgLatitude, avgLongitude)];
            annotationView.title = [NSString stringWithFormat:@"%i hotels near here", (int) hotels.count];
            [self.mapView addAnnotation:annotationView];
        } else {
            HotelAnnotationView *annotationView = [[HotelAnnotationView alloc] init];
            Hotel *hotel = [hotels firstObject];
            annotationView.tag = [self.hotelGroups indexOfObject:hotels]; // save index for accessing hotel
            [annotationView setCoordinate:CLLocationCoordinate2DMake(hotel.latitude.floatValue, hotel.longitude.floatValue)];
#warning
            annotationView.canShowCallout = YES;
            annotationView.title = hotel.name;
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
    
    for (Hotel *hotel in [UserDefaults hotels]) {
        minLat = MIN(minLat, hotel.latitude.floatValue);
        maxLat = MAX(maxLat, hotel.latitude.floatValue);
        minLng = MIN(minLng, hotel.longitude.floatValue);
        maxLng = MAX(maxLng, hotel.longitude.floatValue);
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
        // view for annotation with ONE hotel
        HotelAnnotationView *annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"hotelAnnotation"];
        annotationView.tag = ((UIView *) annotation).tag; // save tag for index of hotel
        [annotationView setImage:[UIImage imageNamed:@"icon_pin"]];
        
        return annotationView;
    } else if ([annotation isKindOfClass:[HotelGroupAnnotationView class]]) {
        // view for annotation with MANY hotels
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[HotelAnnotationView class]]) {
        NSArray *hotels = [self.hotelGroups objectAtIndex:view.tag];
        Hotel *hotel = hotels.firstObject;
        // set hotel properties
        self.calloutView.nameLabel.text = hotel.name;
        [self.calloutView.thumbnailImageView sd_setImageWithURL:hotel.thumbnailURL placeholderImage:[UIImage imageNamed:@"bkg_hotel.jpg"]];
        // set position of callout (centered in map)
        CGFloat originX = - self.calloutView.frame.size.width / 2.0; // center callout
        // make sure callout is not off left edge of screen
        originX = MAX(originX, - view.frame.origin.x);
        // make sure callout is not off right edge of screen
        originX = MIN(originX, self.mapView.frame.size.width - self.calloutView.frame.size.width - view.frame.origin.x);
        
        self.calloutView.frame = CGRectMake(originX, self.calloutView.frame.origin.y, self.calloutView.frame.size.width, self.calloutView.frame.size.height);
        
        [view addSubview:self.calloutView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [self.calloutView removeFromSuperview];
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
    self.calloutView = nil;
}

@end
