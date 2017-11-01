//
//  ChangePasswordViewController.m
//  MoneyTransfer
//
//  Created by apple on 26/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//


#import "ChangePasswordViewController.h"
#import "Controller.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "CustomPopUp.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "AsyncImageView.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############


- (void)viewDidLoad {
    [super viewDidLoad];
    // Check user Session Expired  or not
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShade) name:@"removeShade" object:nil];

    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    //
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
    
    self.userOldPwdTextField.delegate = self;
    self.userNewPwdTextField.delegate = self;
    self.userConfirmPwdTextField.delegate = self;
    
    _userOldPwdTextField.secureTextEntry = YES;
    _userNewPwdTextField.secureTextEntry = YES;
    _userConfirmPwdTextField.secureTextEntry = YES;
    
    // Bottom border
    CALayer *FirstNameLayer = [CALayer layer];
    FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
    
    CALayer *FirstNameLayer1 = [CALayer layer];
    FirstNameLayer1.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
    FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
    [self.userNewPwdTextField.layer addSublayer:FirstNameLayer1];
    
    CALayer *FirstNameLayer2 = [CALayer layer];
    FirstNameLayer2.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
    FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
    [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer2];
    
    _userOldPwdHeadingLbl.hidden = YES;
    _userNewPwdHeadingLbl.hidden = YES;
    _userConfirmPwdHeadingLbl.hidden = YES;
    
    self.userOldPwdLbl.userInteractionEnabled = YES;
    self.userNewPwdLbl.userInteractionEnabled = YES;
    self.userConfirmPwdLbl.userInteractionEnabled = YES;
    
    // guesture
    UITapGestureRecognizer *tapGestureUserOldPwd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGestureUserNewPwd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGestureUserConfirmPwd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    [self.userOldPwdLbl addGestureRecognizer:tapGestureUserOldPwd];
    [self.userNewPwdLbl addGestureRecognizer:tapGestureUserNewPwd];
    [self.userConfirmPwdLbl addGestureRecognizer:tapGestureUserConfirmPwd];
    
    _userOldPwdLbl.tag = 1;
    _userNewPwdLbl.tag = 2;
    _userConfirmPwdLbl.tag = 3;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    _userOldPwdLbl.hidden = YES;
    _userOldPwdTextField.hidden = YES;
    _userOldPwdHeadingLbl.hidden = YES;
    
    // Add tool bar on number key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _userNewPwdTextField.inputAccessoryView = numberToolbar;
    _userConfirmPwdTextField.inputAccessoryView = numberToolbar;
}

#pragma  mark ############
#pragma Action Clik Method
#pragma  mark ############

- (IBAction)SaveBtnClicked:(id)sender {
    
    // Save button
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    
    NSString *old_password = [self.userOldPwdTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *new_password = [self.userNewPwdTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *confirm_password = [self.userConfirmPwdTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    if ([new_password length] == 0)
    {
        // if new password empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter New Password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if ([confirm_password length] == 0)
    {
        // if confirm password empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter Confirm password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if (![new_password isEqualToString:confirm_password])
    {
        // if new password Does not match Confirm password
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Password & Confirm Password do not matched" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
        
    }
    else
    {
        NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
        userDataDict = [userDataDict valueForKeyPath:@"User"];
        CustomPopUp *popUp = [[CustomPopUp alloc]initWithNibName:@"CustomPopUp_iPhone"  bundle:nil];
        popUp.popUpMsg = @"You appear to be offline. Please check your net connection and retry.";
        popUp.callFrom = [userDataDict valueForKeyPath:@"phone_number"];
        popUp.delegate = self;
        
        [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
        
    }
    
}
- (IBAction)backBtnClicked:(id)sender {
    
    // back button
    [ self.navigationController popViewControllerAnimated:YES];
    
}

#pragma  mark ############
#pragma  mark Call Chnage Password web method
#pragma  mark ############

-(void)GetChangePassword
{
    // Change password

    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userDataDict = [ userDataDict valueForKey:@"User"] ;
    
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:_userNewPwdTextField.text , @"password", _userConfirmPwdTextField.text, @"cpassword", nil] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
                            // Encrypt the user token using public data and iv data
                            NSData *EncodedData = [FBEncryptorAES encryptData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                                          key:decodedKeyData
                                                                           iv:decodedIVData];
                            
                            NSString *base64TokenString = [EncodedData base64EncodedStringWithOptions:0];
                            
                            NSMutableData *PostData =[[NSMutableData alloc] initWithData:[base64TokenString dataUsingEncoding:NSUTF8StringEncoding]];
                            
                            NSString *ApiUrl = [ NSString stringWithFormat:@"%@/%@", BaseUrl, ChangePassword];
                            NSURL *url = [NSURL URLWithString:ApiUrl];
                            
                            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
                            
                            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                            request.HTTPMethod = @"POST";
                            
                            [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
                            [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
                            [request addValue: userTokenString forHTTPHeaderField:@"token"];
                            
                            [request setHTTPBody:PostData];
                            
                            NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //if communication was successful
        
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200)
            {
                NSString* resultString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"result string %@", resultString);
                
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:resultString options:0];
                
                NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
                if (data1)
                {[HUD removeFromSuperview];
                    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data1  options:NSJSONReadingMutableContainers error:&error];
                    
                    NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"] integerValue];
                    
                    if (status == 0)
                    {
                        NSArray *errorArray =[ responseDic valueForKeyPath:@"PayLoad.error"];
                        NSLog(@"error ..%@", errorArray);
                        
                        NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
                        
                        if(!errorString || [errorString isEqualToString:@"(null)"])
                        {
                            errorString = @"Your sesssion has been expired.";
                            
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
                        [HUD removeFromSuperview];
                        NSLog(@"Change Password...%@",responseDic );
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Your password has been changed" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                            alertview.tag = 100;                        [alertview show];
                            [HUD removeFromSuperview];

                        });
                    }
                }
                
            }
        }
        
    }];
                            
    [postDataTask resume];
                            
}

