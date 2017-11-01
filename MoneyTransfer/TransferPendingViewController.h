//
//  TransferPendingViewController.h
//  MoneyTransfer
//
//  Created by apple on 19/09/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface TransferPendingViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableDictionary *transferStatusData;

// property
@property (strong, nonatomic) IBOutlet UILabel *exchangeRateLbl;
@property (strong, nonatomic) IBOutlet UILabel *inclusiveFeeLbl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *statusView;
@property (strong, nonatomic) IBOutlet UITextField *navigationTitleTextField;
@property (strong, nonatomic) IBOutlet UILabel *referenceNumberLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel *statusLbl;
@property (strong, nonatomic) IBOutlet UILabel *beneficiaryUserNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *SendingCountryNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *receivingCountryNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *settlementChannelNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *sendingAmountLbl;
@property (strong, nonatomic) IBOutlet UILabel *receivingAmountLbl;
@property (strong, nonatomic) IBOutlet UIView *lastView;

// Click Events
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)contactCustomerSupportBtnClicked:(id)sender;


@end
