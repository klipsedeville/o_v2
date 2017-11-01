//
//  TransferHistoryViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 23/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface TransferHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *transferHistoryArray;
    NSDictionary *transferStatusDict;
    NSString *listTypes;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UIView *transferView;
@property (strong, nonatomic) IBOutlet UIView *billView;


// Property
@property (strong, nonatomic)IBOutlet UITableView *tableView;

// Click Event
-(IBAction)backBtnClicked:(id)sender;
- (IBAction)ActionTransferBtn:(id)sender;
- (IBAction)ActionBillBtn:(id)sender;


@end
