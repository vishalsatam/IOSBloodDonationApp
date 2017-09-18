//
//  CollectionCenter.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/28/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionCenter.h"

@implementation CollectionCenter

-(id)init{
    self = [super init];
    self.appointments = [[NSMutableArray alloc] init];
    return self;
}

@end