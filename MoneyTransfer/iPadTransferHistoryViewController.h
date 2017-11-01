//
//  iPadTransferHistoryViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 24/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface iPadTransferHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *transferHistoryArray;
    MBProgressHUD *HUD;
     NSDictionary *transferStatusDict;
    NSString *listTypes;
}
@property (strong, nonatomic) IBOutlet UIView *transferView;
@property (strong, nonatomic) IBOutlet UIView *billView;
// property
@property (strong, nonatomic)IBOutlet UITableView *tableView;

// Click Action Events
-(IBAction)backBtnClicked:(id)sender;
- (IBAction)ActionTransferBtn:(id)sender;
- (IBAction)ActionBillBtn:(id)sender;
@end
