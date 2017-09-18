//
//  MyAppointmentsTableViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/29/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import "MyAppointmentsTableViewController.h"
#import "ViewAppointmentViewController.h"
//Firebase import
#import <Firebase/Firebase.h>
#import "FireBaseConfig.h"
//End firebase import


@interface MyAppointmentsTableViewController ()

@end

@implementation MyAppointmentsTableViewController

int myAppointmentSelectedRow = -1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.myAppointments = [[NSMutableArray alloc] init];
    self.collectionCenterToBePassedArray = [[NSMutableArray alloc] init];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.myAppointments removeAllObjects];
    Firebase *ref = [[[FireBaseConfig alloc] init] getAppointments];
   
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snap){
        
        //if([snap hasChildren]){
        for(FDataSnapshot *snip in [snap children]){
            
            if([[[snip value] valueForKey:@"completed"] isEqualToString:@"false"]){
            Appointment *app = [[Appointment alloc]init];
            app.apppointmentId = [snip key];
            
            NSString *dte =[[snip value] valueForKey:@"date"];
            NSString *tm =[[snip value] valueForKey:@"time"];
            
            NSDateFormatter *df =[[NSDateFormatter alloc]init];
            [df setDateFormat:@"dd-MM-yyyy HH:mm"];
            app.date = [df dateFromString:[NSString stringWithFormat:@"%@ %@",dte,tm]];
            app.collectionCenterId = [[snip value] valueForKey:@"collectionCenterId"];
            
            NSLog(@"Collection center id : %@",app.collectionCenterId);
            
            [self.myAppointments addObject:app];
            NSLog(@"Adding a new apointment : %@",self.myAppointments);
            NSLog(@"Adding a new apointment  collection center id :: %@",[[self.myAppointments objectAtIndex:0] collectionCenterId]);
            }
        }
        
        
        [self.tableView reloadData];
       // }
    }];

    myAppointmentSelectedRow = -1;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myAppointmentSelectedRow = indexPath.row;
    [self setValueForCollectionCenterToBePassed];
    
    //[self performSegueWithIdentifier:@"viewAppointmentDirectlySegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"COUNT OF ROWS : %ld",[self.myAppointments count]);
    return [self.myAppointments count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        // Configure the cell...
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        NSDateFormatter *df =[[NSDateFormatter alloc]init];
        [df setDateFormat:@"dd-MM-yyyy HH:mm"];
        
        cell.textLabel.text = [df stringFromDate:[[self.myAppointments objectAtIndex:indexPath.row] date]];
        NSLog(@"Cell text : %@",cell.textLabel.text);
        
        Firebase *ref = [[[[[FireBaseConfig alloc] init] getCollectionCenter] childByAppendingPath:[[self.myAppointments objectAtIndex:indexPath.row] collectionCenterId]] childByAppendingPath:@"name"];
        [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snap){
         
            cell.detailTextLabel.text = [snap value];
            
        }];
        
        
        
    }
    
    
    return cell;
}

-(void)setValueForCollectionCenterToBePassed{
    Firebase *ref = [[[[FireBaseConfig alloc] init] getCollectionCenter] childByAppendingPath:[[self.myAppointments objectAtIndex:myAppointmentSelectedRow] collectionCenterId]];
    
    __block CollectionCenter *c = [[CollectionCenter alloc]init];
    __block NSString *blockname = @"OUT BAD";
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snap){
        
        CollectionCenter *insideCollectionCenter = [[CollectionCenter alloc]init];
        if([snap hasChildren]){
            insideCollectionCenter.latitude = [[snap value] valueForKey:@"latitude"];
            insideCollectionCenter.longitude = [[snap value] valueForKey:@"longitude"];
            insideCollectionCenter.name = [[snap value] valueForKey:@"name"];
            insideCollectionCenter.address = [[snap value] valueForKey:@"address"];
            insideCollectionCenter.city = [[snap value] valueForKey:@"city"];
            insideCollectionCenter.zip = [[snap value] valueForKey:@"zip"];
        }
        c = insideCollectionCenter;
        NSLog(@"Inside c : %@",c.name);
        _collectionCenterToBePassed.name = [[snap value] valueForKey:@"name"];
        _collectionCenterToBePassed.latitude = [[snap value] valueForKey:@"latitude"];
        _collectionCenterToBePassed.longitude= [[snap value] valueForKey:@"longitude"];
        _collectionCenterToBePassed.address= [[snap value] valueForKey:@"address"];
        _collectionCenterToBePassed.city= [[snap value] valueForKey:@"city"];
        _collectionCenterToBePassed.zip= [[snap value] valueForKey:@"zip"];
        
        
        NSLog(@"Insude mainpassing cc : %@",_collectionCenterToBePassed.name);
        blockname = @"INGOOD";
        NSLog(@"%@",blockname);
        [self performSegueWithIdentifier:@"viewAppointmentDirectlySegue" sender:self];
        
    }];
    NSLog(@"%@",blockname);
    NSLog(@"Outside c : %@",c.name);
    _collectionCenterToBePassed = c;
    NSLog(@"outside mainpassing cc : %@",_collectionCenterToBePassed.name);

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"viewAppointmentDirectlySegue"]) {
        
        Appointment *app = [self.myAppointments objectAtIndex:myAppointmentSelectedRow];
        
        [[segue destinationViewController] setConfirmedAppointment:app];
        [[segue destinationViewController] setBloodCollectionCenter:_collectionCenterToBePassed];

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

@end
