//
//  AvailableAppointmentViewController.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/28/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CollectionCenter.h"
#import "Appointment.h"

@interface AvailableAppointmentViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,MKAnnotation>

@property(weak,atomic)CollectionCenter *bloodCollectionCenter;
@property (weak, nonatomic) IBOutlet MKMapView *collectionCenterLocationMapView;
@property (weak, nonatomic) IBOutlet UIButton *timeSlotButton;
@property (weak, nonatomic) IBOutlet UITableView *timeSlotTableView;

@property (weak, nonatomic) IBOutlet UILabel *collectionCenterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionCenterAddressLabel;


@property(strong,atomic)CLLocationManager *locationManager;
@property(strong,atomic)NSMutableArray *dataForDropDown;

@property (weak, nonatomic) IBOutlet UIButton *confirmAppointmentAction;


@property(strong,atomic)Appointment *confirmedAppointment;



- (IBAction)confirmAppointmentAction:(id)sender;
- (IBAction)timeSlotButtonAction:(id)sender;
@end
