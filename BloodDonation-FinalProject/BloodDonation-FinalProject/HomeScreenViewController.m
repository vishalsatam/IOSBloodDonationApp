//
//  HomeScreenViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeScreenViewController.h"

//Firebase import
#import <Firebase/Firebase.h>
#import "FireBaseConfig.h"
//End firebas import
#import "User.h"

@interface HomeScreenViewController ()

@end


@implementation HomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Image Gesture Recgnizer
    
    
    //Keyboard Gesture Recognizer
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    //End gesture recognizer

    
    //headerImageReize and set the image
    //Make the image rounded
    self.profilePicButton.layer.cornerRadius = self.profilePicButton.frame.size.width / 2;
    self.profilePicButton.clipsToBounds = YES;
    
    
    self.profilePicButton.imageView.image = [UIImage imageNamed:@"loginHeader.jpg"];
    //[self.profilePicButton setImage:[UIImage imageNamed:@"loginHeader.png"] forState:UIControlStateNormal];
    self.profilePicButton.imageView.contentMode = UIViewContentModeScaleToFill;
    self.profilePicButton.backgroundColor = [UIColor colorWithRed:220 green:225 blue:228 alpha:1.0];
    //headerImageresize code ends

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"createAccountBackground.jpg"]]];
    
    self.qtyOfBloodTextView.layer.cornerRadius = self.qtyOfBloodTextView.frame.size.width / 2;
    self.qtyOfBloodTextView.clipsToBounds = YES;
    
    self.bloodTypeTextView.layer.cornerRadius = self.bloodTypeTextView.frame.size.width / 2;
    self.bloodTypeTextView.clipsToBounds = YES;
    
    
    //Initialize the requestblood array

    
}

-(void)viewDidAppear:(BOOL)animated{
    
    Firebase *myRootRef = [[[FireBaseConfig alloc] init] currentUser];
    
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if([snapshot hasChild:@"profilePic"]){
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[snapshot.value objectForKey:@"profilePic"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
            
            if(imageData != nil){
               [self.profilePicButton setImage:[self imageWithImage:[[UIImage alloc] initWithData:imageData] scaledToSize:CGSizeMake(160, 160)] forState:UIControlStateNormal];
            }

        }
        if([snapshot hasChild:@"bloodType"]){
            if([[snapshot.value valueForKey:@"bloodType"] isEqualToString:@""]){
                self.bloodTypeTextView.text = [snapshot.value valueForKey:@"?"];
            }
            else{
                self.bloodTypeTextView.text = [snapshot.value valueForKey:@"bloodType"];
            }
            
        }
        else{
            self.bloodTypeTextView.text = @"?";
        }
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
   
   Firebase *updateDonationQuantity = [[[FireBaseConfig alloc] init] getDonations];
    [updateDonationQuantity observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *shnapp) {
       
        long qtyOfBloodDonated = 0;
        if([shnapp hasChildren]){
            for(FDataSnapshot *snip  in [shnapp children] ){
                if([snip hasChild:@"pintsDonated"]){
                    NSString *x =[[snip value] valueForKey:@"pintsDonated"];
                    qtyOfBloodDonated +=  [x intValue];
                }
                
                
            }
            //NSLog(@"Total qty : %ld",qtyOfBloodDonated);
            if(qtyOfBloodDonated <=0){
                self.qtyOfBloodTextView.text = @"0Pints";
                
            }
            else{
               self.qtyOfBloodTextView.text = [NSString stringWithFormat:@"%ld",qtyOfBloodDonated];
            }
            
            
        }
        
        
    }];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Resize image
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//Dismiss Keyboard
-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)profilePicAction:(id)sender {
}

- (IBAction)logoutAction:(id)sender {
    Firebase *myRootRef = [[[FireBaseConfig alloc] init] currentUser];
    [myRootRef unauth];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)requestBloodAction:(id)sender {

   
    
    
}









@end