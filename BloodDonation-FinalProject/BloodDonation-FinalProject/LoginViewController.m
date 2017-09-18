//
//  LoginViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/26/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

//Facebook
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//Facebook

//Firebase import
#import <Firebase/Firebase.h>
#import "FireBaseConfig.h"
//End firebas import

@interface LoginViewController ()

@end


@implementation LoginViewController

BOOL loginSuccess = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //setting background image
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background-image"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    //end of setting background image
    
    //Facebook Login Button
    /*
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    loginButton.frame = CGRectMake(self.view.center.x - 110, 470, 260, 30);
    
    [self.view addSubview:loginButton];
    */
     //End Facebook Login Button
    

    //Tap Gesture Recognizer
    /*
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    //End Tap Gesture Recognizer
    */
    
    
    //headerImageReize and set the image
    //Make the image rounded
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width / 2;
    self.headerImageView.clipsToBounds = YES;
    
    
    self.headerImageView.image = [UIImage imageNamed:@"loginHeader.png"];
    self.headerImageView.backgroundColor = [UIColor colorWithRed:220 green:225 blue:228 alpha:1.0];
    //headerImageresize code ends
    
    
    
    //Firebase Trial
    /*
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://bdfinalproject.firebaseio.com/"];
    
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"%@",snapshot.value[@"username"]);
        NSLog(@"%@",snapshot.value[@"password"]);
        self.usernameTextField.text =snapshot.value[@"username"];
        self.passwordTextField.text =snapshot.value[@"password"];
        NSLog(@"%@", snapshot.value);
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    */
    //End Firebase Trial
    
    
    self.usernameTextField.text=@"";
    self.passwordTextField.text = @"";
    
    //Keyboard Gesture Recognizer
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    //End gesture recognizer
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"createAccountBackground.jpg"]]];

    
}


