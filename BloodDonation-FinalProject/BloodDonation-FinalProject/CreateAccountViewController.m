//
//  CreateAccountViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import "CreateAccountViewController.h"

//FireBaseImport
#import <Firebase/Firebase.h> 
#import "FireBaseConfig.h"
//FireBaseImporEnds

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Keyboard Gesture Recognizer
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    //End gesture recognizer
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"createAccountBackground.jpg"]]];
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

- (IBAction)createAccountAction:(id)sender {

    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if(![email isEqual:@""] && ![password isEqual:@""]){
        /*
        Firebase *myRootRef = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"https:\//bdfinalproject.firebaseio.com/users/%@",[[[FireBaseConfig alloc] init] getUID]]];
        */
         Firebase *myRootRef = [[[FireBaseConfig alloc] init] currentUser];
        [myRootRef createUser:email password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error == nil) {
                NSLog(@"Creating user! %@", result);
                
                //Firebase *ref = [[Firebase alloc] initWithUrl:[[[FireBaseConfig alloc] init] getFireBaseUrl]];
                Firebase *ref = [[[FireBaseConfig alloc] init] currentUser];
                
                [ref authUser:email password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
                    if (error == nil) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Account created!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        NSLog(@"Created Account in! %@", authData);
                        [[NSUserDefaults standardUserDefaults] setValue:[authData uid] forKey:@"uid"];
                        NSDictionary *users = @{
                                                //@"firstName": firstName,
                                                //@"lastName":lastName,
                                                //@"address": address,
                                                //@"donorId": donorId,
                                                //@"bloodType": bloodType,
                                                //@"profilePic": base64ProfilePic,
                                                @"email":email
                                                //@"dateOfBirth": dateOfBirth
                                                
                                                };
                        
                        
                        Firebase *createUser = [[[FireBaseConfig alloc] init] currentUser];
                        [createUser setValue:users];
                        
                        
                        
                        
                        [self dismissViewControllerAnimated:true completion:nil];
                        
                    } else {
                        NSLog(@"Login failed. %@", error);
                        

                    }
                }];
                
                
            } else {
                NSLog(@"Login failed. %@", error);
                
            }
        }];
        
    }
    else{
        
    }

}

- (IBAction)cancelAccountAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Dismiss Keyboard
-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

@end
