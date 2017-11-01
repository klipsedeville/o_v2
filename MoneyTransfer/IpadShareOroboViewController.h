//
//  IpadShareOroboViewController.h
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IpadShareOroboViewController : UIViewController

// property
@property (strong, nonatomic) IBOutlet UILabel *referralCodeLbl;
@property (strong, nonatomic) IBOutlet UILabel *earnedMoney;

// Click Action Events
- (IBAction)codeShareBtn:(id)sender;
- (IBAction)backBtnClicked:(id)sender;

@end
