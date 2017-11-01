//
//  iPadSendMoneyViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 19/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface iPadSendMoneyViewController : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate>
{
    BOOL menu;
    IBOutlet UIView *lineView;
    MBProgressHUD *HUD;
    NSMutableArray *transactionRequestArray;
}

// property
@property (strong, nonatomic) IBOutlet UIView *sideView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// Click Events
- (IBAction)sendMoneyBtn:(id)sender;
- (IBAction)viewbtn:(id)sender;
- (IBAction)beneficiariesBtn:(id)sender;
- (IBAction)billersBtn:(id)sender;
- (IBAction)transferHistoryBtn:(id)sender;
- (IBAction)profileBtn:(id)sender;
- (IBAction)addCardBtn:(id)sender;
- (IBAction)logoutBtn:(id)sender;
- (IBAction)payBillBtn:(id)sender;



@end