#pragma  mark ############
#pragma  mark Alert Method
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
    
    if(alertView.tag ==100)
    {
        if (buttonIndex==0)
        {
            [self performSegueWithIdentifier:@"SendMoney" sender:self];
        }
    }
}
#pragma  mark ############
#pragma mark Text Field delegate methods
#pragma  mark ############

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _userOldPwdTextField)
    {
        _userOldPwdHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        
        if ([_userConfirmPwdTextField.text length] == 0) {
            _userConfirmPwdLbl.hidden = NO;
            _userConfirmPwdHeadingLbl.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer2];
            
            [_userConfirmPwdTextField resignFirstResponder];
        }
        if ([ _userNewPwdTextField.text isEqual:@""]) {
            _userNewPwdLbl.hidden = NO;
            _userNewPwdHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.userNewPwdTextField.layer addSublayer:FirstNameLayer1];
            
            [_userNewPwdTextField resignFirstResponder];
        }
    }
    
    if (textField ==_userNewPwdTextField )
    {
        _userNewPwdHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        
        if ([ _userOldPwdTextField.text isEqual:@""]) {
            //            _userOldPwdLbl.hidden = NO;
            _userOldPwdHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
            
            [_userOldPwdTextField resignFirstResponder];
            
        }
        
        if ([ _userConfirmPwdTextField.text isEqual:@""]) {
            _userConfirmPwdLbl.hidden = NO;
            _userConfirmPwdHeadingLbl.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer2];
            
            [_userConfirmPwdTextField resignFirstResponder];
        }
    }
    
    if (textField == _userConfirmPwdTextField)
    {
        _userConfirmPwdHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        
        if ([ _userOldPwdTextField.text isEqual:@""]) {
            _userOldPwdHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
            
            [_userOldPwdTextField resignFirstResponder];
            
        }
        
        if ([ _userNewPwdTextField.text isEqual:@""]) {
            _userNewPwdLbl.hidden = NO;
            _userNewPwdHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.userNewPwdTextField.layer addSublayer:FirstNameLayer1];
            
            [_userNewPwdTextField resignFirstResponder];
            
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    if ([string isEqualToString:@"#"]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    
    NSString *old_password = [self.userOldPwdTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *new_password = [self.userNewPwdTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *confirm_password = [self.userConfirmPwdTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    if (textField == _userOldPwdTextField)
    {
        _userOldPwdHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
        
        if ([new_password length] != 0 ) {
            _userNewPwdHeadingLbl.textColor = [UIColor whiteColor];
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userNewPwdTextField.layer addSublayer:FirstNameLayer];
        }
        if ([confirm_password length] != 0 ) {
            _userConfirmPwdHeadingLbl.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer];
        }
    }
    
    if (textField == _userNewPwdTextField)
    {
        _userNewPwdHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.userNewPwdTextField.layer addSublayer:FirstNameLayer];
        
        
        if ([old_password length] != 0 ) {
            _userOldPwdHeadingLbl.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
        }
        
        if ([confirm_password length] != 0 ) {
            _userConfirmPwdHeadingLbl.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer];
        }
    }
    
    if (textField == _userConfirmPwdTextField)
    {
        _userConfirmPwdHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer];
        
        
        if ([old_password length] != 0 ) {
            _userOldPwdHeadingLbl.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
        }
        if ([new_password length] != 0 ) {
            _userNewPwdHeadingLbl.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userNewPwdTextField.layer addSublayer:FirstNameLayer];
        }
        
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}

