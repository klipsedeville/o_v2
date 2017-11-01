//
//  iPadTransferCompletedViewController.h
//  MoneyTransfer
//
//  Created by apple on 21/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPadTransferCompletedViewController : UIViewController

// property
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *transactionIDLbl;

// Click Action Events
- (IBAction)M4BtnClicked:(id)sender;
- (IBAction)homeBtn:(id)sender;

@end
