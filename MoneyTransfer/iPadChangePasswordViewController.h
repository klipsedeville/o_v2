//
//  iPadChangePasswordViewController.h
//  MoneyTransfer
//
//  Created by apple on 26/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface iPadChangePasswordViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    IBOutlet UIButton *changePwdBtn;
}

// property
@property (strong, nonatomic) IBOutlet UILabel *userOldPwdHeadingLbl;
@property (strong, nonatomic) IBOutlet UITextField *userOldPwdTextField;
@property (strong, nonatomic) IBOutlet UILabel *userOldPwdLbl;
@property (strong, nonatomic) IBOutlet UILabel *userNewPwdHeadingLbl;
@property (strong, nonatomic) IBOutlet UITextField *userNewPwdTextField;
@property (strong, nonatomic) IBOutlet UILabel *userNewPwdLbl;
@property (strong, nonatomic) IBOutlet UILabel *userConfirmPwdHeadingLbl;
@property (strong, nonatomic) IBOutlet UITextField *userConfirmPwdTextField;
@property (strong, nonatomic) IBOutlet UILabel *userConfirmPwdLbl;

// Click Action Events
- (IBAction)SaveBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;



@end
