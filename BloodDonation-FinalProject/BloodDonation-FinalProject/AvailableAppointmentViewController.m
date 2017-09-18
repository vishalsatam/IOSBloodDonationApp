//
//  AvailableAppointmentViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/28/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import "AvailableAppointmentViewController.h"
//Firebase import
#import <Firebase/Firebase.h>
#import "FireBaseConfig.h"
//End firebase import


@interface AvailableAppointmentViewController ()

@end

@implementation AvailableAppointmentViewController

int timeSlotRowSelected = -1;
BOOL segueShouldOccur = YES;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Initializing the collection center details
    if(self.bloodCollectionCenter.collectionCenterId != nil)
    {
        self.collectionCenterNameLabel.text = [self.bloodCollectionCenter name];
        NSString *addressString = [NSString stringWithFormat:@"%@, %@ - %@",self.bloodCollectionCenter.address,self.bloodCollectionCenter.city,self.bloodCollectionCenter.zip];
        self.collectionCenterAddressLabel.text = addressString;
        [self fetchAvailableAppointments];
        
        self.bloodCollectionCenter.appointments = [[NSMutableArray alloc]init];
        [self.bloodCollectionCenter.appointments removeAllObjects];

    }
    
    
    //Setting the map to show the user location
    //[self.collectionCenterLocationMapView setShowsUserLocation:YES];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        self.locationManager = [[CLLocationManager alloc]init];
        [self.locationManager startUpdatingLocation];
        self.collectionCenterLocationMapView.showsUserLocation = YES;
        
       
    }
    
    self.collectionCenterLocationMapView.delegate = self;
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.bloodCollectionCenter.latitude doubleValue], [self.bloodCollectionCenter.longitude doubleValue]);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f, 0.f);
    [self.collectionCenterLocationMapView setRegion:MKCoordinateRegionMake(coord, span) animated:YES];
    
    
    //Adding a map annotation
    MKPointAnnotation* annotation= [MKPointAnnotation new];
    annotation.coordinate= CLLocationCoordinate2DMake([self.bloodCollectionCenter.latitude doubleValue], [self.bloodCollectionCenter.longitude doubleValue]);
    annotation.title = self.bloodCollectionCenter.name;
    annotation.subtitle = [NSString stringWithFormat:@"%@, %@",self.bloodCollectionCenter.address,self.bloodCollectionCenter.city];
    
    
    MKAnnotationView *mkAnnotationView =[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    UIImageView *uiImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bloodDropMapAnnotation.png"]]  ;
    
    mkAnnotationView.image = [uiImgView image];
    mkAnnotationView.enabled = YES;
    
    [self.collectionCenterLocationMapView addAnnotation:mkAnnotationView.annotation];
    //ENd adding map annotation
    
    //End Map configurations
    
    
    //Dropdown box code
    self.timeSlotTableView.delegate =self;
    self.timeSlotTableView.dataSource = self;
    //[self.timeSlotTableView reloadData];
    self.timeSlotTableView.hidden = YES;
    self.timeSlotButton.layer.borderWidth = 0.3f;
    self.timeSlotButton.layer.borderColor = [[UIColor redColor] CGColor];
    //End dropdown code
    

    //Hiding confirmationlabel

    
    
}

//Implementing the map delegate method
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([self.bloodCollectionCenter.latitude doubleValue], [self.bloodCollectionCenter.longitude doubleValue]);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1f, 0.f);
    [mapView setRegion:MKCoordinateRegionMake(coord, span) animated:NO];
    
    
    
    [self.collectionCenterLocationMapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, span) animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"Count of rows in appointments in did appear %ld",[[self.bloodCollectionCenter appointments]  count] );
    [self.bloodCollectionCenter.appointments removeAllObjects];
    [self fetchAvailableAppointments];

}
//ENd implementing map delegate methods


//Table View delegate methods for drop down box
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.timeSlotTableView cellForRowAtIndexPath:indexPath];
    NSString *timeSlotTxt = [NSString stringWithFormat:@"%@ - %@",cell.textLabel.text,cell.detailTextLabel.text];
    
    [self.timeSlotButton setTitle:timeSlotTxt forState:UIControlStateNormal];
    timeSlotRowSelected = indexPath.row;
    
    self.timeSlotTableView.hidden = YES;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"Count of rows in appointments %ld",[[self.bloodCollectionCenter appointments]  count] );
    return [[self.bloodCollectionCenter appointments]  count];
}

