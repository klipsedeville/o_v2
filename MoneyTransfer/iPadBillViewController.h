//
//  iPadBillViewController.h
//  MoneyTransfer
//
//  Created by 050 on 10/10/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface iPadBillViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    NSMutableArray *billArray,*billCategoryData;
    NSMutableArray *billsCategoryArray;
    NSString *selectedCategoryID;
    NSDictionary *billInstructionDic;
    NSMutableArray *allCurrencyArray;
    NSString *selectCountryCode, *selectedCountryName;
}
@property (strong, nonatomic) IBOutlet NSString *selectedBillerValue;
@property (strong, nonatomic) IBOutlet UITableView *billTableView;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)ActionAddBiller:(id)sender;



@end
