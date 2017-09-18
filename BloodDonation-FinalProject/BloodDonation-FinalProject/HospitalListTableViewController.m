//
//  HospitalListTableViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import "HospitalListTableViewController.h"

//Firebase import
#import <Firebase/Firebase.h>
#import "FireBaseConfig.h"
//End firebase import
#import "AvailableAppointmentViewController.h"
#import "Appointment.h"

@interface HospitalListTableViewController ()

@end

@implementation HospitalListTableViewController

long selectedRow = -1;
bool removeObject = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.collectionCenterArray = [[NSMutableArray alloc]init];
    self.navigationController.title = @"Available Appointments";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    //Removing all the existing elements from the array
    [self.collectionCenterArray removeAllObjects];
    
    Firebase *myRootRef = [[[FireBaseConfig alloc] init] getCollectionCenter];
    
    
    [[[myRootRef queryOrderedByChild:@"collections/appointments/*/booked"] queryEqualToValue:@"false"]observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"snapshot in new query : %@",[snapshot key]);
    }];
    
    
    
    [myRootRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if([snapshot hasChildren]){
            NSLog(@"Snapshot data from firebase :  %@",[snapshot key]);
            
            
            //NSLog(@"Fetched collection centers data from firebase :  %@",[snapshot dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"name",@"city",nil]]);
            
            for(FDataSnapshot *cc in [snapshot children])
            {
                
                
                
                
                CollectionCenter *newCC = [[CollectionCenter alloc] init];
                //NSLog(@"Snapshot DATA ITWMS :  %@",[cc key]);
                //NSLog(@"Snapshot DATA Values :  %@",[cc value]);
                newCC.collectionCenterId = [cc key];
                
                newCC.name = [[cc value] objectForKey:@"name"];
                NSLog(@"URL : %@ ", [[cc value] objectForKey:@"name"]);
                newCC.city = [[cc value] objectForKey:@"city"];
                NSLog(@"URL : %@ ", [[cc value] objectForKey:@"city"]);
                newCC.address = [[cc value] objectForKey:@"address"];
                NSLog(@"URL : %@ ", [[cc value] objectForKey:@"address"]);
                newCC.zip = [[cc value] objectForKey:@"zip"];
                NSLog(@"URL : %@ ", [[cc value] objectForKey:@"zip"]);
                newCC.latitude = [[cc value] objectForKey:@"latitude"];
                NSLog(@"URL : %@ ", [[cc value] objectForKey:@"latitude"]);
                newCC.longitude = [[cc value] objectForKey:@"longitude"];
                NSLog(@"URL : %@ ", [[cc value] objectForKey:@"longitude"]);
                
                
                NSLog(@"Snapshot data from firebase :  %@",[snapshot key]);
                [self.collectionCenterArray  addObject:newCC];
                
                NSString *collectioncenterurl = [[[FireBaseConfig alloc] init] getCollectionCenterUrl];
                NSString *finalURl = [NSString stringWithFormat:@"%@/%@/%@",collectioncenterurl,newCC.collectionCenterId,@"appointments"];
                NSLog(@"URL being sent to firebase : %@",finalURl);
                
                
                /*
                 Firebase *ref = [[Firebase alloc] initWithUrl:finalURl];
                 [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snap){
                 
                 if([snap hasChildren]){
                 
                 for(FDataSnapshot *snip in [snap children]){
                 
                 if(![snip hasChild:@"uid"]){
                 Appointment *insideAppointment = [[Appointment alloc]init];
                 NSDateFormatter *df =[[NSDateFormatter alloc]init];
                 [df setDateFormat:@"dd-MM-yyyy HH:mm"];
                 insideAppointment.apppointmentId = [snip key];
                 NSString *inpDate = [[snip value] valueForKey:@"date"];
                 NSString *inpTime = [[snip value] valueForKey:@"time"];
                 NSString *finalDate = [NSString stringWithFormat:@"%@ %@",inpDate,inpTime];
                 
                 NSDate *formattedDate = [df dateFromString:finalDate];
                 
                 insideAppointment.date = formattedDate;
                 NSLog(@"Booked value : %@",[[snip value] valueForKey:@"booked"]);
                 if([[[snip value] valueForKey:@"booked"]  isEqual: @"true"]){
                 insideAppointment.booked = YES;
                 
                 }
                 else{
                 insideAppointment.booked = NO;
                 [newCC.appointments addObject:insideAppointment];
                 }
                 
                 
                 
                 }
                 }
                 
                 }
                 } withCancelBlock:^(NSError *error) {
                 NSLog(@"%@", error.description);
                 }];
                 
                 */
                
                
            }
            
            
            
            
            [self.tableView reloadData];
        }
        NSLog(@"Collection centers within view did appear inside colpemetin block: %@",self.collectionCenterArray);
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    NSLog(@"Collection centers within view did appear and outside the completion block: %@",self.collectionCenterArray);
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if(self.isFiltered){
        return [self.filteredCollectionCenterArray count];
    }
    return [self.collectionCenterArray count];
}


-(UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"List of Hospital %@",self.hospital.patientList);
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    
    if(!self.isFiltered){
        self.arrayToDisplay = self.collectionCenterArray;
        
    }
    else{
        self.arrayToDisplay = self.filteredCollectionCenterArray;
    }
    cell.detailTextLabel.text = [[self.arrayToDisplay objectAtIndex:indexPath.row] city];
    cell.textLabel.text = [[self.arrayToDisplay objectAtIndex:indexPath.row] name];

    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedRow =indexPath.row;
    NSLog(@"Collection centers within did select: %@",self.collectionCenterArray);
    
    [self performSegueWithIdentifier:@"showAvailableAppointmentSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAvailableAppointmentSegue"]) {
        /*
         if(!self.isFiltered){
         pat = [self.hospital.patientList objectAtIndex:selectedRow];
         
         }
         else{
         pat = [self.filteredString objectAtIndex:selectedRow];
         }
         */
        
        //Selecting the id to be displayed
        if(selectedRow >= 0){
            //[[segue destinationViewController] setCollectionCenterId:[self.collectionCenterArray objectAtIndex:selectedRow]];
            NSLog(@"Selected row %ld data : %@",selectedRow,[self.arrayToDisplay objectAtIndex:selectedRow]);
            [[segue destinationViewController] setBloodCollectionCenter:[self.arrayToDisplay objectAtIndex:selectedRow]];
            NSLog(@"Passing %@ from segue",[[self.arrayToDisplay objectAtIndex:selectedRow] appointments]);
            
        }
        
        
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
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

//Search Bar delegate protocol methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.tableView resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        self.isFiltered = NO;
    }
    else{
        self.isFiltered = YES;
        self.filteredCollectionCenterArray = [[NSMutableArray alloc] init];
        /*
         for(Patient *p in self.hospital.patientList){
         NSString *str = [p description];
         NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
         
         if(stringRange.location != NSNotFound){
         [self.filteredString addObject:p];
         }
         
         }
         */
        
        self.filteredCollectionCenterArray = [self searchPatientWithFirstOrLastName:searchText];
        
    }
    [self.tableView reloadData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.isFiltered = NO;
    [self.tableView reloadData];
}

//End of Search Bar delegate protocol methods

-(NSMutableArray *)searchPatientWithFirstOrLastName:(NSString *)searchText{
    
    NSMutableArray *pList = [[NSMutableArray alloc] init];
    for(CollectionCenter *p in self.collectionCenterArray){
        if([[p.name lowercaseString] containsString:[searchText lowercaseString]]){
            
            [pList addObject:p];
        }
        
    }
    return pList;
    
}




@end
