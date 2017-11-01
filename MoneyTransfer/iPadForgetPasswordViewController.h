//
//  iPadForgetPasswordViewController.h
//  MoneyTransfer
//
//  Created by apple on 27/07/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface iPadForgetPasswordViewController : UIViewController<UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    IBOutlet UIButton *recoverPwdBtn;
}

// property
@property (strong, nonatomic) IBOutlet UILabel *emailAddressHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressLbl;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextField;

//Click Action method
- (IBAction)RecoverPasswordBtn:(id)sender;
- (IBAction)backBtn:(id)sender;


@end
