//
//  ForgetPasswordViewController.h
//  MoneyTransfer
//
//  Created by apple on 26/07/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ForgetPasswordViewController : UIViewController<UITextFieldDelegate>
{
     MBProgressHUD *HUD;
    IBOutlet UIButton *recoverPwdBtn;
    UIImageView *myImageView;
}

// property
@property (strong, nonatomic) IBOutlet UILabel *emailAddressHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressLbl;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextField;

// Click Events method
- (IBAction)RecoverPasswordBtn:(id)sender;
- (IBAction)backBtn:(id)sender;

@end
