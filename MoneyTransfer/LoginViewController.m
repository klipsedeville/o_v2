
//
//  LoginViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "LoginViewController.h"
#import "Controller.h"
#import "AddCardViewController.h"
#import "SendMoneyViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark ######
#pragma mark View Life Cycle methods
#pragma mark ######

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    myImageView = [[UIImageView alloc] init];
    myImageView1 = [[UIImageView alloc] init];
    myImageView.hidden = YES;
    myImageView1.hidden = YES;
    
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

-(void) viewWillAppear:(BOOL)animated
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
    
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureEmailAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGesturePassword = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    [self.emailAddressLbl addGestureRecognizer:tapGestureEmailAddress];
    [self.passwordLbl addGestureRecognizer:tapGesturePassword];
    
    self.emailAddressLbl.userInteractionEnabled = YES;
    self.passwordLbl.userInteractionEnabled = YES;
    
    _emailAddressLbl.tag = 1;
    _passwordLbl.tag = 2;
    
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
    if ([userStatus isEqualToString:@"Yes"]) {
        
        myalert = [[UIAlertView alloc] initWithTitle:@"Alert!"message:@"You have logged out successfully."
                                            delegate:self cancelButtonTitle:@""
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
}



#pragma mark ########
#pragma mark Color HexString methods
#pragma mark ######

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
#pragma mark ######

-(IBAction)loginBtnClick:(id)sender
{
    [self resignFirstResponder];
    
    // Removing white space from email ID and password
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSString *userEmailStr = [self.emailAddressTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *passwordStr = [self.passwordTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    NSString *userLogined = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserLogined"];
    
        if ([userLogined isEqualToString:@"YES"])
        {
            userEmailStr = [userDataDict valueForKeyPath:@"email_address"];
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
    if([userEmailStr length] == 0)
    {
        // If email ID is empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter the email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
        }

    else if ([passwordStr length] == 0)
    {
        // If Password is empty
        
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if([userEmailStr length] > 0){
        
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
            
            // Call User login method
            
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

- (IBAction)createAccountBtnClick:(id)sender;
{
    // Create an account
    [self performSegueWithIdentifier:@"CreateAccount" sender:self];
}

- (IBAction)forgotPasswordBtnClick:(id)sender {
    
    [self performSegueWithIdentifier:@"ForgotPassword" sender:self];
}


#pragma mark ########
#pragma mark User Login method
#pragma mark ######

-(void) callUserLoginMethod
{
    // Sign in action
    
    [Controller loginByUserEmail:self.emailAddressTextField.text Password:self.passwordTextField.text withSuccess:^(id responseObject){
        
        [HUD removeFromSuperview];
        
        NSInteger status = [[responseObject valueForKeyPath:@"PayLoad.status"] integerValue];
        if (status == 0)
        {
            NSArray *errorArray =[ responseObject valueForKeyPath:@"PayLoad.error"];
            
            NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
            
            
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertview show];
            
            
        }
        else
        {
            NSDictionary *userProfile = [[ NSDictionary alloc] initWithDictionary:[[responseObject valueForKey:@"PayLoad"] valueForKey:@"data"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:userProfile] forKey:@"loginUserData"];
            
            [self performSegueWithIdentifier:@"SendMoney" sender:self];
        }
        
    }andFailure:^( NSString *errorString)
     {
         [HUD removeFromSuperview];
         
         UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Connection failed. Please make sure you have an active internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         
         [alertview show];
        
     }];
}

#pragma mark ######
#pragma mark AlertView Delegate method
#pragma mark ######

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1001) {
        
        if(timer!=nil){
            [timer invalidate];
            timer=nil;
        }
    }
    else{
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
    
}


-(void)test{
    
    // Remove alert of successful log out after 2 seconds
    
    [myalert dismissWithClickedButtonIndex:-1 animated:YES];
    
    [self.view endEditing:YES];
}

#pragma mark ######
#pragma Gesture Recognize methods
#pragma mark ######

- (void)DidRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    // Tap gestures on label
    
    UILabel *label = (UILabel*)[gesture view];
    if (label.tag ==1)
    {
        if (![selectField isEqualToString:@"Email"]) {
            selectField = @"Email";
            [UIView animateWithDuration:0.5f animations:^{
                if (label.tag == 1 && [ _passwordTextField.text isEqual:@""]){
                    
                    self.passwordLbl.frame = _passwordTextField.frame;
                    self.passwordLbl.font = [UIFont systemFontOfSize:17];
                    self.passwordLbl.textColor = [self colorWithHexString:@"51595c"];
                myImageView1.hidden = NO;
                myImageView.hidden = YES;
                   [myImageView1 setFrame:CGRectMake(0.0f, self.passwordTextField.frame.size.height - 5, self.passwordTextField.frame.size.width, 10)];
                    myImageView1.image = [UIImage imageNamed:@"textbox"];
                    [self.passwordTextField insertSubview:myImageView1 atIndex:0];
                    
                    CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
                    [self.passwordTextField.layer addSublayer:FirstNameLayer];
                    
                    [_passwordTextField resignFirstResponder];
                    [_emailAddressTextField becomeFirstResponder];
                    
                }
                else if(label.tag == 1 && ![ _passwordTextField.text isEqual:@""])
                {
                    [_passwordTextField resignFirstResponder];
                    [_emailAddressTextField becomeFirstResponder];
                }
                
                self.emailAddressLbl.frame = CGRectMake(self.emailAddressLbl.frame.origin.x,self.emailAddressLbl.frame.origin.y-self.emailAddressLbl.frame.size.height, self.emailAddressLbl.frame.size.width, self.emailAddressLbl.frame.size.height );
                self.emailAddressLbl.font = [UIFont systemFontOfSize:12];
                [self.emailAddressLbl setTextColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
                myImageView.hidden = NO;
                myImageView1.hidden = YES;
              
                [myImageView setFrame:CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 5, self.emailAddressTextField.frame.size.width, 10)];
                myImageView.image = [UIImage imageNamed:@"textbox"];
                [self.emailAddressTextField insertSubview:myImageView atIndex:0];
                
                CALayer *FirstNameLayer = [CALayer layer];
                FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
                FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
            }
                             completion:^(BOOL finished){
                             }];
        }
    }
    else if(label.tag == 2)
    {
        if (![selectField isEqualToString:@"password"]) {
            selectField = @"password";
            [UIView animateWithDuration:0.5f animations:^{
                if (label.tag == 2 && [ _emailAddressTextField.text isEqual:@""])
                {
                    
                    self.emailAddressLbl.frame = _emailAddressTextField.frame;
                    self.emailAddressLbl.font = [UIFont systemFontOfSize:17];
                    self.emailAddressLbl.textColor = [self colorWithHexString:@"51595c"];
                    
                    myImageView.hidden = NO;
                    myImageView1.hidden = YES;
                   [myImageView setFrame:CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 5, self.emailAddressTextField.frame.size.width, 10)];
                    myImageView.image = [UIImage imageNamed:@"textbox"];
                    [self.emailAddressTextField insertSubview:myImageView atIndex:0];
                    
                    CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
                    [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
                    
                    [_emailAddressTextField resignFirstResponder];
                    [_passwordTextField becomeFirstResponder];
                    
                }
                else if(label.tag == 2 && ![ _emailAddressTextField.text isEqual:@""])
                {
                    [_emailAddressTextField resignFirstResponder];
                    [_passwordTextField becomeFirstResponder];
                }
                
                self.passwordLbl.frame = CGRectMake(self.passwordLbl.frame.origin.x,self.passwordLbl.frame.origin.y-self.passwordLbl.frame.size.height, self.passwordLbl.frame.size.width, self.passwordLbl.frame.size.height );
                self.passwordLbl.font = [UIFont systemFontOfSize:12];
                
                [self.passwordLbl setTextColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
                
                myImageView1.hidden = NO;
                myImageView.hidden = YES;
                [myImageView1 setFrame:CGRectMake(0.0f, 5, self.passwordTextField.frame.size.width, 10)];
                myImageView1.image = [UIImage imageNamed:@"textbox"];
                [self.passwordTextField insertSubview:myImageView1 atIndex:0];
                
            }completion:^(BOOL finished){
            }];
        }
    }
}

#pragma mark ###########
#pragma mark - Text Fields Deletgate methods
#pragma mark ###########

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _emailAddressTextField)
    {
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + 200);
        
        
        [_scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
        
        if (![selectField isEqualToString:@"Email"]) {
            selectField = @"Email";
            [UIView animateWithDuration:0.5f animations:^{
                if (textField == _emailAddressTextField && [ _passwordTextField.text isEqual:@""]){
                    
                    myImageView1.hidden = YES;
                    myImageView.hidden = YES;

                CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
                    [self.passwordTextField.layer addSublayer:FirstNameLayer];
                    
                    [_passwordTextField resignFirstResponder];
                    [_emailAddressTextField becomeFirstResponder];
                    
                }
                else if(textField == _emailAddressTextField && ![ _passwordTextField.text isEqual:@""])
                {
                    myImageView.hidden = YES;
                    myImageView1.hidden = YES;
                    CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
                    [self.passwordTextField.layer addSublayer:FirstNameLayer];
                    [_passwordTextField resignFirstResponder];
                    [_emailAddressTextField becomeFirstResponder];
                }
                myImageView.hidden = NO;
                myImageView1.hidden = YES;
               [myImageView setFrame:CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 5, self.emailAddressTextField.frame.size.width, 5)];
                myImageView.image = [UIImage imageNamed:@"textbox"];
                [self.emailAddressTextField insertSubview:myImageView atIndex:0];
                
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
        [_scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
        
        if (![selectField isEqualToString:@"password"]) {
            selectField = @"password";
            [UIView animateWithDuration:0.5f animations:^{
                if (textField == _passwordTextField && [ _emailAddressTextField.text isEqual:@""])
                {
                   myImageView.hidden = YES;
                    myImageView1.hidden = YES;
                    CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
                    [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
                    
                    [_emailAddressTextField resignFirstResponder];
                    [_passwordTextField becomeFirstResponder];
                    
                }
                else if(textField == _passwordTextField && ![ _emailAddressTextField.text isEqual:@""])
                {
                   myImageView.hidden = YES;
                    myImageView1.hidden = YES;
                    CALayer *FirstNameLayer = [CALayer layer];
                    FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
                    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
                    [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
                    
                    [_emailAddressTextField resignFirstResponder];
                    [_passwordTextField becomeFirstResponder];
                }
                myImageView.hidden = YES;
                myImageView1.hidden = NO;
              
               [myImageView1 setFrame:CGRectMake(0.0f, self.passwordTextField.frame.size.height - 5, self.passwordTextField.frame.size.width, 10)];
                myImageView1.image = [UIImage imageNamed:@"textbox"];
                [self.passwordTextField insertSubview:myImageView1 atIndex:0];
                
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
    [_emailAddressTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    
    if(textField == _passwordTextField && [ _passwordTextField.text isEqual:@""])
    {
        myImageView.hidden = YES;
        myImageView1.hidden = YES;
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.passwordTextField.layer addSublayer:FirstNameLayer];
    }
    if(textField == _emailAddressTextField && [ _emailAddressTextField.text isEqual:@""])
    {
        
       myImageView.hidden = YES;
        myImageView1.hidden = YES;
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.emailAddressTextField.layer addSublayer:FirstNameLayer];
    }
 
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [_scrollView setContentOffset:CGPointMake(0, 20) animated:YES];
    float sizeOfContent = 0;
    NSInteger wd = _signUpBtn.frame.origin.y;
    NSInteger ht = _signUpBtn.frame.size.height+10;
    
    sizeOfContent = wd+ht;
    return YES;
}
#pragma mark ######
#pragma Scroll View method
#pragma mark ######

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 350; // Remove area covered by keyboard
    
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
  
}

-(void)cancelNumberPad
{
     [_scrollView setContentOffset:CGPointMake(0, 20) animated:YES];
//    [self scrollViewToCenterOfScreen:_scrollView];
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad
{
    [_scrollView setContentOffset:CGPointMake(0, 20) animated:YES];
//        [self scrollViewToCenterOfScreen:_scrollView];
    [self.view endEditing:YES];
}

@end
