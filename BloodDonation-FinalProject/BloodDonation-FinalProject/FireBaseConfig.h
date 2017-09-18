//
//  FireBaseConfig.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#ifndef BloodDonation_FinalProject_FireBaseConfig_h
#define BloodDonation_FinalProject_FireBaseConfig_h
#import <Firebase/Firebase.h>

@interface FireBaseConfig : NSObject 

@property(strong,atomic)NSString *BASE_URL;

-(id)currentUser;
-(NSString *)getFireBaseUrl;
-(NSString *)getUID;
-(id)getCollectionCenter;
-(NSString *)getCollectionCenterUrl;
-(id)getAppointments;
-(id)getDonations;
-(id)getFirebasInstance;
@end
#endif
