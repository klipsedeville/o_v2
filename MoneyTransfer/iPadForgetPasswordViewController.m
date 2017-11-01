//
//  iPadForgetPasswordViewController.m
//  MoneyTransfer
//
//  Created by apple on 27/07/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "iPadForgetPasswordViewController.h"
#import "Controller.h"
#import "iPadLoginViewController.h"
#import "iPadResetPasswordViewController.h"

@interface iPadForgetPasswordViewController ()

@end

@implementation iPadForgetPasswordViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    _emailAddressHeadingLbl.hidden = NO;
    _emailAddressLbl.hidden = YES;
    [_emailAddressTextField becomeFirstResponder];
    
    self.emailAddressTextField.delegate = self;
    
    // BOttom border
    CALayer *FirstNameLayer2 = [CALayer layer];
    FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
    FirstNameLayer2.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
    [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
}

#pragma  mark ############
#pragma  mark Click Action methods
#pragma  mark ############

- (IBAction)RecoverPasswordBtn:(id)sender
{
    // Password Recover
    [self resignFirstResponder];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSString *emailAddress = [self.emailAddressTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    if([emailAddress length] == 0)
    {
        // if email empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please fill the form correctly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
        
    }
    else if([emailAddress length] > 0)
    {
        // if email is valid
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        int checkValue = [emailTest evaluateWithObject:self.emailAddressTextField.text];
        if (checkValue==0)
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter a valid email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertview show];
            
        }
        
        else
        {
            
            // Call Forgot Password
            [HUD removeFromSuperview];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = NSLocalizedString(@"Processing forgot password...", nil);
            [HUD show:YES];
            
            [ self callForgotPasswordMethod];
        }
    }
    
}

- (IBAction)backBtn:(id)sender{
    
    // Back button
    [ self.navigationController popViewControllerAnimated:YES];
    
}

#pragma  mark ############
#pragma  mark call Forgot Password web methods
#pragma  mark ############

-(void) callForgotPasswordMethod
{
   
    
    // Forgot password
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
             UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             
             [alertview show];
         [HUD removeFromSuperview];
     }];
}

#pragma  mark ############
#pragma  mark Text Field  methods
#pragma  mark ############

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

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
    
}

#pragma mark #############
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

-(void)cancelNumberPad{
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}

@end
