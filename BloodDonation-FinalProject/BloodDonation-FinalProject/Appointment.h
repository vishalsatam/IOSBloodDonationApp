//
//  Appointment.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/28/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#ifndef BloodDonation_FinalProject_Appointment_h
#define BloodDonation_FinalProject_Appointment_h


@interface Appointment : NSObject

@property(strong,atomic)NSString *apppointmentId;
@property(strong,atomic)NSDate *date;
@property(atomic)bool *booked;
@property(strong,atomic)NSString *uid;
@property(strong,atomic)NSString *collectionCenterId;
@property(atomic)BOOL *completed;

@end

#endif
