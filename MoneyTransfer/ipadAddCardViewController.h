//
//  ipadAddCardViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 16/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPAPIClient.h"
#import "STPCardParams.h"
#import "STPCardValidator.h"
#import "CardIO.h"
#import "MBProgressHUD.h"

@interface ipadAddCardViewController : UIViewController<CardIOPaymentViewControllerDelegate,UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    NSString *cardType;
    NSString *StripeToken;
    MBProgressHUD *HUD;
    NSString *cardlast4Digit;
    IBOutlet UIButton *saveCardBtn;
    bool isfirst;
    BOOL isKeypadVisible;
}

// property
@property( strong, nonatomic) NSString *lastSourceView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *cardNumberHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *monthHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *yearHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *cvvHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *cardNicknameHeadingLbl;

@property (strong, nonatomic) IBOutlet UILabel *cardNumberLbl;
@property (strong, nonatomic) IBOutlet UILabel *monthLbl;
@property (strong, nonatomic) IBOutlet UILabel *yearLbl;
@property (strong, nonatomic) IBOutlet UILabel *cvvLbl;
@property (strong, nonatomic) IBOutlet UILabel *cardNicknameLbl;

@property (strong, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *monthTextField;
@property (strong, nonatomic) IBOutlet UITextField *yearTextField;
@property (strong, nonatomic) IBOutlet UITextField *cvvTextField;
@property (strong, nonatomic) IBOutlet UITextField *cardNicknameTextField;

// Click Action events
- (IBAction)saveCardBtn:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)cameraBtn:(id)sender;

@end