#pragma  mark ############
#pragma Guesture Recogniser Method
#pragma  mark ############

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)DidRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    UILabel *label = (UILabel*)[gesture view];
    if ( label.tag == 1)
    {
        _userOldPwdLbl.hidden = YES;
        _userOldPwdHeadingLbl.hidden= NO;
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
        
        [_userOldPwdTextField becomeFirstResponder];
        
        
        if ([ _userNewPwdTextField.text isEqual:@""]) {
            _userNewPwdLbl.hidden = NO;
            _userNewPwdHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.userNewPwdTextField.layer addSublayer:FirstNameLayer1];
            
            [_userNewPwdTextField resignFirstResponder];
            
        }
        else{
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.userNewPwdTextField.layer addSublayer:FirstNameLayer1];
            
            [_userNewPwdTextField resignFirstResponder];
            _userNewPwdHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        
        if ([ _userConfirmPwdTextField.text isEqual:@""]) {
            _userConfirmPwdLbl.hidden = NO;
            _userConfirmPwdHeadingLbl.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer2];
            
            [_userConfirmPwdTextField resignFirstResponder];
            
        }
        else{
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer2];
            
            [_userConfirmPwdTextField resignFirstResponder];
            _userConfirmPwdHeadingLbl.textColor = [UIColor whiteColor];
        }
    }
    
    if ( label.tag == 2)
    {
        _userNewPwdLbl.hidden = YES;
        _userNewPwdHeadingLbl.hidden= NO;
        
        
        [_userNewPwdTextField becomeFirstResponder];
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.userNewPwdTextField.layer addSublayer:FirstNameLayer];
        
        if ([ _userOldPwdTextField.text isEqual:@""]) {
            _userOldPwdHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
            
            [_userOldPwdTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
            
            [_userOldPwdTextField resignFirstResponder];
            _userOldPwdHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        
        if ([ _userConfirmPwdTextField.text isEqual:@""]) {
            _userConfirmPwdLbl.hidden = NO;
            _userConfirmPwdHeadingLbl.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer2];
            
            [_userConfirmPwdTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer2];
            
            [_userConfirmPwdTextField resignFirstResponder];
            _userConfirmPwdHeadingLbl.textColor = [UIColor whiteColor];
        }
    }
    
    if (label.tag == 3)
    {
        _userConfirmPwdLbl.hidden = YES;
        _userConfirmPwdHeadingLbl.hidden = NO;
        
        [_userConfirmPwdTextField becomeFirstResponder];
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.userConfirmPwdTextField.frame.size.height - 1, self.userConfirmPwdTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.userConfirmPwdTextField.layer addSublayer:FirstNameLayer];
        
        if ([ _userOldPwdTextField.text isEqual:@""]) {
            //            _userOldPwdLbl.hidden = NO;
            _userOldPwdHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.userOldPwdTextField.frame.size.height - 1, self.userOldPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.userOldPwdTextField.layer addSublayer:FirstNameLayer];
            
            [_userOldPwdTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.userNewPwdTextField.layer addSublayer:FirstNameLayer1];
            
            [_userNewPwdTextField resignFirstResponder];
            _userNewPwdHeadingLbl.textColor = [UIColor whiteColor];
        }
        
        if ([ _userNewPwdTextField.text isEqual:@""]) {
            _userNewPwdLbl.hidden = NO;
            _userNewPwdHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.userNewPwdTextField.layer addSublayer:FirstNameLayer1];
            
            [_userNewPwdTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.userNewPwdTextField.frame.size.height - 1, self.userNewPwdTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.userNewPwdTextField.layer addSublayer:FirstNameLayer1];
            
            [_userNewPwdTextField resignFirstResponder];
            _userNewPwdHeadingLbl.textColor = [UIColor whiteColor];
        }
    }
}
#pragma mark ########
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

-(void) removeShade {
    [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"callStatusValue"]  isEqual: @"Yes"])
    {
        
               // Call change password
                [HUD removeFromSuperview];
                HUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:HUD];
                HUD.labelText = NSLocalizedString(@"Loading...", nil);
                [HUD show:YES];
                [self GetChangePassword ];
        
        
    }
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"callStatusValue"];
}

@end
