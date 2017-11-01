//
//  iPadLoginViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface iPadLoginViewController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    MBProgressHUD *HUD;
    NSString *selectField;
    IBOutlet UIButton *loginBtnClick;
    
    NSTimer *timer;
    UIAlertView *myalert;
}
// Property
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressLbl;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *passwordLbl;
@property (strong, nonatomic) IBOutlet UILabel *logInUserNameLbl;

@property (strong, nonatomic) IBOutlet UIView *forgetPasswordView;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;

// Click Action
- (IBAction)forgetPwdBtnClick:(id)sender;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction) menuOptionClick:(id)sender;
- (IBAction)createAccountBtnClick:(id)sender;

@end
