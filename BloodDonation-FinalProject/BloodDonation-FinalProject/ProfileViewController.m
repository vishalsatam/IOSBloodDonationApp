//
//  ProfileViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import "ProfileViewController.h"
//Firebase import
#import <Firebase/Firebase.h>
#import "FireBaseConfig.h"
//End firebas import


@interface ProfileViewController ()

@end

@implementation ProfileViewController
UIDatePicker *datePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Image Gesture Recgnizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageClicked:)];
    singleTap.numberOfTapsRequired = 1;
    [self.profilePicImageView setUserInteractionEnabled:YES];
    [self.profilePicImageView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    
    //Date Picker LOGIC starts
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setMaximumDate:[[NSDate alloc] init]];
    
    //self.dateOfBirthTextField = [self createTextFieldWithPlaceHolder:@"  Date Of Birth" andPosX:20.0 posY:110.0 width:200.0 height:20.0];
    [self.dateOfBirthTextField setInputView:datePicker];
    [self.view addSubview:self.dateOfBirthTextField];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(showSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneButton, nil]];
    [self.dateOfBirthTextField setInputAccessoryView:toolBar];
    
    //End of Date Picker Logic
    
    
    //headerImageReize and set the image
    //Make the image rounded
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.width / 2;
    self.profilePicImageView.clipsToBounds = YES;
    
    
    self.profilePicImageView.image = [UIImage imageNamed:@"noPhoto.jpg"];
    self.profilePicImageView.backgroundColor = [UIColor colorWithRed:220 green:225 blue:228 alpha:1.0];
    //headerImageresize code ends
    
    //disable email field
    self.emailTextField.userInteractionEnabled = NO;
    
    //Load Data for profile
    Firebase *myRootRef = [[[FireBaseConfig alloc] init] currentUser];
    
    [myRootRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        if([snapshot hasChildren]){
            self.firstNameTextField.text = [snapshot.value objectForKey:@"firstName"];
            self.lastNameTextField.text = [snapshot.value objectForKey:@"lastName"];
            self.dateOfBirthTextField.text = [snapshot.value objectForKey:@"dateOfBirth"];
            self.addressTextField.text = [snapshot.value objectForKey:@"address"];
            self.bloodTypeTextField.text = [snapshot.value objectForKey:@"bloodType"];
            self.donorIdTextField.text = [snapshot.value objectForKey:@"donorId"];
            self.emailTextField.text = [snapshot.value objectForKey:@"email"];
            
            
            if([snapshot.value objectForKey:@"profilePic"]!=nil && ![[snapshot.value objectForKey:@"profilePic"] isEqualToString:@""]){
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[snapshot.value objectForKey:@"profilePic"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                self.profilePicImageView.image = [[UIImage alloc] initWithData:imageData];
            }
            
        }
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    //End loading data for profile
    
}


//Viw Did appear
-(void)viewDidAppear:(BOOL)animated{
    




}


//Image Picker Controller delegate Protocol Methods
-(IBAction)onImageClicked:(id)sender{
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.chosenImage = info[UIImagePickerControllerOriginalImage];
    [self.profilePicImageView setImage:self.chosenImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    /*
    if(self.inputPatient != nil){
        self.saveButtonItem.enabled = YES;
    }
     */
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Image Picker Protocol methods ends


//Dismiss Keyboard
-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}
//Date Picker Functions
-(void)showSelectedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    
    self.dateOfBirthTextField.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    NSLog(@"Date Seleted : %@",datePicker.date);
    [self.dateOfBirthTextField resignFirstResponder];
    
}

//End of Date Picker Functions

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonAction:(id)sender {
    
    NSString *firstName = self.firstNameTextField.text;
    NSString *lastName = self.lastNameTextField.text;
    NSString *address = self.addressTextField.text;
    NSString *donorId = self.donorIdTextField.text;
    NSString *bloodType = self.bloodTypeTextField.text;
    NSString *email = self.emailTextField.text;
    
    NSData *profilePicData = UIImageJPEGRepresentation(self.profilePicImageView.image, 1.0);
    NSString *base64ProfilePic = [profilePicData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSString *dateOfBirth = self.dateOfBirthTextField.text;
    
    
    NSDictionary *users = @{
                            @"firstName": firstName,
                            @"lastName":lastName,
                            @"address": address,
                            @"donorId": donorId,
                            @"bloodType": bloodType,
                            @"profilePic": base64ProfilePic,
                            //@"email":email,
                            @"dateOfBirth": dateOfBirth
                            
                            };
    
    
    Firebase *myRootRef = [[[FireBaseConfig alloc] init] currentUser];
    [myRootRef setValue:users];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Profile Updated!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}






@end
