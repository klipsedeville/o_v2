//
//  ResetPasswordViewController.m
//  MoneyTransfer
//
//  Created by 050 on 18/09/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "Controller.h"
#import "Constants.h"
#import "LoginViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############


- (void)viewDidLoad {
    [super viewDidLoad];
    myImageView = [[UIImageView alloc] init];
    myImageView1 = [[UIImageView alloc] init];
    myImageView2 = [[UIImageView alloc] init];
    myImageView.hidden = YES;
    myImageView1.hidden = YES;
    myImageView2.hidden = YES;

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    // Check user Session Expired  or not
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    _PasswordTextfield.secureTextEntry = YES;
    _RepeatPasswordTextfield.secureTextEntry = YES;
    
    // Bottom border
    myImageView2.hidden = YES;
    myImageView1.hidden = YES;
    myImageView.hidden = YES;
   
    CALayer *FirstNameLayer = [CALayer layer];
    FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
    
    CALayer *FirstNameLayer1 = [CALayer layer];
    FirstNameLayer1.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
    FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
    [self.PasswordTextfield.layer addSublayer:FirstNameLayer1];
    
    CALayer *FirstNameLayer2 = [CALayer layer];
    FirstNameLayer2.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
    FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
    [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer2];
    
    _resetCodeHeading.hidden = YES;
    _PasswordHeading.hidden = YES;
    _repeatPasswordHeading.hidden = YES;
    
    self.resetCodeLabel.userInteractionEnabled = YES;
    self.PasswordLabel.userInteractionEnabled = YES;
    self.repeatPasswordLabel.userInteractionEnabled = YES;
    
    // guesture
    UITapGestureRecognizer *tapGestureUserOldPwd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGestureUserNewPwd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGestureUserConfirmPwd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    [self.resetCodeLabel addGestureRecognizer:tapGestureUserOldPwd];
    [self.PasswordLabel addGestureRecognizer:tapGestureUserNewPwd];
    [self.repeatPasswordLabel addGestureRecognizer:tapGestureUserConfirmPwd];
    
    _resetCodeLabel.tag = 1;
    _PasswordLabel.tag = 2;
    _repeatPasswordLabel.tag = 3;
    
}

-(void) viewDidAppear:(BOOL)animated{
    // Add tool bar on number key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _ResetCodeTextfield.inputAccessoryView = numberToolbar;
    _PasswordTextfield.inputAccessoryView = numberToolbar;
    _RepeatPasswordTextfield.inputAccessoryView = numberToolbar;
}

#pragma  mark ############
#pragma Action Clik Method
#pragma  mark ############

- (IBAction)backBtnClicked:(id)sender {
    
    // back button
    [ self.navigationController popViewControllerAnimated:YES];
    
}

#pragma  mark ############
#pragma  mark Call Reset Password web method
#pragma  mark ############

