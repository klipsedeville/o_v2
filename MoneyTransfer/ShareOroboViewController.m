//
//  ShareOroboViewController.m
//  MoneyTransfer
//
//  Created by apple on 23/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "ShareOroboViewController.h"
#import "LoginViewController.h"

@interface ShareOroboViewController ()

@end

@implementation ShareOroboViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    // Check user Session expired or Not
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    double timeStampFromJSON = [[userDataDict valueForKeyPath:@"api_access_token.expires_on"] doubleValue];
    if([[NSDate date] timeIntervalSince1970] > timeStampFromJSON)
    {
        NSLog(@"User Session expired");
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Your session has been expired." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertview.tag = 1003;
        [alertview show];
    }
    else{
        NSLog(@"User Session not expired");
    }
    
    if ([[userDataDict valueForKeyPath:@"affiliate.affiliate_code"] isKindOfClass:[NSNull class]])
    {
        _referralCodeLbl.text = @"null";
    }
    else
    {
        _referralCodeLbl.text = [NSString stringWithFormat:@"%@",[userDataDict valueForKeyPath:@"affiliate.affiliate_code"]];
    }
    if ([[userDataDict valueForKeyPath:@"affiliate.balance"] isKindOfClass:[NSNull class]])
    {
        _earnedMoney.text = @"null";
    }
    else
    {
        _earnedMoney.text = [NSString stringWithFormat:@"%@",[userDataDict valueForKeyPath:@"affiliate.balance"]];
    }
}

#pragma  mark ############
#pragma  mark Click Action methods
#pragma  mark ############

- (IBAction)backBtnClicked:(id)sender {
    // back button
    [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)codeShareBtn:(id)sender {
    
    // Sahre Content to Social network
    [self shareContent];
}

#pragma  mark ############
#pragma  mark Share methods
#pragma  mark ############

-(void)shareContent{
    
    // Share Content
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    
    NSString *str=[NSString stringWithFormat:@"I use Orobo to send money home and pay bills for loved ones. You should do to. Use my referral code %@ to earn extra.",[userDataDict valueForKeyPath:@"affiliate.affiliate_code"]];
    
    NSArray *postItems=@[str];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark ########
#pragma mark AlertView Delegates
#pragma  mark ############

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==1003)
    {
        if (buttonIndex==0)
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                [def setObject:@"YES"  forKey:@"UserLogined"];

                if ([controller isKindOfClass:[LoginViewController class]]) {
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
