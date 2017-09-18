//
//  HomeScreenViewController.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#ifndef BloodDonation_FinalProject_HomeScreenViewController_h
#define BloodDonation_FinalProject_HomeScreenViewController_h

#import <UIKit/UIKit.h>
@interface HomeScreenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *profilePicButton;

- (IBAction)profilePicAction:(id)sender;
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *qtyOfBloodTextView;
@property (weak, nonatomic) IBOutlet UILabel *bloodTypeTextView;
- (IBAction)requestBloodAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *inviteOthersAction;


@end

#endif
