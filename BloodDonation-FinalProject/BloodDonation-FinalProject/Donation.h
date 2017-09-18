//
//  Donation.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/29/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#ifndef BloodDonation_FinalProject_Donation_h
#define BloodDonation_FinalProject_Donation_h

@interface Donation :NSObject

@property(strong,atomic)NSString *donationId;
@property(strong,atomic)NSString *collectionCenterName;
@property(strong,atomic)NSNumber *pintsDonated;
@property(strong,atomic)NSDate *dateOfDonation;
@property(strong,atomic)NSString *donationType;
@property(strong,atomic)NSString *appointmentId;
@property(strong,atomic)NSString *address;
@property(strong,atomic)NSString *donationPhase;


@end

#endif
