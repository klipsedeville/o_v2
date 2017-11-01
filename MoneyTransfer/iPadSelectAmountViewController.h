//
//  iPadSelectAmountViewController.h
//  MoneyTransfer
//
//  Created by apple on 06/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface iPadSelectAmountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *allCurrencyArray,*ImageArray;
    MBProgressHUD *HUD;
    NSString *direction,*beneficiaryID;
    NSString *sendingCurrecyID,*receivingCurrencyID;
    NSString *beneficiaryUserReceivngMoney;
    NSString *amount;
    NSMutableDictionary *selectedUserAmount;
    NSString *exRateValue,*feeValue;
    
    NSMutableDictionary *oldDic;
    NSString *oldImageURL;
}

// Property
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (strong, nonatomic) IBOutlet UILabel *amountLbl;
@property (strong, nonatomic) IBOutlet UIView *userNameView;
@property (strong, nonatomic) IBOutlet UIImageView *beneficiaryUserImageView;
@property (strong, nonatomic) IBOutlet UILabel *beneficiaryUserNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *beneficiaryUserCountryLbl;
@property (strong, nonatomic) IBOutlet UIView *beneficiarySendGetView;
@property (strong, nonatomic) IBOutlet UITextField *sendMoneyTextField;
@property (strong, nonatomic) IBOutlet UITextField *beneficiaryGetTextField;
@property (strong, nonatomic) UITableView *currencyTableView;
@property (strong, nonatomic) IBOutlet UILabel *currencyIDLbl;
@property (strong, nonatomic) IBOutlet UIImageView *countryImage;
@property (strong, nonatomic) IBOutlet UILabel *sendMoneyUserCurrencySymbolLbl;
@property (strong, nonatomic) IBOutlet UILabel *benificiaryGetCurrencySymbolLbl;
@property (strong, nonatomic) IBOutlet UILabel *sendMoneyUserCurrencySymbol1;
@property (strong, nonatomic) IBOutlet UILabel *exchangeRateLbl;
@property (strong, nonatomic) IBOutlet UILabel *exchangeRateLbl1;
@property (strong, nonatomic) IBOutlet UILabel *feeLbl;
@property (strong, nonatomic) IBOutlet UILabel *feeLbl1;
@property (strong, nonatomic) IBOutlet UIButton *continueBtn;
@property (strong, nonatomic) NSDictionary *beneficiaryUserInfo;

// Click Events
- (IBAction)M4BtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)continueBtn:(id)sender;
- (IBAction)countryBtn:(id)sender;

@end
