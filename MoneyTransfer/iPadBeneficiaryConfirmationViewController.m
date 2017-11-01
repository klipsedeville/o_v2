//
//  iPadBeneficiaryConfirmationViewController.m
//  MoneyTransfer
//
//  Created by apple on 26/07/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "iPadBeneficiaryConfirmationViewController.h"
#import "iPadLoginViewController.h"

@interface iPadBeneficiaryConfirmationViewController ()

@end

@implementation iPadBeneficiaryConfirmationViewController

#pragma mark ######
#pragma mark View life cycle methods
#pragma mark ###########

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    // Check User session expire or not
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
    
    
    NSString *loginUserName = [NSString stringWithFormat:@"SMILE %@",[userDataDict valueForKeyPath:@"first_name"]];
    _userNameLbl.text = loginUserName;
    _userNameLbl.text = [_userNameLbl.text  uppercaseString];
}

#pragma mark ###########
#pragma mark Alert view Delegate
#pragma mark ###########

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

#pragma mark ###########
#pragma mark Button Action
#pragma mark ###########

- (IBAction)addAnotherBtn:(id)sender {
    // Add beneficiary
    [self performSegueWithIdentifier:@"AddAnotherBeneficary" sender:self];
    
}

- (IBAction)sendMoney:(id)sender{
    // Send money
    [self performSegueWithIdentifier:@"ShowBeneficary" sender:self];
}

#pragma mark ###########
#pragma mark Segue Delegate method
#pragma mark ###########

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ShowBeneficary"]){
        NSLog(@"segue to Show beneficiary screen");
    }
    if([[segue identifier] isEqualToString:@"AddAnotherBeneficary"]){
        NSLog(@"segue to Add another beneficary screen");
    }
}

#pragma mark ########
#pragma mark Color HexString methods
#pragma mark ###########

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


@end
