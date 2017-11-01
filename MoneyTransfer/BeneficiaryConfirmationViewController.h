//
//  BeneficiaryConfirmationViewController.h
//  MoneyTransfer
//
//  Created by apple on 25/07/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeneficiaryConfirmationViewController : UIViewController

// property
@property (strong, nonatomic) IBOutlet UILabel *userNameLbl;

// Click Events method 
- (IBAction)addAnotherBtn:(id)sender;
- (IBAction)sendMoney:(id)sender;


@end
