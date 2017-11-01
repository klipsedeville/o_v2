//
//  ForgetPasswordViewController.m
//  MoneyTransfer
//
//  Created by apple on 26/07/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "Controller.h"
#import "LoginViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

#pragma mark ######
#pragma mark View Life Cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    myImageView = [[UIImageView alloc]init];
    myImageView.image = [UIImage imageNamed:@"textbox"];
    myImageView.hidden = YES;
  [myImageView setFrame:CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 5, self.emailAddressTextField.frame.size.width, 10)];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];

    // Add tool bar on number key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _emailAddressTextField.inputAccessoryView = numberToolbar;
}

-(void)viewWillAppear:(BOOL)animated{
    _emailAddressHeadingLbl.hidden = NO;
    _emailAddressLbl.hidden = YES;
    [_emailAddressTextField becomeFirstResponder];
    
    self.emailAddressTextField.delegate = self;
    myImageView.hidden = NO;
    CALayer *FirstNameLayer2 = [CALayer layer];
    FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
    FirstNameLayer2.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
    [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];

    
}
#pragma mark ######
#pragma mark - Action Method
#pragma mark ######

- (IBAction)RecoverPasswordBtn:(id)sender
{
    // Password recovery
    [self resignFirstResponder];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSString *emailAddress = [self.emailAddressTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    if([emailAddress length] == 0)
    {
        // If email empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please fill the form correctly." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
        
    }
    else if([emailAddress length] > 0)
    {
        // If email is valid
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        int checkValue = [emailTest evaluateWithObject:self.emailAddressTextField.text];
        if (checkValue==0)
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter a valid email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertview show];
        }
        
        else{
            [HUD removeFromSuperview];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = NSLocalizedString(@"Processing forgot password...", nil);
            [HUD show:YES];
            
            [ self callForgotPasswordMethod];
        }
    }
    
}

#pragma mark ########
#pragma mark ForgotPassword method
#pragma mark ######

-(void) callForgotPasswordMethod
{
    // Call Forgot Password method
    [Controller forgotPassord:self.emailAddressTextField.text withSuccess:^(id responseObject){
        
        [HUD removeFromSuperview];
        
        NSInteger status = [[responseObject valueForKeyPath:@"PayLoad.status"] integerValue];
        if (status == 0)
        {
            NSArray *errorArray =[ responseObject valueForKeyPath:@"PayLoad.error"];
            
            NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
            if(!errorString || [errorString isEqualToString:@"(null)"])
            {
                errorString = @"Your session has been expired.";
                
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alertview.tag = 1003;
                
                [alertview show];
            }
            else
            {
                
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertview show];
            }
        }
        
        else
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Great!" message:@"Password recovery started. Please check your email inbox for reset code." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil, nil];
            alertview.tag = 101;
            
            [alertview show];
        }
        
    }andFailure:^( NSString *errorString)
     {
         if (errorString == nil){
           errorString = @"Connection failed. Please make sure you have an active internet connection.";
         }
         [HUD removeFromSuperview];
         UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         
         [alertview show];
     }];
}

- (IBAction)backBtn:(id)sender{
    // back Button
    [ self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark ######
#pragma mark Alertview Delegate methods
#pragma mark ######

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        if (buttonIndex == 0)
        {
           [self performSegueWithIdentifier:@"resetSegue" sender:self];
        }
        else
        {
            
        }
    }
    else if (alertView.tag == 1001) {
        if (buttonIndex == 0)
        {
            [ self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
        }
    }
    else  if(alertView.tag==1002)
    {
        if (buttonIndex ==0)
        {
            [ self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if(alertView.tag ==1003)
    {
        if (buttonIndex==0)
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
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
#pragma mark Text Field methods
#pragma mark ########

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

-(void)cancelNumberPad{
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}

@end
