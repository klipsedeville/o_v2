//
//  TransferCompletedViewController.m
//  MoneyTransfer
//
//  Created by apple on 21/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "TransferCompletedViewController.h"
#import "LoginViewController.h"

@interface TransferCompletedViewController ()

@end

@implementation TransferCompletedViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    // Check user Session expired or not
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    

    NSString *loginUserName = [userDataDict valueForKeyPath:@"User.first_name"];
    NSString *messageString = [ NSString stringWithFormat:@"Smile %@!",loginUserName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:messageString];
    [attrString beginEditing];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[self colorWithHexString:@"3ec6f0"]
                       range:NSMakeRange(0,5)];
    
    [_userNameLbl setAttributedText: attrString];
    [attrString endEditing];

    
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
    
    _transactionIDLbl.text = [NSString stringWithFormat:@"TRANSACTION ID: %@",[userDataDict valueForKeyPath:@"api_access_token.id"]];
    
    [_userNameLbl setFont:[UIFont boldSystemFontOfSize:16]];
    [_transactionIDLbl setFont:[UIFont boldSystemFontOfSize:15]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark ############
#pragma  mark Click Events Methods
#pragma  mark ############

- (IBAction)M4BtnClicked:(id)sender {
    // Send money
    [self performSegueWithIdentifier:@"sendMoney" sender:self];
}

- (IBAction)homeBtn:(id)sender {
    
    // home button
    [self performSegueWithIdentifier:@"sendMoney" sender:self];
}

- (IBAction)sendMoney:(id)sender {
    // Send Money
    [self performSegueWithIdentifier:@"beneficiary" sender:self];
}

#pragma mark ############
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
#pragma mark ############
#pragma mark Color HexString methods
#pragma  mark ############

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