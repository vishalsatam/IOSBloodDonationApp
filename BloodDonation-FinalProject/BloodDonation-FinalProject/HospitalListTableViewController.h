//
//  HospitalListTableViewController.h
//  BloodDonation-FinalProject
//
//  Created by Vishal S Satam on 4/27/16.
//  Copyright (c) 2016 Vishal S Satam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCenter.h"

@interface HospitalListTableViewController : UITableViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchDisplayBar;
@property(strong,atomic)NSMutableArray *collectionCenterArray;

@property(strong,atomic)NSMutableArray *filteredCollectionCenterArray;
@property(strong,atomic)NSMutableArray *arrayToDisplay;
@property (nonatomic) BOOL isFiltered;
@end
