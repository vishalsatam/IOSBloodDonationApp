//
//  MyAppointmentsTableViewController.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/29/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCenter.h"
#import "Appointment.h"

@interface MyAppointmentsTableViewController : UITableViewController

@property(strong,atomic)NSMutableArray *myAppointments;
@property(strong,atomic)NSMutableArray *collectionCenterToBePassedArray;
@property(strong,atomic)CollectionCenter *collectionCenterToBePassed;

@end
