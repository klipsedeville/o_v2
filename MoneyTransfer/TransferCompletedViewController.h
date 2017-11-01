//
//  TransferCompletedViewController.h
//  MoneyTransfer
//
//  Created by apple on 21/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransferCompletedViewController : UIViewController

// property
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *transactionIDLbl;

// Click Events
- (IBAction)M4BtnClicked:(id)sender;
- (IBAction)homeBtn:(id)sender;
- (IBAction)sendMoney:(id)sender;

@end