//Custom Facebook Login Button
- (IBAction)facebookLoginAction:(id)sender{
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://bdfinalproject.firebaseio.com/"];
    
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    [facebookLogin logInWithReadPermissions:@[@"email"]
                                    handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
                                        if (facebookError) {
                                            NSLog(@"Facebook login failed. Error: %@", facebookError);
                                            loginSuccess = NO;
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Facebook Login Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                            [alert show];
                                        } else if (facebookResult.isCancelled) {
                                            NSLog(@"Facebook login got cancelled.");
                                            loginSuccess = NO;
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            [myRootRef authWithOAuthProvider:@"facebook" token:accessToken
                                                         withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                             
                                                             /*
                                                             if (error) {
                                                                 NSLog(@"Login failed. %@", error);
                                                                 loginSuccess = NO;
                                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Facebook Login Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                 [alert show];
                                                                 
                                                                 
                                                             } else {
                                                                 NSLog(@"Logged in! %@", authData);
                                                                 loginSuccess = YES;
                                                                 [self performSegueWithIdentifier:@"loginSegue" sender:sender];
                                                                 

                                                             }
                                                             */
                                                             if (error == nil) {
                                                                 //Setting userdefaults
                                                                 [[NSUserDefaults standardUserDefaults] setValue:authData.uid forKey:@"uid"];
                                                                 
                                                                 //fetching fb profile
                                                                 
                                                                 NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                                                                 [parameters setValue:@"email,name,picture,birthday,first_name,last_name" forKey:@"fields"];
                                                                 
                                                                 NSLog(@"trying graph fb gin res ");
                                                                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                                                                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                                               id result, NSError *error) {
                                                                      NSLog(@"Facebook res : %@",result);
                                                                      if(!error){
                                                                          Firebase *checkUser = [[[FireBaseConfig alloc] init] currentUser];
                                                                          
                                                                          [checkUser observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
                                                                              
                                                                              if(![snapshot hasChildren]){
                                                                                  
                                                                                  //Fetching FB Account
                                                                                  NSLog(@"%@ %@ %@ %@",[result valueForKey:@"first_name"],[result valueForKey:@"last_name"],[result valueForKey:@"picture"],[result valueForKey:@"email"]);
                                                                                  
                                                                                  NSLog(@"Pic : %@ ",[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]);
                                                                                  
                                                                                  //Saving Profile
                                                                                  //NSData *profilePicData = UIImageJPEGRepresentation(self.profilePicImageView.image, 1.0);
                                                                                  NSURL *profilepicurl = [[NSURL alloc]initWithString:[[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"]];
                                                                                  NSString *base64ProfilePic = [[[NSData alloc] initWithContentsOfURL:profilepicurl] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                                                                                  
                                                                                  
                                                                                      NSDictionary *users = @{
                                                                                                              @"firstName": [result valueForKey:@"first_name"],
                                                                                                              @"lastName":[result valueForKey:@"last_name"],
                                                                                                              //@"address": address,
                                                                                                              //@"donorId": donorId,
                                                                                                              //@"bloodType": bloodType,
                                                                                                              @"email" : [result valueForKey:@"email"],
                                                                                                              //@"dateOfBirth": dateOfBirth,
                                                                                                              @"profilePic": base64ProfilePic
                                                                                                              };
                                                                                      NSLog(@"KEY VALUE before FB save : %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]);
                                                                                      
                                                                                      
                                                                                      
                                                                                      //Firebase *saveProfile = [[[FireBaseConfig alloc] init] getFirebasInstance];
                                                                                      //saveProfile = [[saveProfile childByAppendingPath:@"users"] childByAppendingPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]];
                                                                                      
                                                                                      Firebase *saveProfile = [[[FireBaseConfig alloc] init] currentUser];
                                                                                      [saveProfile setValue:users];
                                                                                 
                                                                              }
                                                                              
                                                                          }];

                                                                          
                                                                          
                                                                          
                                                                      }
                                                                      else{
                                                                         NSLog(@"Facebook err : %@",error);
                                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"ACould not fetch profile" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                          [alert show];                                                                      }
                                                                      
                                                                      
                                                                  }];
                                                                 

                                                                 
                                                                 
                                                                 NSLog(@"Logged in! %@", authData);
                                                                 loginSuccess = YES;
                                                                 [self performSegueWithIdentifier:@"loginSegue" sender:sender];
                                                                 
                                                                 
                                                             } else {
                                                                 NSLog(@"Login failed. %@", error);
                                                                 loginSuccess = NO;
                                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email/password combination doesn't exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                                 [alert show];
                                                                 
                                                                 
                                                                 
                                                             }

                                                              
                                                              
                                                         }];
                                        }
                                    }];
}
//Facebook Login

//Email Login
- (IBAction)loginAction:(id)sender {
    
    NSString *email = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if(![email isEqual:@""] && ![password isEqual:@""]){
        Firebase *myRootRef = [[[FireBaseConfig alloc] init] currentUser];
        [myRootRef authUser:email password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
            
            if (error == nil) {
                [[NSUserDefaults standardUserDefaults] setValue:authData.uid forKey:@"uid"];
                
                NSLog(@"Logged in! %@", authData);
                loginSuccess = YES;
                [self performSegueWithIdentifier:@"loginSegue" sender:sender];
                
                
            } else {
                 NSLog(@"Login failed. %@", error);
                loginSuccess = NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email/password combination doesn't exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
                
                
            }
        }];
    }
    else{
        loginSuccess = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Email and Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
//Email Login



//Restrict login segue in case of login failed
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"loginSegue"])
    {
        if(loginSuccess){
            return YES;
        }
        else{
            return NO;
        }
    }
    return YES;
}
//end restrict segue

-(void)viewDidAppear:(BOOL)animated{
    //Firebase checking authorixzation
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]!=nil && [[[[FireBaseConfig alloc] init] currentUser] authData] !=nil){
        NSLog(@"USER HAS ALREADY BEEN AUTHENTICATD");
        loginSuccess = YES;
        [self performSegueWithIdentifier:@"loginSegue" sender:self.loginButton];
        
    }
    else{
        NSLog(@"USER HAS ALREADY BEEN AUTHENTICATD");
        loginSuccess = NO;

    }
    
    //End authorization
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Dismiss Keyboard
-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

@end