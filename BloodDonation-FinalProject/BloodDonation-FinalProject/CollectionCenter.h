//
//  CollectionCenter.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#ifndef BloodDonation_FinalProject_CollectionCenter_h
#define BloodDonation_FinalProject_CollectionCenter_h
#import "Appointment.h"

@interface CollectionCenter :NSObject

@property(strong, atomic)NSString *collectionCenterId;
@property(strong, atomic)NSString *name;
@property(strong, atomic)NSString *zip;
@property(strong, atomic)NSString *address;
@property(strong, atomic)NSString *city;
@property(strong, atomic)NSNumber *latitude;
@property(strong, atomic)NSNumber *longitude;

@property(strong, atomic)NSMutableArray *appointments;
@end

#endif
