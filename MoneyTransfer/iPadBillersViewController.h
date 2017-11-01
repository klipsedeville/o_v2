//
//  iPadBillersViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 24/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface iPadBillersViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *billerArray,*searchBillersArray;
    MBProgressHUD *HUD;
    UITextField *textField;
    bool flag;
}

// property
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

// Click Actin Events
- (IBAction)backBtnClicked:(id)sender;
@end
