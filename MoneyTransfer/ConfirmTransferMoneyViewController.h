//
//  ConfirmTransferMoneyViewController.h
//  MoneyTransfer
//
//  Created by apple on 07/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Controller.h"

@interface ConfirmTransferMoneyViewController : UIViewController
{
    MBProgressHUD *HUD;
    NSString *sending_country_currency,*receiving_country_currency,*sending_amount,*receiving_amount,*fee,*exchange_rate,*beneficiary_id,*source;
    NSDictionary *transferConfirmMoneyInfoNew;
    
    UIView *backGroundVW;
}

// Property
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *exchangeRateLbl;
@property (strong, nonatomic) IBOutlet UILabel *inclusiveFeeLbl;
@property (strong, nonatomic) IBOutlet UILabel *last4DigitCreditCardLbl;
@property (strong, nonatomic) IBOutlet UILabel *SendingMoneyUserNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *sendingMoneyUserCountryNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *sendingAmountTransferLbl;
@property (strong, nonatomic) NSDictionary *transferConfirmMoneyInfo;

// Click Events
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)sendMoneyBtn:(id)sender;

@end
  
