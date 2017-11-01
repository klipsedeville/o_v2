//
//  ShareOroboViewController.h
//  MoneyTransfer
//
//  Created by apple on 23/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareOroboViewController : UIViewController

//property
@property (strong, nonatomic) IBOutlet UILabel *referralCodeLbl;
@property (strong, nonatomic) IBOutlet UILabel *earnedMoney;

//click Events
- (IBAction)codeShareBtn:(id)sender;
- (IBAction)backBtnClicked:(id)sender;

@end
