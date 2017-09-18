//
//  DonationHistoryTableViewController.m
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/29/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import "DonationHistoryTableViewController.h"
//Firebase import
#import <Firebase/Firebase.h>
#import "FireBaseConfig.h"
#import "Donation.h"
//End firebase import
#import "ViewDonationViewController.h"


@interface DonationHistoryTableViewController ()

@end

@implementation DonationHistoryTableViewController
int donationHistorySelectedRow = -1;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.donationHistory= [[NSMutableArray alloc]init];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.donationHistory count];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
    [self.donationHistory removeAllObjects];
    Firebase *myRootRef = [[[FireBaseConfig alloc] init] getDonations];
    
    [myRootRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if([snapshot hasChildren]){
            NSLog(@"Snapshot data from firebase :  %@",[snapshot key]);
            
            
            //NSLog(@"Fetched collection centers data from firebase :  %@",[snapshot dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"name",@"city",nil]]);
            
            for(FDataSnapshot *snip in [snapshot children])
            {
                Donation *donation = [[Donation alloc]init];
                
                donation.appointmentId = [[snip value] objectForKey:@"appointmentId"];
                donation.collectionCenterName = [[snip value] objectForKey:@"collectionCenterName"];
                donation.pintsDonated = [[snip value] objectForKey:@"pintsDonated"];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"dd-MM-yyyy HH:mm"];
                
                donation.dateOfDonation = [df dateFromString:[[snip value] objectForKey:@"dateOfDonation"]];
                donation.donationType = [[snip value] objectForKey:@"donationType"];
                donation.donationId = [[snip value] objectForKey:@"donationId"];
                donation.donationPhase =[[snip value] objectForKey:@"donationPhase"];
                
                donation.address =[[snip value] objectForKey:@"address"];
                
                [self.donationHistory addObject:donation];
                
                
                
            }
            [self.tableView reloadData];
            NSLog(@"Collection centers within view did appear inside colpemetin block: %@",self.donationHistory);
            
        }
        
    }withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    NSLog(@"Collection centers within view did appear and outside the completion block: %@",self.donationHistory);
    
    
}

-(UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"List of Hospital %@",self.hospital.patientList);
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ Pints at %@",[[self.donationHistory objectAtIndex:indexPath.row] pintsDonated],[[self.donationHistory objectAtIndex:indexPath.row] collectionCenterName]];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MM-yyyy HH:mm"];
        cell.detailTextLabel.text  = [df stringFromDate:[[self.donationHistory objectAtIndex:indexPath.row] dateOfDonation]];
        
        cell.imageView.image = [self makeThumbnailOfSize:CGSizeMake(40, 40) sourceImage:[UIImage imageNamed:[ NSString stringWithFormat:@"%@.png",[[self.donationHistory objectAtIndex:indexPath.row] donationType]]]];
        //cell.imageView.image = [UIImage imageNamed:@"blood.png"];
    }
    
    
    return cell;
}

//Method to create a thumbnail out of the main image to display in the table view
- (UIImage *) makeThumbnailOfSize:(CGSize)size sourceImage:(UIImage *)uiImg
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    // draw scaled image into thumbnail context
    [uiImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // pop the context
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
        NSLog(@"could not scale image");
    return newThumbnail;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    donationHistorySelectedRow = indexPath.row;
     [self performSegueWithIdentifier:@"showTrackingSegue" sender:[tableView cellForRowAtIndexPath:indexPath]];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"showTrackingSegue"]) {
        
        Donation *donation = [self.donationHistory objectAtIndex:donationHistorySelectedRow];
        
        [[segue destinationViewController] setDonation:donation];
        
    }
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
