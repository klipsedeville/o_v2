//
//  IPadBillPayViewController.h
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface IPadBillPayViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    MBProgressHUD *HUD;
    NSMutableArray *billArray,*billCategoryData;
    NSMutableArray *billsCategoryArray;
    NSString *selectedCategoryID;
    NSDictionary *billInstructionDic;
    
    NSMutableArray *allCurrencyArray;
    NSString *selectCountryCode, *selectedCountryName, *viewFor, *selectCategoryID;
}

//property
@property (strong, nonatomic) IBOutlet UILabel *currencyIDLbl;
@property (strong, nonatomic) IBOutlet UIImageView *countryImage;
@property (strong, nonatomic) UITableView *currencyTableView;
@property (strong, nonatomic) IBOutlet UIView *currencyView;
@property (strong, nonatomic) IBOutlet UIView *stripView;
@property (strong, nonatomic) IBOutlet UITableView *billTableView;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// Click Action Events
- (IBAction)currencyBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)ActionAddBiller:(id)sender;

@end
