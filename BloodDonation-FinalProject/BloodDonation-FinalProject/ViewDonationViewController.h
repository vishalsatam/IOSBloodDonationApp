//
//  ViewDonationViewController.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/30/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Donation.h"
#import "CollectionCenter.h"



@interface ViewDonationViewController : UIViewController

@property(strong,atomic)Donation *donation;

@property (weak, nonatomic) IBOutlet UILabel *donatedquantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfDonationLabe;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionCenterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeOfDonationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phase1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phase2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phase3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *phase4ImageView;
@property (weak, nonatomic) IBOutlet UILabel *pintsDonatedLabel;
- (IBAction)okAction:(id)sender;
- (IBAction)simulatePhaseAction:(id)sender;
@end
