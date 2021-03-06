//
//  LocationViewController.h
//  MoneyTransfer
//
//  Created by 050 on 15/09/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LocationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    NSMutableArray *billArray,*billCategoryData;
    NSMutableArray *billsCategoryArray;
    NSString *selectedCategoryID;
    NSDictionary *billInstructionDic;
    NSMutableArray *allCurrencyArray;
    NSString *selectCountryCode, *selectedCountryName;
    NSString *selectedState;
}
@property (strong, nonatomic) IBOutlet NSString *selectedCategoryValue;
@property (strong, nonatomic) IBOutlet UITableView *billTableView;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)ActionAddBiller:(id)sender;

@end
