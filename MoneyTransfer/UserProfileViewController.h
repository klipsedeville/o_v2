//
//  UserProfileViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 23/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UserProfileViewController : UIViewController
{
    MBProgressHUD *HUD;
    NSMutableArray *allCurrencyArray,*ImageArray;
}

// Property
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *userMobileNumberLbl;
@property (strong, nonatomic) IBOutlet UILabel *userEmailAddressLbl;
@property (strong, nonatomic) IBOutlet UILabel *userAddressLbl;
@property (strong, nonatomic) IBOutlet UILabel *creditCardAddLbl;
@property (strong, nonatomic) IBOutlet UILabel *accountTierLbl;
@property (strong, nonatomic) NSMutableDictionary *merchantProfileData;
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UIButton *changeBtn;

// Click Events
- (IBAction)changePwdBtn:(id)sender;
- (IBAction)showPwdBtn:(id)sender;
- (IBAction)addNewCreditCard:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)ActionAgentProfile:(id)sender;

@end
