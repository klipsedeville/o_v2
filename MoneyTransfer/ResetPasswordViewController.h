//
//  ResetPasswordViewController.h
//  MoneyTransfer
//
//  Created by 050 on 18/09/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ResetPasswordViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>

{
    UIImageView *myImageView, *myImageView1, *myImageView2;
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UILabel *resetCodeHeading;
@property (strong, nonatomic) IBOutlet UITextField *ResetCodeTextfield;
@property (strong, nonatomic) IBOutlet UILabel *resetCodeLabel;

@property (strong, nonatomic) IBOutlet UILabel *PasswordHeading;
@property (strong, nonatomic) IBOutlet UITextField *PasswordTextfield;
@property (strong, nonatomic) IBOutlet UILabel *PasswordLabel;

@property (strong, nonatomic) IBOutlet UILabel *repeatPasswordHeading;
@property (strong, nonatomic) IBOutlet UITextField *RepeatPasswordTextfield;
@property (strong, nonatomic) IBOutlet UILabel *repeatPasswordLabel;

@property (strong, nonatomic) IBOutlet UIButton *ResetPasswordBtn;

//Click Events

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)ActionResetPassword:(id)sender;

@end
