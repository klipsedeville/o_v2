//
//  PaymentCompletedViewController.m
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "PaymentCompletedViewController.h"
#import "LoginViewController.h"

@interface PaymentCompletedViewController ()

@end

@implementation PaymentCompletedViewController

#pragma mark ########
#pragma mark View Life Cycle
#pragma mark ########

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    // Check User Session Expired Or not
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    NSString *loginUserName = [userDataDict valueForKeyPath:@"User.first_name"];
    
    NSString *messageString = [ NSString stringWithFormat:@"Smile %@",loginUserName];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:messageString];
    [attrString beginEditing];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[self colorWithHexString:@"3ec6f0"]
                       range:NSMakeRange(0,5)];
    
    [_userNameLbl setAttributedText: attrString];
    [attrString endEditing];
    
    NSLog(@"Transaction data is ..%@",_transactionData);
    _transactionIDLbl.text = [NSString stringWithFormat:@"Transaction ID: %@",[_transactionData valueForKey:@"id"]];
    
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    double timeStampFromJSON = [[userDataDict valueForKeyPath:@"api_access_token.expires_on"] doubleValue];
    if([[NSDate date] timeIntervalSince1970] > timeStampFromJSON)
    {
        NSLog(@"User Session expired");
        
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Your session has been expired." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertview.tag = 1003;
        
        [alertview show];
        
    }
    else
    {
        NSLog(@"User Session not expired");
    }
    
    
}

#pragma mark ########
#pragma mark Click Action methods
#pragma mark ########

- (IBAction)backBtnClicked:(id)sender {
    
    // Back button
    [self performSegueWithIdentifier:@"BillPay" sender:self];
}

- (IBAction)homeBtnClicked:(id)sender {
    
    // home button
    [self performSegueWithIdentifier:@"home" sender:self];
}

- (IBAction)payBtnClicked:(id)sender {
    
    // pay button
    [self performSegueWithIdentifier:@"BillPay" sender:self];
}

#pragma mark ########
#pragma mark AlertView Delegates
#pragma mark ########

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==1003)
    {
        if (buttonIndex==0)
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LoginViewController class]]) {
                    
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setObject:@"YES"  forKey:@"UserLogined"];
                    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    [self.navigationController setNavigationBarHidden:NO];
                    
                    break;
                }
            }
        }
        
    }
}

#pragma mark ########
#pragma mark Color HexString methods
#pragma mark ########

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return  [UIColor whiteColor];
    
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


@end

