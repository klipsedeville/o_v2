//
//  AgentProfileViewController.h
//  MoneyTransfer
//
//  Created by 050 on 26/09/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *agentNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *agentCommissionLbl;
@property (strong, nonatomic) IBOutlet UILabel *earningsLbl;
@property (strong, nonatomic) IBOutlet UILabel *accountNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLbl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)backBtnClicked:(id)sender;

@end
