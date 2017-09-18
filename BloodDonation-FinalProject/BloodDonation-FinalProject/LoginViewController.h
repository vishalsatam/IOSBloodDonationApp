//
//  LoginViewController.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/26/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#ifndef BloodDonation_FinalProject_LoginViewController_h
#define BloodDonation_FinalProject_LoginViewController_h
#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *HeaderLabel;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *facebookoginButton;



- (IBAction)loginAction:(id)sender;
- (IBAction)facebookLoginAction:(id)sender;

@end


#endif