-(UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"List of Hospital %@",self.hospital.patientList);
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        NSDateFormatter *onlyDate =[[NSDateFormatter alloc]init];
        [onlyDate setDateFormat:@"dd-MM-yyyy"];
        NSDateFormatter *onlyTime =[[NSDateFormatter alloc]init];
        [onlyTime setDateFormat:@"HH:mm"];
        
        NSDate *dte = [[[self.bloodCollectionCenter appointments] objectAtIndex:indexPath.row] date];
       
        NSString *appointmentDate = [onlyDate stringFromDate:dte];
        NSString *appointmentTime = [onlyTime stringFromDate:dte];
        
        
        cell.textLabel.text = appointmentTime;
        cell.detailTextLabel.text = appointmentDate;
    }
    
    
    return cell;
}

//End delegate metods for dropdown box


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Function for setting the collectioncenter
/*
-(void)setBloodCollectionCenter:(CollectionCenter *)collectionCenter{
    self.bloodCollectionCenter = collectionCenter;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)rescheduleAction:(id)sender {
}

- (IBAction)cancelAction:(id)sender {
}

- (IBAction)confirmAppointmentAction:(id)sender {
    
    
    if(timeSlotRowSelected >=0 ){
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]!=nil && [[[[FireBaseConfig alloc] init] currentUser] authData] !=nil){
        
    
    NSMutableDictionary *appointment = [[NSMutableDictionary alloc] init];
    //[appointment setValue:[[[self.bloodCollectionCenter appointments] objectAtIndex:timeSlotRowSelected] date]  forKey:@"date"];
    
        NSDateFormatter *onlyDate =[[NSDateFormatter alloc]init];
        [onlyDate setDateFormat:@"dd-MM-yyyy"];
        NSDateFormatter *onlyTime =[[NSDateFormatter alloc]init];
        [onlyTime setDateFormat:@"HH:mm"];
        
        NSDate *dte = [[[self.bloodCollectionCenter appointments] objectAtIndex:timeSlotRowSelected] date];
        
        NSString *appointmentDate = [onlyDate stringFromDate:dte];
        NSString *appointmentTime = [onlyTime stringFromDate:dte];

    
    [appointment setValue:appointmentDate forKey:@"date"];
    [appointment setValue:appointmentTime forKey:@"time"];
    [appointment setValue:[[[self.bloodCollectionCenter appointments] objectAtIndex:timeSlotRowSelected] apppointmentId] forKey:@"appointmentId"];
    [appointment setValue:self.bloodCollectionCenter.collectionCenterId forKey:@"collectionCenterId"];
        [appointment setValue:@"false" forKey:@"completed"];
        
    
    NSLog(@"colection center id:  %@", self.bloodCollectionCenter.collectionCenterId);
    
    
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:[[[FireBaseConfig alloc] init] getFireBaseUrl]];
    
    myRootRef = [[[myRootRef childByAppendingPath:@"Appointments"] childByAppendingPath:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]] childByAppendingPath:[[[self.bloodCollectionCenter appointments] objectAtIndex:timeSlotRowSelected] apppointmentId] ];
    
        [myRootRef setValue:appointment];
        NSLog(@"Creating Appointment! %@");
        
        
        //Update The value of booked
        Firebase *ref = [[Firebase alloc] initWithUrl:[[[FireBaseConfig alloc] init] getFireBaseUrl]];
        ref = [[[[ref childByAppendingPath:@"CollectionCenters"] childByAppendingPath:self.bloodCollectionCenter.collectionCenterId] childByAppendingPath:@"appointments"] childByAppendingPath:[[[self.bloodCollectionCenter appointments] objectAtIndex:timeSlotRowSelected] apppointmentId]];
        NSMutableDictionary *bookedDict = [[NSMutableDictionary alloc]init];
        [bookedDict setValue:@"true" forKey:@"booked"];
        NSLog(@"DICt ",bookedDict);
        NSLog(@"KEY  --> %@",[ref key]);
        
        //[ref updateChildValues:bookedDict];
        NSDictionary *tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"booked",[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"],@"uid",nil];
        
        [ref updateChildValues:tempDict withCompletionBlock:^(NSError *error, Firebase *ref) {
            if(error == nil || [error isEqual:@""]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Appointment Confirmed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                segueShouldOccur = YES;
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                segueShouldOccur = NO;
            }
        }];
        /*
         withCompletionBlock:^(NSError *error, Firebase *res){
         
         if(error == nil){
         
         }
         else{
         NSLog(@"Updating appointments failed %@", error);
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Appointment could not be confirmed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         
         }
         
         }];
         */
        //finish updating the value of booked
        
        
        
        
        [[[self.bloodCollectionCenter appointments] objectAtIndex:timeSlotRowSelected] date];
        NSDate *dte1 = [[[self.bloodCollectionCenter appointments] objectAtIndex:timeSlotRowSelected] date];
        self.confirmedAppointment = [[Appointment alloc]init];
        self.confirmedAppointment.date = dte1;
        self.confirmedAppointment.apppointmentId = [[[self.bloodCollectionCenter appointments] objectAtIndex:timeSlotRowSelected] apppointmentId];
        self.confirmedAppointment.uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
        self.confirmedAppointment.booked = YES;
        self.confirmedAppointment.collectionCenterId = self.bloodCollectionCenter.collectionCenterId;
        timeSlotRowSelected = -1;
        NSLog(@"Confirmed appointment in confirm [page : %@",self.confirmedAppointment);
        
        [self fetchAvailableAppointments];
        //[self dismissViewControllerAnimated:YES completion:nil];
        
     
    }
        
    }
    else{
        segueShouldOccur = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Select Time Slot" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

//Drop down button select
- (IBAction)timeSlotButtonAction:(id)sender {
    if(self.timeSlotTableView.hidden == YES){
        self.timeSlotTableView.hidden = NO;
    }
    else{
        self.timeSlotTableView.hidden = YES;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
       if ([[segue identifier] isEqualToString:@"viewAppointmentAfterConfirmationSegue"]) {

           [[segue destinationViewController] setBloodCollectionCenter:self.bloodCollectionCenter ];
           [[segue destinationViewController]  setConfirmedAppointment:self.confirmedAppointment ];
           NSLog(@"Confirmed appointment in confirm [page : %@",self.confirmedAppointment);
       }

    
}


//Fetch available appointments
-(void)fetchAvailableAppointments{
    NSLog(@"FetchAvailableAppointmnts");
    [self.bloodCollectionCenter.appointments removeAllObjects];
    NSLog(@"Confirmed Appoint outside fetch appointments loop -- COnfirmation iD Variable  : %@",self.confirmedAppointment.apppointmentId);
 
    
    
    NSString *collectioncenterurl = [[[FireBaseConfig alloc] init] getCollectionCenterUrl];
    NSString *finalURl = [NSString stringWithFormat:@"%@/%@/%@",collectioncenterurl,self.bloodCollectionCenter.collectionCenterId,@"appointments"];
    NSLog(@"URL being sent to firebase : %@",finalURl);
    Firebase *ref = [[Firebase alloc] initWithUrl:finalURl];
    
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snap){
        
        if([snap hasChildren]){
            
            for(FDataSnapshot *snip in [snap children]){
                
                
                    if([[[snip value] valueForKey:@"booked"]  isEqual: @"true"]){
                        
                        NSLog(@"Booked value : %@ -- for time : %@",[[snip value] valueForKey:@"booked"],[[snip value] valueForKey:@"time"]);
                    }
                    else{
                        Appointment *insideAppointment = [[Appointment alloc]init];
                        NSDateFormatter *df =[[NSDateFormatter alloc]init];
                        [df setDateFormat:@"dd-MM-yyyy HH:mm"];
                        insideAppointment.apppointmentId = [snip key];
                        NSString *inpDate = [[snip value] valueForKey:@"date"];
                        NSString *inpTime = [[snip value] valueForKey:@"time"];
                        NSString *finalDate = [NSString stringWithFormat:@"%@ %@",inpDate,inpTime];
                        
                        NSDate *formattedDate = [df dateFromString:finalDate];
                        
                        insideAppointment.date = formattedDate;
                        NSLog(@"Booked value : %@ -- for time : %@",[[snip value] valueForKey:@"booked"],[[snip value] valueForKey:@"time"]);
                        
                        
                        insideAppointment.booked = NO;
                        [self.bloodCollectionCenter.appointments addObject:insideAppointment];
                        NSLog(@"snap  data inside loop: %@",self.bloodCollectionCenter.appointments);
                        
                        
                    }
                    

            }
            
            NSLog(@"Confirmed Appoint inside fetch appointmwnts loop-- COnfirmation iD Variable  : %@",self.confirmedAppointment.apppointmentId);

            
           
        }
        
        [self.timeSlotTableView reloadData];
    } ];
    
    NSLog(@"snap  data outside loop: %@",self.bloodCollectionCenter.appointments);
    
    
}



//Force the stopping of the segue
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"viewAppointmentAfterConfirmationSegue"]) {
        // perform your computation to determine whether segue should occur
        
         // you determine this
        if (!segueShouldOccur) {
            segueShouldOccur = YES;
            return NO;
        }
        else{
            return YES;
        }
    }
    return YES;
}



@end