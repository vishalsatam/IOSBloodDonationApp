//
//  ProfileViewController.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOfBirthTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *donorIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *bloodTypeTextField;

@property (strong,nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *chosenImage;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)saveButtonAction:(id)sender;
@end
