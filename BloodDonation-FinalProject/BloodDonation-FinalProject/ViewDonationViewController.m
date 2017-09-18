//
//  ViewDonationViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/30/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import "ViewDonationViewController.h"
//Firebase import
#import <Firebase/Firebase.h>
#import "FireBaseConfig.h"
//End firebase import

@interface ViewDonationViewController ()

@end

@implementation ViewDonationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionCenterNameLabel.text = self.donation.collectionCenterName;
    NSString *typeOfDonation = self.donation.donationType;
    self.typeOfDonationImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",typeOfDonation]];
    if([typeOfDonation isEqualToString:@"platelets"]){
        self.typeOfDonationLabe.text = @"Platelets";
    }
    else if([typeOfDonation isEqualToString:@"double"]){
        self.typeOfDonationLabe.text = @"Double";
        
    }
    else{
        self.typeOfDonationLabe.text = @"Normal";
    }
    
 
    self.addressLabel.text = self.donation.address;
    UIImageView *imgViewToBeHighlighted = self.phase1ImageView;
    if([self.donation.donationPhase isEqualToString:@""] || self.donation.donationPhase == nil || [self.donation.donationPhase isEqualToString:@"1"]){
        imgViewToBeHighlighted = self.phase1ImageView;
    }
    else if ([self.donation.donationPhase isEqualToString:@"2"]){
        imgViewToBeHighlighted = self.phase2ImageView;
    }
    else if ([self.donation.donationPhase isEqualToString:@"3"]){
        imgViewToBeHighlighted = self.phase3ImageView;
    }
    else{
        imgViewToBeHighlighted = self.phase4ImageView;
    }
    
    UIColor *borderColor = [UIColor colorWithRed:83 green:224 blue:222 alpha:1.0];
    [imgViewToBeHighlighted.layer setBorderColor:[[UIColor redColor] CGColor]];
    [imgViewToBeHighlighted.layer setBorderWidth:3];
    
    self.pintsDonatedLabel.text = [NSString stringWithFormat:@"%@ Pints",self.donation.pintsDonated];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM-dd-yyyy hh:mm"];
    self.dateTimeLabel.text = [df stringFromDate:self.donation.dateOfDonation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)okAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)simulatePhaseAction:(id)sender {
    
    NSString *phaseToBeMovedTo = @"";
    if([self.donation.donationPhase isEqualToString:@""] || self.donation.donationPhase == nil || [self.donation.donationPhase isEqualToString:@"1"]){
        phaseToBeMovedTo = @"2";
    }
    else if ([self.donation.donationPhase isEqualToString:@"2"]){
        phaseToBeMovedTo = @"3";
    }
    else if ([self.donation.donationPhase isEqualToString:@"3"]){
        phaseToBeMovedTo = @"4";
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Blood has been stored" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    if(![phaseToBeMovedTo isEqualToString:@""]){
        Firebase *firebase = [[[FireBaseConfig alloc] init] getDonations];
        firebase = [[firebase childByAppendingPath:self.donation.donationId] childByAppendingPath:@"donationPhase"];
        [firebase setValue:phaseToBeMovedTo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Moved Phase" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    
}
@end
