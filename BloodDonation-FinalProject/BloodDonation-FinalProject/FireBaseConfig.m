//
//  FireBaseConfig.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FireBaseConfig.h"


@implementation FireBaseConfig



-(void)initialize{
    self.BASE_URL = @"https://bdfinalproject.firebaseio.com";
}

-(id)currentUser{
    [self initialize];
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSString *firstSub = @"users";
    NSString *finalPath = [NSString stringWithFormat:@"%@/%@/%@",self.BASE_URL,firstSub,userId];
    NSLog(@"Path created : %@",finalPath);
    Firebase *user = [[Firebase alloc] initWithUrl:finalPath];
    return user;
    
}

-(NSString *)getFireBaseUrl{
    [self initialize];
    return self.BASE_URL;
}

-(id)getFirebasInstance{
    [self initialize];
    Firebase *fb = [[Firebase alloc] initWithUrl:self.getFireBaseUrl];
    NSLog(@"FIREBASE PATH created : %@",fb);
    return fb;

}


-(id)getAppointments{
    [self initialize];
    Firebase *fb = [[Firebase alloc] initWithUrl:self.getFireBaseUrl];
    fb =  [fb childByAppendingPath:@"Appointments"];
    fb = [fb childByAppendingPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]];
    NSLog(@"appointments PATH created : %@",fb);
    return fb;
}

-(id)getDonations{
    [self initialize];
    Firebase *fb = [[Firebase alloc] initWithUrl:self.getFireBaseUrl];
    fb =  [fb childByAppendingPath:@"Donations"];
    fb = [fb childByAppendingPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]];
    NSLog(@"donations PATH created : %@",fb);
    return fb;
}

-(NSString *)getCollectionCenterUrl{
    [self initialize];
    return [NSString stringWithFormat:@"%@/%@",self.BASE_URL,@"CollectionCenters"];
}


-(id)getCollectionCenter{
    [self initialize];
    //NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    NSString *firstSub = @"CollectionCenters";
    NSString *finalPath = [NSString stringWithFormat:@"%@/%@",self.BASE_URL,firstSub];
    NSLog(@"Path created : %@",finalPath);
    Firebase *user = [[Firebase alloc] initWithUrl:finalPath];
    return user;
}

-(NSString *)getUID{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
}

@end