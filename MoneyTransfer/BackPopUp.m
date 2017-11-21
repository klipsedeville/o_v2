//
//  BackPopUp.m
//  MoneyTransfer
//
//  Created by GrayCell Technologies on 21/11/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "BackPopUp.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface BackPopUp ()
{
    
}
@end

@implementation BackPopUp

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10.0f;
    HUD = [[MBProgressHUD alloc] initWithFrame:_hudView.frame];
    [_hudView addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"", nil);
    [HUD show:YES];
}



@end


