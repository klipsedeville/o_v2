//
//  BillerViewController.h
//  MoneyTransfer
//
//  Created by 050 on 15/09/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BillerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    NSMutableArray *billArray,*billCategoryData;
    NSMutableArray *billsCategoryArray;
    NSString *selectedCategoryID;
    NSDictionary *billInstructionDic;
    NSMutableArray *allCurrencyArray;
    NSString *selectCountryCode, *selectedCountryName;
     NSString *selectedBiller;

}

@property (strong, nonatomic) IBOutlet NSString *selectedStateValue;
@property (strong, nonatomic) IBOutlet NSString *selectedPreviousCategoryValue;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong, nonatomic) IBOutlet UITableView *billerTableView;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)ActionAddBiller:(id)sender;

@end