-(void)GetResetPassword
{
    // Reset password
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userDataDict = [ userDataDict valueForKey:@"User"] ;
    
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
 
    NSString *EncryptPasswordKey = [[FBEncryptorAES encryptData:[@"password" dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
    
    NSString *EncryptPasswordValue = [[FBEncryptorAES encryptData:[self.PasswordTextfield.text  dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
    
    NSString *EncryptResetCodeKey = [[FBEncryptorAES encryptData:[@"reset_code" dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
    NSString *EncryptResetCodeValue = [[FBEncryptorAES encryptData:[self.ResetCodeTextfield.text dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
    
    NSDictionary *headers = @{@"token": @"",

                               @"cache-control": @"no-cache",
                               @"postman-token": @"e052d2a7-928b-0406-a9a6-d859b881496c",
                               @"content-type": @"application/x-www-form-urlencoded" };
    
    
    
    NSMutableData *postData1 = [[NSMutableData alloc] initWithData:[[ NSString stringWithFormat:@"%@=%@",EncryptPasswordKey,EncryptPasswordValue] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData1 appendData:[[NSString stringWithFormat:@"&%@=%@",EncryptResetCodeKey,EncryptResetCodeValue] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableURLRequest *request = [  NSMutableURLRequest requestWithURL:[NSURL
                                                                          
                                                                          URLWithString: [NSString stringWithFormat:@"%@%@" ,BaseUrl, ResetPassword]]
                                    
                                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                         timeoutInterval:10.0];
    
    [request setHTTPMethod: @"POST"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPBody:postData1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData* data, NSURLResponse* response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        NSLog(@"%@", httpResponse);
                                                        {
                                                            NSString* resultString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                            NSLog(@"result string %@", resultString);
                                                            
                                                            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:resultString options:0];
                                                            
                                                            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
                                                            if (data1)
                                                            {NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data1  options:NSJSONReadingMutableContainers error:&error];
                                                                
                                                                dispatch_queue_t concurrentQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                                                dispatch_async(concurrentQueue1, ^{
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        
                                                                        NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"] integerValue];
                                                                        if (status == 0)
                                                                        {
                                                                            NSArray *errorArray =[ responseDic valueForKeyPath:@"PayLoad.error"];
                                                                            
                                                                            NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
                                                                            
                                                                            if(!errorString || [errorString isEqualToString:@"(null)"])
                                                                            {
                                                                                errorString = @"Connection failed. Please make sure you have an active internet connection.";
                                                                                
                                                                                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Error!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                                                alertview.tag = 1003;
                                                                                
                                                                                [alertview show];
                                                                                [HUD removeFromSuperview];                                   }
                                                                            else
                                                                            {
                                                                                
                                                                                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                                                
                                                                                [alertview show];
                                                                                [HUD removeFromSuperview];
                                                                            }
                                                                        }
                                                                        else
                                                                        {
                                                                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Your password has been changed" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                                                                            
                                                                            alertview.tag = 100;                         [alertview show];
                                                                            [HUD removeFromSuperview];
                                                                            
                                                                        }
                                                                    });
                                                                });
                                                            }
                                                            else{                    [HUD removeFromSuperview];
                                                            
                                                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Connection failed. Please make sure you have an active internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                                            
                                                            [alertview show];
                                         
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                    
                                                }];
    [dataTask resume];
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
}
#pragma  mark ############
#pragma mark Text Field delegate methods
#pragma  mark ############

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _ResetCodeTextfield)
    {
        _resetCodeHeading.textColor= [self colorWithHexString:@"158db6"];
        
        if ([_RepeatPasswordTextfield.text length] == 0) {
            _repeatPasswordLabel.hidden = NO;
            _repeatPasswordHeading.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer2];
            
            [_RepeatPasswordTextfield resignFirstResponder];
        }
        if ([ _PasswordTextfield.text isEqual:@""]) {
            _PasswordLabel.hidden = NO;
            _PasswordHeading.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.PasswordTextfield.layer addSublayer:FirstNameLayer1];
            
            [_PasswordTextfield resignFirstResponder];
        }
    }
    
    if (textField ==_PasswordTextfield )
    {
        _PasswordHeading.textColor= [self colorWithHexString:@"158db6"];
        
        if ([ _ResetCodeTextfield.text isEqual:@""]) {
            _resetCodeLabel.hidden = NO;
            _resetCodeHeading.hidden= YES;
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
            
            [_ResetCodeTextfield resignFirstResponder];
            
        }
        
        if ([ _RepeatPasswordTextfield.text isEqual:@""]) {
            _repeatPasswordLabel.hidden = NO;
            _repeatPasswordHeading.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer2];
            
            [_RepeatPasswordTextfield resignFirstResponder];
        }
    }
    
    if (textField == _RepeatPasswordTextfield)
    {
        _repeatPasswordHeading.textColor= [self colorWithHexString:@"158db6"];
        
        if ([ _ResetCodeTextfield.text isEqual:@""]) {
            _resetCodeLabel.hidden = NO;
            _resetCodeHeading.hidden= YES;
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
            
            [_ResetCodeTextfield resignFirstResponder];
            
        }
        
        if ([ _PasswordTextfield.text isEqual:@""]) {
            _PasswordLabel.hidden = NO;
            _PasswordHeading.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.PasswordTextfield.layer addSublayer:FirstNameLayer1];
            
            [_PasswordTextfield resignFirstResponder];
            
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
    
    NSString *old_password = [self.ResetCodeTextfield.text stringByTrimmingCharactersInSet:whitespace];
    NSString *new_password = [self.PasswordTextfield.text stringByTrimmingCharactersInSet:whitespace];
    NSString *confirm_password = [self.RepeatPasswordTextfield.text stringByTrimmingCharactersInSet:whitespace];
    
    if (textField == _ResetCodeTextfield)
    {
        _resetCodeHeading.textColor= [self colorWithHexString:@"158db6"];
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
        
        if ([new_password length] != 0 ) {
            _PasswordHeading.textColor = [UIColor whiteColor];
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.PasswordTextfield.layer addSublayer:FirstNameLayer];
        }
        if ([confirm_password length] != 0 ) {
            _repeatPasswordHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer];
        }
    }
    
    if (textField == _PasswordTextfield)
    {
        _PasswordHeading.textColor= [self colorWithHexString:@"158db6"];
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.PasswordTextfield.layer addSublayer:FirstNameLayer];
        
        
        if ([old_password length] != 0 ) {
            _resetCodeHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
        }
        
        if ([confirm_password length] != 0 ) {
            _repeatPasswordHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer];
        }
    }
    
    if (textField == _RepeatPasswordTextfield)
    {
        _repeatPasswordHeading.textColor= [self colorWithHexString:@"158db6"];
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer];
        
        
        if ([old_password length] != 0 ) {
            _resetCodeHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
        }
        if ([new_password length] != 0 ) {
            _PasswordHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.PasswordTextfield.layer addSublayer:FirstNameLayer];
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
        _resetCodeLabel.hidden = YES;
        _resetCodeHeading.hidden= NO;
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
        
        [_ResetCodeTextfield becomeFirstResponder];
        
        
        if ([ _PasswordTextfield.text isEqual:@""]) {
            _PasswordLabel.hidden = NO;
            _PasswordHeading.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.PasswordTextfield.layer addSublayer:FirstNameLayer1];
            
            [_PasswordTextfield resignFirstResponder];
            
        }
        else{
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.PasswordTextfield.layer addSublayer:FirstNameLayer1];
            
            [_PasswordTextfield resignFirstResponder];
            _PasswordHeading.textColor = [UIColor whiteColor];
            
        }
        
        if ([ _RepeatPasswordTextfield.text isEqual:@""]) {
            _repeatPasswordLabel.hidden = NO;
            _repeatPasswordHeading.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer2];
            
            [_RepeatPasswordTextfield resignFirstResponder];
            
        }
        else{
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer2];
            
            [_RepeatPasswordTextfield resignFirstResponder];
            _repeatPasswordHeading.textColor = [UIColor whiteColor];
        }
    }
    
    if ( label.tag == 2)
    {
        _PasswordLabel.hidden = YES;
        _PasswordHeading.hidden= NO;
        
        
        [_PasswordTextfield becomeFirstResponder];
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.PasswordTextfield.layer addSublayer:FirstNameLayer];
        
        if ([ _ResetCodeTextfield.text isEqual:@""]) {
            _resetCodeLabel.hidden = NO;
            _resetCodeHeading.hidden= YES;
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
            
            [_ResetCodeTextfield resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
            
            [_ResetCodeTextfield resignFirstResponder];
            _resetCodeHeading.textColor = [UIColor whiteColor];
            
        }
        
        if ([ _RepeatPasswordTextfield.text isEqual:@""]) {
            _repeatPasswordLabel.hidden = NO;
            _repeatPasswordHeading.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer2];
            
            [_RepeatPasswordTextfield resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer2];
            
            [_RepeatPasswordTextfield resignFirstResponder];
            _repeatPasswordHeading.textColor = [UIColor whiteColor];
        }
    }
    
    if (label.tag == 3)
    {
        _repeatPasswordLabel.hidden = YES;
        _repeatPasswordHeading.hidden = NO;
        
        [_RepeatPasswordTextfield becomeFirstResponder];
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.RepeatPasswordTextfield.frame.size.height - 1, self.RepeatPasswordTextfield.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.RepeatPasswordTextfield.layer addSublayer:FirstNameLayer];
        
        if ([ _ResetCodeTextfield.text isEqual:@""]) {
            _resetCodeLabel.hidden = NO;
            _resetCodeHeading.hidden= YES;
            
            CALayer *FirstNameLayer = [CALayer layer];
            FirstNameLayer.frame = CGRectMake(0.0f, self.ResetCodeTextfield.frame.size.height - 1, self.ResetCodeTextfield.frame.size.width, 1.0f);
            FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.ResetCodeTextfield.layer addSublayer:FirstNameLayer];
            
            [_ResetCodeTextfield resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.PasswordTextfield.layer addSublayer:FirstNameLayer1];
            
            [_PasswordTextfield resignFirstResponder];
            _PasswordHeading.textColor = [UIColor whiteColor];
        }
        
        if ([ _PasswordTextfield.text isEqual:@""]) {
            _PasswordLabel.hidden = NO;
            _PasswordHeading.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.PasswordTextfield.layer addSublayer:FirstNameLayer1];
            
            [_PasswordTextfield resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.PasswordTextfield.frame.size.height - 1, self.PasswordTextfield.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.PasswordTextfield.layer addSublayer:FirstNameLayer1];
            
            [_PasswordTextfield resignFirstResponder];
            _PasswordHeading.textColor = [UIColor whiteColor];
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

- (IBAction)ActionResetPassword:(id)sender {
    
    // Save button
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    
    NSString *old_password = [self.ResetCodeTextfield.text stringByTrimmingCharactersInSet:whitespace];
    NSString *new_password = [self.PasswordTextfield.text stringByTrimmingCharactersInSet:whitespace];
    NSString *confirm_password = [self.RepeatPasswordTextfield.text stringByTrimmingCharactersInSet:whitespace];
    
    if([old_password length] == 0)
    {
        // If old password empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter the Reset Code" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if ([new_password length] == 0)
    {
        // if new password empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter Password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
        // Call Reset password
        [HUD removeFromSuperview];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = NSLocalizedString(@"Loading...", nil);
        [HUD show:YES];
        [self GetResetPassword ];
        
    }
}

-(void)cancelNumberPad{
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}

@end
