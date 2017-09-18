//
//  ViewAppointmentViewController.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/29/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CollectionCenter.h"
#import "Appointment.h"
#import "MyAppointmentsTableViewController.h"

@interface ViewAppointmentViewController : UIViewController <MKMapViewDelegate,MKAnnotation>
@property (weak, nonatomic) IBOutlet MKMapView *bloodDonationCenterMapView;
@property(weak,atomic)CollectionCenter *bloodCollectionCenter;
@property(strong,atomic)Appointment *confirmedAppointment;

@property (weak, nonatomic) IBOutlet UILabel *bloodCollectionCenterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodCollectionCenterAddressLabel;
@property(strong,atomic)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *timeAndDateLabel;

- (IBAction)rescheduleAppointmentAction:(id)sender;
- (IBAction)cancelAppointmentAction:(id)sender;
- (IBAction)simulateApointmentAction:(id)sender;
@end
