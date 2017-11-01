//
//  iPadBeneficiaryConfirmationViewController.h
//  MoneyTransfer
//
//  Created by apple on 26/07/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPadBeneficiaryConfirmationViewController : UIViewController

// Property
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;

// Click Events
- (IBAction)addAnotherBtn:(id)sender;
- (IBAction)sendMoney:(id)sender;

@end
