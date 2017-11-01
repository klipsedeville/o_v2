//
//  iPadLoginViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "iPadLoginViewController.h"
#import "ipadAddCardViewController.h"
#import "Controller.h"
#import "iPadSendMoneyViewController.h"
#import "Reachability.h"

@interface iPadLoginViewController ()

@end

@implementation iPadLoginViewController

#pragma mark ########
#pragma mark View Life Cycle
#pragma mark ########

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginView.hidden = YES;
    [_passwordTextField setSecureTextEntry:YES];
    _scrollView.bounces = NO;
    
    // Add tool bar on Number Key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    
    _emailAddressTextField.inputAccessoryView = numberToolbar;
    _passwordTextField.inputAccessoryView = numberToolbar;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.view endEditing:YES];
    
    [_emailAddressTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    [self.scrollView setBackgroundColor: [self colorWithHexString:@"073245"]];
    [self->loginBtnClick setBackgroundColor: [self colorWithHexString:@"82c460"]];
    
    UIColor *color = [UIColor whiteColor];
    _emailAddressTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    //Bottom border
    CALayer *FirstNameLayer = [CALayer layer];
    FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
    
    CALayer *FirstNameLayer1 = [CALayer layer];
    FirstNameLayer1.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
    FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
    [self.passwordTextField.layer addSublayer:FirstNameLayer1];
    
    // Do any additional setup after loading the view
    _emailAddressTextField.text = @"";
    _passwordTextField.text = @"";
    
    self.emailAddressLbl.frame = _emailAddressTextField.frame;
    self.emailAddressLbl.font = [UIFont systemFontOfSize:17];
    self.emailAddressLbl.textColor = [self colorWithHexString:@"51595c"];
    
    self.passwordLbl.frame = _passwordTextField.frame;
    self.passwordLbl.font = [UIFont systemFontOfSize:17];
    self.passwordLbl.textColor = [self colorWithHexString:@"51595c"];
    
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    NSString *userLogined = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserLogined"];
    
    if (userDataDict.count !=0) {
        if ([userLogined isEqualToString:@"YES"])
        {
            self.loginView.hidden = NO;
            
            NSString *loginUserName = [userDataDict valueForKeyPath:@"User.first_name"];
            _logInUserNameLbl.text = loginUserName;
            _logInUserNameLbl.text = [_logInUserNameLbl.text stringByAppendingString:@"!"];
            _emailAddressTextField.text = [userDataDict valueForKeyPath:@"User.email_address"];
        }
        else
        {
        }
    }
    else
    {
        self.loginView.hidden = YES;
        selectField = @"";
    }
    
    NSString *userStatus =  [[NSUserDefaults standardUserDefaults] valueForKey:@"UserLogout"];
    if ([userStatus isEqualToString:@"YES"]) {
        
        myalert = [[UIAlertView alloc] initWithTitle:@"Alert!"message:@"You have logged out successfully."
                                            delegate:self cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil, nil];
        myalert.tag = 1001;
        [myalert show];
        
        timer= [NSTimer scheduledTimerWithTimeInterval:2.0
                                                target:self selector:@selector(test)
                                              userInfo:nil
                                               repeats:NO];
        
        [[ NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"UserLogout"];
    }
    else{
        [[ NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"UserLogout"];
    }
    
    float sizeOfContent = 0;
    NSInteger wd = _signUpBtn.frame.origin.y;
    NSInteger ht = _signUpBtn.frame.size.height+10;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    
//    // Add TapGesture
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(handletap:)];
//
//    [self.view addGestureRecognizer:tap];
    
    
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

#pragma mark ########
#pragma mark Click Action methods
#pragma mark ########

- (IBAction)forgetPwdBtnClick:(id)sender;
{
    // Forget password
    [self performSegueWithIdentifier:@"ForgotPassword" sender:self];
}

- (IBAction)createAccountBtnClick:(id)sender;
{
    // Create Accoungt
    [self performSegueWithIdentifier:@"CreateAccount" sender:self];
}

#pragma  mark ############
#pragma  mark User Login click action methods
#pragma mark ########

-(IBAction)loginBtnClick:(id)sender
{
    // User Sign in
    [self resignFirstResponder];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSString *userNameStr = [self.emailAddressTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *passwordStr = [self.passwordTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    NSString *userLogined = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserLogined"];
    
    if ([userLogined isEqualToString:@"YES"])
    {
        userNameStr = [userDataDict valueForKeyPath:@"email_address"];
        if ([passwordStr length] == 0)
        {
            // If Password is empty
            
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertview show];
        }
        
        else
        {
            
            // Call User login method
            
            [HUD removeFromSuperview];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = NSLocalizedString(@"Logging in...", nil);
            [HUD show:YES];
            [ self callUserLoginMethod];
        }
    }
    else{
    if([userNameStr length] == 0)
    {
        // If username Empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter the email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if ([passwordStr length] == 0)
    {
        // IF password empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if([userNameStr length] > 0){
        
        // Email ID validation
        
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
        // Call user Login
        [HUD removeFromSuperview];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = NSLocalizedString(@"Logging in...", nil);
        [HUD show:YES];
        [ self callUserLoginMethod];
    }
    }
    }
}

#pragma mark ########
#pragma mark Calluser Login method
#pragma mark ########

-(void) callUserLoginMethod
{
    // Call USer Login
    [Controller loginByUserEmail:self.emailAddressTextField.text Password:self.passwordTextField.text withSuccess:^(id responseObject){
        [HUD removeFromSuperview];
        NSInteger status = [[responseObject valueForKeyPath:@"PayLoad.status"] integerValue];
        if (status == 0)
        {
            NSArray *errorArray =[ responseObject valueForKeyPath:@"PayLoad.error"];
            NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
            
        }else
        {
            NSDictionary *userProfile = [[ NSDictionary alloc] initWithDictionary:[[responseObject valueForKey:@"PayLoad"] valueForKey:@"data"]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:userProfile] forKey:@"loginUserData"];
            [self performSegueWithIdentifier:@"SendMoney" sender:self];
        }
        
    }andFailure:^( NSString *errorString)
     {
         if(!errorString || [errorString isEqualToString:@"(null)"])
         {
         }
         else
         {
             UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alertview show];
         }
         
         [HUD removeFromSuperview];
     }];
}

#pragma mark ########
#pragma mark Alert Method
#pragma mark ########

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Clicked button index 0");
    }
    else
    {
        NSLog(@"Clicked button index other than 0");
        _emailAddressTextField.text = @"";
        _passwordTextField.text = @"";
    }
}

