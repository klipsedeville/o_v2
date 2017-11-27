//
//  SignUpViewViewController.h
//  MoneyTransfer
//
//  Created by apple on 27/11/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "CoreText/CoreText.h"
#import "CustomPopUp.h"

@interface SignUpViewViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate, CustomPopUpDelegate>
{
    NSMutableArray *allCurrencyArray,*ImageArray;
    NSString *selectedAction;
    NSString *selectCountryCode;
    MBProgressHUD *HUD;
    CGRect previousRectFirstName,previousRectSurName,previousRectPhysicalAddress;
    
    NSURLConnection *serverConnection;
    NSMutableData *returnData;
    
    CALayer *firstNameLayer,*surNameLayer,*physicalAddressLayer,*referralCodeLayer;
    NSString *userPhoneNumber, *callingPhoneNumber;
}
@property (strong, nonatomic) UIImage *iconimage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *crossBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *view1_email;
@property (weak, nonatomic) IBOutlet UIView *view2_number;
@property (weak, nonatomic) IBOutlet UIView *view3_details;
@property (weak, nonatomic) IBOutlet UIView *view4_password;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *numberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *addressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *repeatPssTextfield;
@property (strong, nonatomic) IBOutlet UILabel *currencyIDLbl;
@property (strong, nonatomic) IBOutlet UIImageView *countryImage;
@property (strong, nonatomic) UITableView *currencyTableView;
@property (weak, nonatomic) IBOutlet UIButton *currencyBtn;

- (IBAction)countryBtn:(id)sender;
- (IBAction)ActionCrossBtn:(id)sender;
- (IBAction)ActionNextBtn:(id)sender;

@end
