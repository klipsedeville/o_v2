//
//  BeneficiariesViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 19/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BeneficiariesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>
{
    NSMutableDictionary *data;
     BOOL view;
    NSMutableArray *beneficiaryArray;
    MBProgressHUD *HUD;
    NSDictionary *beneficiaryDic;
    NSTimer *timer;
    NSString *selectedBeneficaryID;
    NSString *selectedUser;
    int index;
}

// property
@property (strong, nonatomic) IBOutlet UIButton *beneficiaryBtn;
@property (strong, nonatomic) IBOutlet UIView *beneficiaryView;
@property (strong, nonatomic) IBOutlet UIView *upperView;
@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UIView *lowerView;
@property (strong, nonatomic) IBOutlet UITableView *beneficiaryListTableView;
@property (strong, nonatomic) IBOutlet UIView *sendMoneyView;
@property (strong, nonatomic) IBOutlet UILabel *sendingMoneyUserNameLbl;
@property (strong, nonatomic) IBOutlet UIView *deleteView;
@property (strong, nonatomic) IBOutlet UILabel *beneficaryNameLbl;
@property (strong, nonatomic)  UIImageView *userImage;

// Click Events
- (IBAction)deleteBeneficaryBtn:(id)sender;
- (IBAction)SendMoneyBtn:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)newBeneficiaryBtn:(id)sender;
- (IBAction)plusBtn:(id)sender;


@end