#pragma mark ###########
#pragma mark - Text Fields Deletgate methods
#pragma mark ###########

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _emailAddressTextField)
    {
        [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width,_scrollView.contentSize.height + 250)];
        
        if (![selectField isEqualToString:@"Email"]) {
            selectField = @"Email";
            [UIView animateWithDuration:0.5f animations:^{
                if (textField == _emailAddressTextField && [ _passwordTextField.text isEqual:@""]){
                    
                    CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
                    [self.passwordTextField.layer addSublayer:FirstNameLayer];
                    
                    [_passwordTextField resignFirstResponder];
                    [_emailAddressTextField becomeFirstResponder];
                    
                }
                else if(textField == _emailAddressTextField && ![ _passwordTextField.text isEqual:@""])
                {
                    CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
                    [self.passwordTextField.layer addSublayer:FirstNameLayer];
                    [_passwordTextField resignFirstResponder];
                    [_emailAddressTextField becomeFirstResponder];
                }
                
                CALayer *FirstNameLayer = [CALayer layer];
                FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
                FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
            }
                             completion:^(BOOL finished){
                             }];
        }
    }
    else if(textField == _passwordTextField)
    {
//        _forgetPasswordView.hidden = YES;
        [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width,_scrollView.contentSize.height + 250)];
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_passwordTextField.frame.origin.x, _passwordTextField.frame.origin.y-250, _passwordTextField.frame.size.width, _passwordTextField.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
        
        if (![selectField isEqualToString:@"password"]) {
            selectField = @"password";
            [UIView animateWithDuration:0.5f animations:^{
                if (textField == _passwordTextField && [ _emailAddressTextField.text isEqual:@""])
                {
                    CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
                    [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
                    [_emailAddressTextField resignFirstResponder];
                    [_passwordTextField becomeFirstResponder];
                    
                }
                else if(textField == _passwordTextField && ![ _emailAddressTextField.text isEqual:@""])
                {
                    CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
                    [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
                    [_emailAddressTextField resignFirstResponder];
                    [_passwordTextField becomeFirstResponder];
                }
                
                CALayer *FirstNameLayer = [CALayer layer];
                FirstNameLayer.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
                FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                [self.passwordTextField.layer addSublayer:FirstNameLayer];
            }completion:^(BOOL finished){
            }];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    float sizeOfContent = 0;
    NSInteger wd = _signUpBtn.frame.origin.y;
    NSInteger ht = _signUpBtn.frame.size.height+10;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField == _passwordTextField && [ _passwordTextField.text isEqual:@""])
    {
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.passwordTextField.layer addSublayer:FirstNameLayer];
    }
    if(textField == _emailAddressTextField && [ _emailAddressTextField.text isEqual:@""])
    {
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
    }
    
    float sizeOfContent = 0;
    NSInteger wd = _signUpBtn.frame.origin.y;
    NSInteger ht = _signUpBtn.frame.size.height+10;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    
    return YES;
}
#pragma mark ########
#pragma mark Scroll View Method
#pragma mark ########

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 350; // Remove area covered by keyboard
    
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [_scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

-(void)cancelNumberPad{
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}


@end
