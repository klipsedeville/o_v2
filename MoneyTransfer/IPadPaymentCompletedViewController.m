//
//  IPadPaymentCompletedViewController.m
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "IPadPaymentCompletedViewController.h"
#import "iPadLoginViewController.h"

@interface IPadPaymentCompletedViewController ()

@end

@implementation IPadPaymentCompletedViewController

#pragma mark #######
#pragma mark View Life Cycle
#pragma mark #######

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
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
}

#pragma mark #######
#pragma mark Click Action Events
#pragma mark #######

- (IBAction)backBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"BillPay" sender:self];
}
- (IBAction)homeBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"home" sender:self];
}

- (IBAction)payBtnClicked:(id)sender {
    [self performSegueWithIdentifier:@"BillPay" sender:self];
}

#pragma mark ########
#pragma mark Color HexString methods
#pragma mark #######

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

#pragma mark #######
#pragma mark Alert View Delegate
#pragma mark #######

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==1002)
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

@end
