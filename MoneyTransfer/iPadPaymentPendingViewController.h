//
//  iPadPaymentPendingViewController.h
//  MoneyTransfer
//
//  Created by 050 on 10/10/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 

@interface iPadPaymentPendingViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableDictionary *transferStatusData;

// property
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *statusView;
@property (strong, nonatomic) IBOutlet UITextField *navigationTitleTextField;
@property (strong, nonatomic) IBOutlet UILabel *referenceNumberLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel *statusLbl;
@property (strong, nonatomic) IBOutlet UILabel *bankAccNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *bankAccDescLabl;
@property (strong, nonatomic) IBOutlet UILabel *billTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *billOptionTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *AmountLbl;
@property (strong, nonatomic) IBOutlet UILabel *ExRateLbl;

// Click Events
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)contactCustomerSupportBtnClicked:(id)sender;



@end
