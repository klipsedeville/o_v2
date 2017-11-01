//
//  iPadSendMoneyViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 19/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "iPadSendMoneyViewController.h"
#import "iPadBeneficiariesViewController.h"
#import "iPadLoginViewController.h"
#import "ipadAddCardViewController.h"
#import "iPadBillersViewController.h"
#import "iPadTransferHistoryViewController.h"
#import "iPadUserProfileViewController.h"
#import "Controller.h"
#import "Constants.h"

@interface iPadSendMoneyViewController ()

@end

@implementation iPadSendMoneyViewController

#pragma mark ######
#pragma mark View life cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    
    transactionRequestArray = [[NSMutableArray alloc]init];
    
    self.navigationController.navigationBar.barTintColor = [self colorWithHexString:@"51595c"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [_scrollView setContentSize:CGSizeMake(self.sideView.frame.size.width,800)];
    _scrollView.bounces = NO;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    menu = NO;
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    self.navigationController.navigationBarHidden = NO;
    
    // Guesture
    UISwipeGestureRecognizer *swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(swipeleft:)];
    [tap setNumberOfTapsRequired: 1];
    [tap setNumberOfTouchesRequired: 1];
    [self.view addGestureRecognizer: tap];
    
}

#pragma mark ########
#pragma mark Color HexString methods
#pragma mark ######

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark ######
#pragma mark Menu Swipe methods
#pragma mark ######

-(void) hideSlideMenuBar
{
    // Hide Slide Menu bar
    self.sideView.frame = CGRectMake(-self.sideView.frame.size.width, self.sideView.frame.origin.y, self.sideView.frame.size.width, self.sideView.frame.size.height);
    lineView.hidden = NO;
    
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    // Slide Menu bar
    if (menu)
    {
        CGPoint touchPoint=[gestureRecognizer locationInView:self.sideView];
        if (touchPoint.x<= self.sideView.frame.size.width) {
        }
        else
        {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
                self.sideView.frame = CGRectMake(-self.sideView.frame.size.width, self.sideView.frame.origin.y, self.sideView.frame.size.width, self.sideView.frame.size.height);
                [self.navigationController setNavigationBarHidden:NO];
                
                lineView.hidden = NO;
                
            } completion:nil];
            
            menu = NO;
        }
    }
}

#pragma mark ######
#pragma mark Click Action methods
#pragma mark ######

- (IBAction)viewbtn:(id)sender {
    
    // Menu bar
    if (menu) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.sideView.frame = CGRectMake(-self.sideView.frame.size.width, self.sideView.frame.origin.y, self.sideView.frame.size.width, self.sideView.frame.size.height);
            [self.view setAlpha:1.0];
            lineView.hidden = NO;
            
        } completion:nil];
        
        menu = NO;
    }
    else
    {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.sideView.frame = CGRectMake(0, self.sideView.frame.origin.y, self.sideView.frame.size.width, self.sideView.frame.size.height);
            self.view.hidden = NO;
            [self.view setAlpha:1.6];
            [self.navigationController setNavigationBarHidden:YES];
            lineView.hidden = YES;
            
        } completion:nil];
        
        menu = YES;
    }
}

#pragma mark #####
#pragma mark Click Action methods
#pragma mark ######

- (IBAction)beneficiariesBtn:(id)sender {
    // Beneficary
    [self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShowBeneficiary" sender:self];
}
- (IBAction)payBillBtn:(id)sender {
    
    // Pay Bill
    [self performSegueWithIdentifier:@"BillPay" sender:self];
}

- (IBAction)sendMoneyBtn:(id)sender {
    
    // Send money
    [self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShowBeneficiary" sender:self];
}

- (IBAction)billersBtn:(id)sender {
    
    // billers
    [self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"BillPay" sender:self];
}

- (IBAction)transferHistoryBtn:(id)sender {
    
    // Transfer History
    [self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShowHistory" sender:self];
}

- (IBAction)profileBtn:(id)sender {
    
    // Profile
    [self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShowProfile" sender:self];
}

- (IBAction)addCardBtn:(id)sender {
    
    // Add card
    [self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShareOrbo" sender:self];
}

- (IBAction)logoutBtn:(id)sender {
    
    // User logout
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Logout from Orobo?" message:@"Are you sure you want to logout from Orobo ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertview.tag = 1001;
    [alertview show];
    
}

#pragma mark ######
#pragma mark Alert methods
#pragma mark ######

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0)
        {
            NSLog(@"Clicked button index 0");
        }
        else
        {
            NSLog(@"Clicked button index other than 0");
            
            // Call logout User
            [HUD removeFromSuperview];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = NSLocalizedString(@"Loading...", nil);
            [HUD show:YES];
            [self logoutUser];
        }
    }
    else if(alertView.tag ==1002)
    {
        if (buttonIndex==0)
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[iPadLoginViewController class]]) {
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    [self.navigationController setNavigationBarHidden:NO];
                    break;
                }
            }
        }
        
    }
    if(alertView.tag ==1003)
    {
        if (buttonIndex==0)
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[iPadLoginViewController class]]) {
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    [self.navigationController setNavigationBarHidden:NO];
                    break;
                }
            }
        }
    }
}
#pragma mark ######
#pragma mark Call user logout method
#pragma mark ######

-(void)logoutUser
{
    // Logout user
    [HUD removeFromSuperview];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil  forKey:@"loginUserData"];
    [def setObject:nil forKey:@"UserLogined"];
    [def setValue:@"Yes" forKey:@"UserLogout"];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[iPadLoginViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            [self.navigationController setNavigationBarHidden:NO];
            break;
        }
    }
}

@end
