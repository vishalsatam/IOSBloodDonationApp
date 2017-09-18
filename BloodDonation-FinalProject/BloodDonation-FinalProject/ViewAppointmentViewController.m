//
//  ViewAppointmentViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/29/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import "ViewAppointmentViewController.h"
//Firebase import
#import <Firebase/Firebase.h>
#import "FireBaseConfig.h"
//End firebase import

@interface ViewAppointmentViewController ()

@end

@implementation ViewAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Confirmed appointment in viewappointment [page : %@",self.confirmedAppointment);
    NSLog(@"Blood Cnter in viewappointment [page : %@",self.bloodCollectionCenter);
    
    //Initializing the collection center details
    if(self.bloodCollectionCenter.collectionCenterId != nil)
    {
        self.bloodCollectionCenterNameLabel.text = [self.bloodCollectionCenter name];
        NSString *addressString = [NSString stringWithFormat:@"%@, %@ - %@",self.bloodCollectionCenter.address,self.bloodCollectionCenter.city,self.bloodCollectionCenter.zip];
        self.bloodCollectionCenterAddressLabel.text = addressString;
        
        
        self.bloodCollectionCenter.appointments = [[NSMutableArray alloc]init];
        [self.bloodCollectionCenter.appointments removeAllObjects];
        
        
        NSDateFormatter *onlyDate =[[NSDateFormatter alloc]init];
        [onlyDate setDateFormat:@"dd-MM-yyyy"];
        NSDateFormatter *onlyTime =[[NSDateFormatter alloc]init];
        [onlyTime setDateFormat:@"HH:mm"];
        
        NSString *dte = [onlyDate stringFromDate:self.confirmedAppointment.date];
        NSString *tm = [onlyTime stringFromDate:self.confirmedAppointment.date];
        
        self.timeAndDateLabel.text = [NSString stringWithFormat:@"%@ - %@",dte,tm];
    }
    
    //Customizting back button code
    //[super loadView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 60.0f, 30.0f)];
    //UIImage *backImage = [[UIImage imageNamed:@"back_button_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0f, 0, 12.0f)];
    //[backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
    
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0]];
    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    
    
    //Setting the map to show the user location
    //[self.collectionCenterLocationMapView setShowsUserLocation:YES];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        self.locationManager = [[CLLocationManager alloc]init];
        [self.locationManager startUpdatingLocation];
        self.bloodDonationCenterMapView.showsUserLocation = YES;
        
        
    }
    
    self.bloodDonationCenterMapView.delegate = self;
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.bloodCollectionCenter.latitude doubleValue], [self.bloodCollectionCenter.longitude doubleValue]);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f, 0.f);
    [self.bloodDonationCenterMapView setRegion:MKCoordinateRegionMake(coord, span) animated:YES];
    
    
    //Adding a map annotation
    MKPointAnnotation* annotation= [MKPointAnnotation new];
    annotation.coordinate= CLLocationCoordinate2DMake([self.bloodCollectionCenter.latitude doubleValue], [self.bloodCollectionCenter.longitude doubleValue]);
    annotation.title = self.bloodCollectionCenter.name;
    annotation.subtitle = [NSString stringWithFormat:@"%@, %@",self.bloodCollectionCenter.address,self.bloodCollectionCenter.city];
    
    
    MKAnnotationView *mkAnnotationView =[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    UIImageView *uiImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bloodDropMapAnnotation.png"]]  ;
    
    mkAnnotationView.image = [uiImgView image];
    mkAnnotationView.enabled = YES;
    
    [self.bloodDonationCenterMapView addAnnotation:mkAnnotationView.annotation];
    //ENd adding map annotation
    
    //End Map configurations
    
    
    //Setting labels
    NSLog(@"VIEWVIEWCONTROLLER CC NAME : %@",self.bloodCollectionCenter.name);
    self.bloodCollectionCenterNameLabel.text = self.bloodCollectionCenter.name;
    self.bloodCollectionCenterAddressLabel.text = [NSString stringWithFormat:@"%@, %@ - %@",self.bloodCollectionCenter.address,self.bloodCollectionCenter.city,self.bloodCollectionCenter.zip];
    
    NSDateFormatter *df =[[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd-MM-yyyy HH:mm"];
    self.timeAndDateLabel.text = [df stringFromDate:self.confirmedAppointment.date];
    
    
    
}
//Implementing the map delegate method
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.bloodCollectionCenter.latitude doubleValue], [self.bloodCollectionCenter.longitude doubleValue]);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f, 0.f);
    [mapView setRegion:MKCoordinateRegionMake(coord, span) animated:NO];
    
    
    
    [self.bloodDonationCenterMapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, span) animated:YES];
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


