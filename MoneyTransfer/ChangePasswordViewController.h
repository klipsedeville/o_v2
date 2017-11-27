//
//  ChangePasswordViewController.h
//  MoneyTransfer
//
//  Created by apple on 26/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CoreText/CoreText.h"
#import "CustomPopUp.h"

@interface ChangePasswordViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>

{
    MBProgressHUD *HUD;
    IBOutlet UIButton *changePwdBtn;
    NSString *userPhoneNumber, *callingPhoneNumber;
}

// Property
@property (strong, nonatomic) IBOutlet UILabel *userOldPwdHeadingLbl;
@property (strong, nonatomic) IBOutlet UITextField *userOldPwdTextField;
@property (strong, nonatomic) IBOutlet UILabel *userOldPwdLbl;
@property (strong, nonatomic) IBOutlet UILabel *userNewPwdHeadingLbl;
@property (strong, nonatomic) IBOutlet UITextField *userNewPwdTextField;
@property (strong, nonatomic) IBOutlet UILabel *userNewPwdLbl;
@property (strong, nonatomic) IBOutlet UILabel *userConfirmPwdHeadingLbl;
@property (strong, nonatomic) IBOutlet UITextField *userConfirmPwdTextField;
@property (strong, nonatomic) IBOutlet UILabel *userConfirmPwdLbl;

//Click Events
- (IBAction)SaveBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;

@end
