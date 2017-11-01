//
//  AddBillerViewController.h
//  MoneyTransfer
//
//  Created by 050 on 20/09/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddBillerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    NSMutableArray *billArray,*billCategoryData, *billsCategoryArray;
    NSMutableDictionary *userData;

    NSString *selectedCategoryID;
    NSDictionary *billInstructionDic;
    NSMutableArray *allCurrencyArray,*categoryArray, *locationArray, *bankArray;
    NSString *selectCountryCode, *selectedCountryName, *selectionType, *selectCountryID, *selectCatID, *selectLocID, *selectBankID;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *billerNameTextfield;
@property (strong, nonatomic) IBOutlet UILabel *selectBillerCategoryLbl;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextfield;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (strong, nonatomic) IBOutlet UITextField *physicalAddressTextfield;
@property (strong, nonatomic) IBOutlet UILabel *selectLocationLbl;
@property (strong, nonatomic) IBOutlet UILabel *selectBankLbl;
@property (strong, nonatomic) IBOutlet UITextField *accountNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *accountNumberTextfield;
@property (strong, nonatomic) IBOutlet UITextField *billNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *billAmountTextfield;

@property (strong, nonatomic) IBOutlet UILabel *currencyIDLbl;
@property (strong, nonatomic) IBOutlet UIImageView *countryImage;
@property (strong, nonatomic) UITableView *currencyTableView;
@property (strong, nonatomic) IBOutlet UIView *currencyView;
@property (strong, nonatomic) IBOutlet UIImageView *billAmountImage;

@property (strong, nonatomic) IBOutlet UITableView *categoryTableView;
@property (strong, nonatomic) IBOutlet UITableView *locationTableView;
@property (strong, nonatomic) IBOutlet UITableView *bankTableView;
@property (strong, nonatomic) IBOutlet UILabel *billAmountImgLabel;

@property (strong, nonatomic) IBOutlet UIView *billerView;
@property (strong, nonatomic) IBOutlet UIView *categoryView;
@property (strong, nonatomic) IBOutlet UIView *nameView;
@property (strong, nonatomic) IBOutlet UIView *emailView;
@property (strong, nonatomic) IBOutlet UIView *numberView;
@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (strong, nonatomic) IBOutlet UIView *bankView;
@property (strong, nonatomic) IBOutlet UIView *accNameView;
@property (strong, nonatomic) IBOutlet UIView *accountNumberView;
@property (strong, nonatomic) IBOutlet UIView *billNameView;
@property (strong, nonatomic) IBOutlet UIView *lastView;

- (IBAction)ActionNextBtn:(id)sender;
- (IBAction)currencyBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)ActionSelectBillerCategory:(id)sender;
- (IBAction)ActionSelectLocation:(id)sender;
- (IBAction)ActionSelectBank:(id)sender;

@end