-(void) popBack {
    //[self.navigationController popViewControllerAnimated:YES];
    for (UIViewController* viewController in self.navigationController.viewControllers) {
        
        //This if condition checks whether the viewController's class is MyGroupViewController
        // if true that means its the MyGroupViewController (which has been pushed at some point)
        if ([viewController isKindOfClass:[MyAppointmentsTableViewController class]] ) {
            
            // Here viewController is a reference of UIViewController base class of MyGroupViewController
            // but viewController holds MyGroupViewController  object so we can type cast it here
            MyAppointmentsTableViewController *groupViewController = (MyAppointmentsTableViewController*)viewController;
            [self.navigationController popToViewController:groupViewController animated:YES];
        }
    }

}


- (IBAction)rescheduleAppointmentAction:(id)sender {
}


- (IBAction)cancelAppointmentAction:(id)sender {
    
    Firebase *ref = [[[[FireBaseConfig alloc] init] getAppointments] childByAppendingPath:self.confirmedAppointment.apppointmentId];
    [ref removeValue];
    
    Firebase *updateRef = [[[[[[[FireBaseConfig alloc] init] getCollectionCenter] childByAppendingPath:self.confirmedAppointment.collectionCenterId]childByAppendingPath:@"appointments"] childByAppendingPath:self.confirmedAppointment.apppointmentId] childByAppendingPath:@"uid"];
    [updateRef removeValue ];
    
    Firebase *bookedRef = [[[[[[[FireBaseConfig alloc] init] getCollectionCenter] childByAppendingPath:self.confirmedAppointment.collectionCenterId]childByAppendingPath:@"appointments"] childByAppendingPath:self.confirmedAppointment.apppointmentId] childByAppendingPath:@"booked"];
    [bookedRef setValue:@"false"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Appointment Cancelled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(popBack)];
    
}

- (IBAction)simulateApointmentAction:(id)sender {
    

    Firebase *ref = [[[FireBaseConfig alloc] init] getDonations];
    NSLog(@"Before searching for count");
    [ref observeSingleEventOfType :FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        

        //Stub simulated data
        
        NSMutableDictionary *donations = [[NSMutableDictionary alloc] init];
        
        int numcount = [snapshot childrenCount];
        numcount++;
        
        [donations setValue:[NSString stringWithFormat:@"%d",numcount] forKey:@"donationId"];
        [donations setValue:self.bloodCollectionCenter.name forKey:@"collectionCenterName"];
        
        NSString *min = @"0" ;//Get the current text from your minimum and maximum textfields.
        NSString *max = @"10";
        
        int randNum = rand() % ([max intValue] - [min intValue]) + [min intValue]; //create the random number.
        
        NSString *num = [NSString stringWithFormat:@"%d", randNum];
        
        [donations setValue:num forKey:@"pintsDonated"];
        
        NSDate *date = [[NSDate alloc] init];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MM-yyyy HH:mm"];
        
        [donations setValue:[df stringFromDate:date] forKey:@"dateOfDonation"];
        
        randNum = rand() % ([@"3" intValue] - [@"1" intValue]) + [@"1" intValue];
        
        if(randNum == 1){
            [donations setValue:@"double" forKey:@"donationType"];
        }
        else if(randNum == 2){
            [donations setValue:@"platelets" forKey:@"donationType"];
        }
        else{
            [donations setValue:@"blood" forKey:@"donationType"];
        }
        
        [donations setValue:self.confirmedAppointment.apppointmentId forKey:@"appointmentId"];
        [donations setValue:[NSString stringWithFormat:@"%@, %@ - %@",self.bloodCollectionCenter.address,self.bloodCollectionCenter.city,self.bloodCollectionCenter.zip] forKey:@"address"];
        [donations setValue:@"1" forKey:@"donationPhase"];
        
        NSDictionary *tempDict = [NSDictionary dictionaryWithDictionary:donations];
        NSLog(@"temp DIct value : %@",[tempDict valueForKey:@"collectionCnterName"]);
        
        //End stub simulated data
        
        
        
        Firebase *update = [[[[FireBaseConfig alloc] init] getDonations] childByAppendingPath:[donations valueForKey:@"donationId"]];
        ///update = [update childByAppendingPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]];
        
        [update updateChildValues:tempDict withCompletionBlock:^(NSError *error, Firebase *ref) {
            if(error){
                NSLog(@"Erro r : %@",error);
            }
            else{
                
            }
        }];
        
        Firebase *updateAppointment = [[[[[FireBaseConfig alloc] init] getAppointments] childByAppendingPath:self.confirmedAppointment.apppointmentId] childByAppendingPath:@"completed"];
        ///update = [update childByAppendingPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]];
        [updateAppointment setValue:@"true" ];
        
        
        NSLog(@"Inside Donations : %@" ,donations);
        
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Donation Completed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
    
    
     //NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"booked",[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"],@"uid",nil];
}




-(void)methodToUpdate:(NSDictionary *)donation{
    
}

@end
