//
//  BackPopUp.h
//  MoneyTransfer
//
//  Created by GrayCell Technologies on 21/11/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BackPopUp : UIViewController
{
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIView *hudView;
@end
