//
//  IPadPaymentCompletedViewController.h
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPadPaymentCompletedViewController : UIViewController

// property
@property (strong, nonatomic) IBOutlet UILabel *transactionIDLbl;
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
@property (strong, nonatomic) NSMutableDictionary *transactionData;

// Click Action Events
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)homeBtnClicked:(id)sender;
- (IBAction)payBtnClicked:(id)sender;
@end
