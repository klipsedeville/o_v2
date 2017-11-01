//
//  LoginViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController< UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    NSString *selectField;
    IBOutlet UIButton *loginBtnClick;
    bool isfirst;
    UIImageView *myImageView, *myImageView1;
    NSTimer *timer;
    UIAlertView *myalert;
}
// Define properties
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressLbl;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *passwordLbl;
@property (strong, nonatomic) IBOutlet UILabel *logInUserNameLbl;
@property (strong, nonatomic) IBOutlet UIView *forgetPasswordView;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;
@property (strong, nonatomic) IBOutlet UIButton *ForgotPasswordButton;


// Click action events
- (IBAction)forgetPwdBtnClick:(id)sender;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)menuOptionClick:(id)sender;
- (IBAction)createAccountBtnClick:(id)sender;
- (IBAction)forgotPasswordBtnClick:(id)sender;

@end
