//
//  User.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/30/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#ifndef BloodDonation_FinalProject_User_h
#define BloodDonation_FinalProject_User_h

#import <Foundation/Foundation.h>
@interface User : NSObject

@property(atomic,strong)NSString *uid;
@property(atomic,strong)NSString *firstName;
@property(atomic,strong)NSString *lastName;
@property(atomic,strong)NSString *email;
@property(atomic,strong)NSData *profilePic;

@end
#endif
