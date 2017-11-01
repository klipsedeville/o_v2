//
//  iPadSignUpViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 12/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

#import "MBProgressHUD.h"
#import "CoreText/CoreText.h"

@interface iPadSignUpViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>

{
    NSMutableArray *allCurrencyArray,*ImageArray;
    NSString *selectedAction;
    NSString *selectCountryCode;
    MBProgressHUD *HUD;
    CGRect previousRectFirstName,previousRectSurName,previousRectPhysicalAddress;
    
    NSURLConnection *serverConnection;
    NSMutableData *returnData;
    
    CALayer *firstNameLayer,*surNameLayer,*physicalAddressLayer,*referralCodeLayer;
    IBOutlet UIButton *registerBtn;
}
// property
@property (strong, nonatomic) UIImage *iconimage;
@property (strong, nonatomic) IBOutlet UIView *upperView;
@property (strong, nonatomic) IBOutlet UIView *upperMiddleView;
@property (strong, nonatomic) IBOutlet UIView *lowerMiddleView;
@property (strong, nonatomic) IBOutlet UIView *lowerView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLblHeading;
@property (strong, nonatomic) IBOutlet UILabel *surNameLblHeading;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressLblHeading;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLblHeading;
@property (strong, nonatomic) IBOutlet UILabel *physicalAddressLblHeading;
@property (strong, nonatomic) IBOutlet UILabel *passwordLblheading;
@property (strong, nonatomic) IBOutlet UILabel *repeatPasswordLblHeading;
@property (strong, nonatomic) IBOutlet UILabel *referralCodeLblHeading;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *surNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressLbl;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLbl;
@property (strong, nonatomic) IBOutlet UILabel *physicalAddressLbl;
@property (strong, nonatomic) IBOutlet UILabel *passwordLbl;
@property (strong, nonatomic) IBOutlet UILabel *repeatPasswordLbl;
@property (strong, nonatomic) IBOutlet UILabel *referralCodeLbl;
@property (strong, nonatomic) IBOutlet UITextView *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *surNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextView *physicalAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *referralCodeTextField;
@property (strong, nonatomic) IBOutlet UILabel *currencyIDLbl;
@property (strong, nonatomic) IBOutlet UIImageView *countryImage;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *currencyTableView;

// Click Action method
- (IBAction)countryBtn:(id)sender;
- (IBAction)registerBtn:(id)sender;
- (IBAction)logInBtn:(id)sender;
- (IBAction)backBtnClicked:(id)sender ;

@end;

