
//
//  iPadSelectAmountViewController.m
//  MoneyTransfer
//
//  Created by apple on 06/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "iPadSelectAmountViewController.h"
#import "Controller.h"
#import "IpadConfirmTransferMoneyViewControllerViewController.h"
#import "AppDelegate.h"

@interface iPadSelectAmountViewController ()<UIGestureRecognizerDelegate>
{
    AppDelegate *appDel;
}
@end

@implementation iPadSelectAmountViewController
@synthesize beneficiaryUserInfo;

#pragma mark ######
#pragma mark View life cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    _sendMoneyUserCurrencySymbolLbl.frame = CGRectMake(655, _sendMoneyUserCurrencySymbolLbl.frame.origin.y, _sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.size.height);
    _benificiaryGetCurrencySymbolLbl.frame = CGRectMake(655, _benificiaryGetCurrencySymbolLbl.frame.origin.y, _benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.size.height);
    
    // Check user Session or not
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
    
    self.sendMoneyTextField.delegate = self;
    self.beneficiaryGetTextField.delegate = self;
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    userInfo = [userInfo valueForKeyPath:@"User"];
    
    _currencyIDLbl.text = [NSString stringWithFormat:@"%@", [userInfo valueForKeyPath:@"country_currency.currency_code"]];
    
    sendingCurrecyID = [NSString stringWithFormat:@"%@", [userInfo valueForKeyPath:@"country_currency.id"]];
    
    if (_amountLbl.text == nil){
        _amountLbl.text = [NSString stringWithFormat:@"%@",@"0.00"];
    }
    
    _sendMoneyUserCurrencySymbol1.text = [userInfo valueForKeyPath:@"country_currency.currency_symbol"];
    

    _benificiaryGetCurrencySymbolLbl.text = [beneficiaryUserInfo valueForKeyPath:@"country_currency.currency_symbol"];
    
    NSString *logoimageURl1=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[userInfo valueForKeyPath:@"country_currency.flag"]];
    
    NSString *imagePath1 = @"";
    NSString * flagName1 = @"";
    flagName1 = [logoimageURl1 lastPathComponent];
    imagePath1 = [appDel getImagePathbyflagName:flagName1];
    
    if(imagePath1.length > 0){
        NSData *img1 = nil;
        img1= [NSData dataWithContentsOfFile:imagePath1];
        _countryImage.image =[UIImage imageWithData:img1];
    }
    else
    {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image1 = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:logoimageURl1]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                _countryImage.image = [UIImage imageWithData:image1];
                
                [appDel saveflagsImageToFolder:_countryImage.image imageName:flagName1];
                
            });
        });
    }
   
    NSLog(@"Beneficiary User info.... %@",beneficiaryUserInfo);
    
    beneficiaryID = [beneficiaryUserInfo valueForKeyPath:@"id"];
    
    _sendMoneyUserCurrencySymbolLbl.textColor = [self colorWithHexString:@"51595c"];
    
    NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[beneficiaryUserInfo valueForKeyPath:@"country_currency.flag"]];
    
    dispatch_queue_t concurrentQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue1, ^{
        
        UIImage *image = nil;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoimageURl]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *img=[[UIImageView alloc]init];
            img.image=image;
            [self.beneficiaryUserImageView setImage:image];
        });
    });
    
    receivingCurrencyID = [beneficiaryUserInfo valueForKeyPath:@"country_currency.id"];
    
    NSString *str = [NSString stringWithFormat:@"%@",[[beneficiaryUserInfo valueForKeyPath:@"full_name"]uppercaseString]];
    
    _beneficiaryUserNameLbl.text = str;
    
    [_beneficiaryUserNameLbl sizeToFit];
    
    NSString *str1 = [NSString stringWithFormat:@"%@",[[beneficiaryUserInfo valueForKeyPath:@"settlement_channel.title"] uppercaseString]];
    
    _beneficiaryUserCountryLbl.text = str1;
    
    _beneficiaryUserCountryLbl.frame = CGRectMake(_beneficiaryUserNameLbl.frame.origin.x + _beneficiaryUserNameLbl.frame.size.width + 20, _beneficiaryUserCountryLbl.frame.origin.y, _beneficiaryUserCountryLbl.frame.size.width, _beneficiaryUserCountryLbl.frame.size.height);
    
    // Call get Commercial
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    [HUD hide:YES afterDelay:20.0];
    [ self getCommercials];
}

-(void) viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    oldDic = [[NSMutableDictionary alloc]init];
    // Add tool bar on number key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _sendMoneyTextField.inputAccessoryView = numberToolbar;
    _beneficiaryGetTextField.inputAccessoryView = numberToolbar;

    // Scroll view
    float sizeOfContent = 0;
    NSInteger wd = _continueBtn.frame.origin.y;
    NSInteger ht = _continueBtn.frame.size.height;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    
}

-(void)cancelNumberPad{
    [self.view endEditing:YES];
    
}

-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}

#pragma mark ######
#pragma mark Action method
#pragma mark ######

- (IBAction)M4BtnClicked:(id)sender;
{
    // Send Money
    [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backBtnClicked:(id)sender
{
    // Back Button
    [ self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ######
#pragma mark Continue methods
#pragma mark ######

- (IBAction)continueBtn:(id)sender {
    
    // Continue
    [self.view endEditing: YES];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSString *sending_currency = [self.sendMoneyTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *receiving_currency = [self.beneficiaryGetTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    if([sending_currency isEqualToString:@"0.00"] || sending_currency.length ==0)
    {
        // If Sending Currncy empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Set an amount to receive." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    
    else if([receiving_currency isEqualToString:@"0.00"]|| receiving_currency.length == 0)
    {
        // If receving Currency is empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Set an amount to receive." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    
    else if ([sending_currency intValue] > [receiving_currency intValue])
    {
        // If Sending Currency is greator than receving currency
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Set an amount to receive." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else
    {
        selectedUserAmount = [[NSMutableDictionary alloc]init];
        
        [selectedUserAmount setValue:_beneficiaryUserNameLbl.text forKey:@"sending_money_username"];
        [selectedUserAmount setValue:_beneficiaryUserCountryLbl.text forKey:@"sending_money_username_country"];
        [selectedUserAmount setValue:[beneficiaryUserInfo valueForKeyPath:@"country_currency.currency_symbol"] forKey:@"receiving_money_user_CurrencySymbol"];
        [selectedUserAmount setValue:@"$" forKey:@"sending_money_user_CurrencySymbol"];
        [selectedUserAmount setValue:sendingCurrecyID forKey:@"sending_country_currency"];
        [selectedUserAmount setValue:receivingCurrencyID forKey:@"receiving_country_currency"];
        [selectedUserAmount setValue:_sendMoneyTextField.text forKey:@"sending_amount"];
        [selectedUserAmount setValue:_beneficiaryGetTextField.text  forKey:@"receiving_amount"];
        [selectedUserAmount setValue:feeValue forKey:@"fee"];
        [selectedUserAmount setValue:exRateValue forKey:@"exchange_rate"];
        [selectedUserAmount setValue:beneficiaryID forKey:@"beneficiary_id"];
        [selectedUserAmount setValue:@"and" forKey:@"source"];
        
        NSLog(@"Selected user Amount...%@",selectedUserAmount);
        
        [self performSegueWithIdentifier:@"ConfirmTransferMoney" sender:self];
    }

}
#pragma mark ########
#pragma mark get Commercial data method
#pragma mark ######

-(void)getCommercials
{
    // get Commercial
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    direction = @"1";
    NSString *amountText= @"0.00";
    
    if (![_sendMoneyTextField.text isEqual: @""] ) {
        direction = @"1";
        amountText =  _sendMoneyTextField.text;
        NSArray *currencyArray = [amountText componentsSeparatedByString:@" "];
        if(currencyArray.count >1)
        {
            amountText = [currencyArray lastObject];
        }
    }
    else if (![_beneficiaryGetTextField.text  isEqual: @""]) {
        direction = @"0";
        amountText =  _beneficiaryGetTextField.text;
        NSArray *currencyArray = [amountText componentsSeparatedByString:@""];
        if(currencyArray.count >1)
        {
            amountText = [currencyArray lastObject];
        }
    }
    
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:sendingCurrecyID, @"sending_currency", receivingCurrencyID, @"receiving_currency",amountText, @"amount",direction, @"direction", nil] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    // Encrypt the user token using public data and iv data
    NSData *EncodedData = [FBEncryptorAES encryptData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64TokenString = [EncodedData base64EncodedStringWithOptions:0];
    
    NSMutableData *PostData =[[NSMutableData alloc] initWithData:[base64TokenString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@%@", BaseUrl, GetCommericials];
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
                {
//                    [HUD removeFromSuperview];
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
//                            [HUD removeFromSuperview];
                        }
                    }
                    else
                    {
//                        [HUD removeFromSuperview];
                        NSLog(@"Get Commercial Response...%@",responseDic );
                        
                        NSDictionary *myData = [responseDic valueForKeyPath:@"Payload.data"];
                        
                        _sendMoneyTextField.text = [NSString stringWithFormat:@"%.2f",[[ responseDic valueForKeyPath:@"PayLoad.data.sending_amount"] floatValue]];
                        _beneficiaryGetTextField.text =[NSString stringWithFormat:@"%.2f",[[responseDic valueForKeyPath:@"PayLoad.data.receiving_amount"]floatValue]];
                        exRateValue = [ NSString stringWithFormat:@"%@",[ responseDic valueForKeyPath:@"PayLoad.data.exchange_rate"]];
                        _benificiaryGetCurrencySymbolLbl.text = [beneficiaryUserInfo valueForKeyPath:@"country_currency.currency_symbol"];
                        
                        _exchangeRateLbl.text  = [ NSString stringWithFormat:@"Ex. Rate: %@1.00 = %@%@.00 Service fee %@%@.00",@"$",[beneficiaryUserInfo valueForKeyPath:@"country_currency.currency_symbol"],[ responseDic valueForKeyPath:@"PayLoad.data.exchange_rate"],@"$",[responseDic valueForKeyPath:@"PayLoad.data.fee"]];
                       
                        feeValue = [ NSString stringWithFormat:@"%@",[responseDic valueForKeyPath:@"PayLoad.data.fee"]];
                        _amountLbl.text = [NSString stringWithFormat:@"%.2f",[[ responseDic valueForKeyPath:@"PayLoad.data.sending_amount"] floatValue]];
                        amount = _amountLbl.text;
                        _amountLbl.text = [NSString stringWithFormat:@"%@ %@",@"$", _amountLbl.text];
                        NSMutableAttributedString* content2 =
                        [[NSMutableAttributedString alloc]
                         initWithString:_amountLbl.text
                         attributes:
                         @{
                           NSFontAttributeName:
                               [UIFont fontWithName:@"MyriadPro-Regular" size:110]
                           }];
                        [content2 setAttributes:
                         @{
                           NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Regular" size:40]
                           } range:NSMakeRange(0,1)];
                        [content2 addAttributes:
                         @{
                           NSKernAttributeName:@-4
                           } range:NSMakeRange(0,1)];
                        
                        _amountLbl.attributedText = content2;
                        
                        int textLength = (int)_sendMoneyTextField.text.length;
                        if(textLength>15)
                        {
                            textLength = 15;
                        }
                        _sendMoneyUserCurrencySymbolLbl.frame = CGRectMake(SCREEN_WIDTH-(textLength*20)-_sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.origin.y, _sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.size.height);
                        
                        int textLengthGet = (int)_beneficiaryGetTextField.text.length;
                        if(textLengthGet>15)
                        {
                            textLengthGet = 15;
                        }
                        _benificiaryGetCurrencySymbolLbl.frame = CGRectMake(SCREEN_WIDTH-(textLengthGet*20)-_benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.origin.y, _benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.size.height);                    }
                }
                else{
//                     [HUD removeFromSuperview];
                }
            }
        }
        
    }];
    
    [postDataTask resume];
    
}

#pragma mark ###########
#pragma mark Text Field delegate methods
#pragma mark ######

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.contentSize.height+100);
    
    _sendMoneyTextField.text = @"";
    _beneficiaryGetTextField.text = @"";
    
    _sendMoneyTextField.userInteractionEnabled = true;
    _sendMoneyUserCurrencySymbolLbl.frame = CGRectMake(655, _sendMoneyUserCurrencySymbolLbl.frame.origin.y, _sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.size.height);
    
    _beneficiaryGetTextField.userInteractionEnabled = true;
    _benificiaryGetCurrencySymbolLbl.frame = CGRectMake(655, _benificiaryGetCurrencySymbolLbl.frame.origin.y, _benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.size.height);
    
    UIView *tempVW = [[ UIView alloc] init];
    tempVW.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y + 200, textField.frame.size.width, textField.frame.size.height );
    [self scrollViewToCenterOfScreen:tempVW];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _sendMoneyTextField)
    {
        int textLength = (int)_sendMoneyTextField.text.length+1;
        if(textLength>24)
        {
            textLength = 24;
        }
        if([string isEqualToString:@""])
        {
            int dec = 40;
            
            if(_sendMoneyTextField.text.length < 24)
            {
                textLength--;
                dec = 20;
            }
            if(textLength<=1)
            {
                _sendMoneyUserCurrencySymbolLbl.frame = CGRectMake(655, _sendMoneyUserCurrencySymbolLbl.frame.origin.y, _sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.size.height);
            }
            else
            {
                _sendMoneyUserCurrencySymbolLbl.frame = CGRectMake(SCREEN_WIDTH-dec-(textLength*20)-_sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.origin.y, _sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.size.height);
            }
        }
        else
        {
            if(textLength<=0)
            {
                _sendMoneyUserCurrencySymbolLbl.frame = CGRectMake(655, _sendMoneyUserCurrencySymbolLbl.frame.origin.y, _sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.size.height);
            }
            else
            {
                _sendMoneyUserCurrencySymbolLbl.frame = CGRectMake(SCREEN_WIDTH-40-(textLength*20)-_sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.origin.y, _sendMoneyUserCurrencySymbolLbl.frame.size.width, _sendMoneyUserCurrencySymbolLbl.frame.size.height);
            }
        }
    }
    else
    {
        int textLength = (int)_beneficiaryGetTextField.text.length+1;
        if(textLength>24)
        {
            textLength = 24;
        }
        if([string isEqualToString:@""])
        {
            int dec = 40;
            if(_beneficiaryGetTextField.text.length < 24)
            {
                textLength--;
                dec = 20;
            }
            if(textLength<=1)
            {
                _benificiaryGetCurrencySymbolLbl.frame = CGRectMake(655, _benificiaryGetCurrencySymbolLbl.frame.origin.y, _benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.size.height);
            }
            else
            {
                _benificiaryGetCurrencySymbolLbl.frame = CGRectMake(SCREEN_WIDTH-dec-(textLength*20)-_benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.origin.y, _benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.size.height);
            }
        }
        else
        {
            if(textLength<=0)
            {
                _benificiaryGetCurrencySymbolLbl.frame = CGRectMake(655, _benificiaryGetCurrencySymbolLbl.frame.origin.y, _benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.size.height);
            }
            else
            {
                _benificiaryGetCurrencySymbolLbl.frame = CGRectMake(SCREEN_WIDTH-40-(textLength*20)-_benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.origin.y, _benificiaryGetCurrencySymbolLbl.frame.size.width, _benificiaryGetCurrencySymbolLbl.frame.size.height);
            }
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_sendMoneyTextField resignFirstResponder];
    [_beneficiaryGetTextField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField != _sendMoneyTextField || textField != _beneficiaryGetTextField)
    {
        if (![textField.text isEqualToString: @""] ) {
            
            //  Get Commercials
            [HUD removeFromSuperview];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = NSLocalizedString(@"Loading...", nil);
            [HUD show:YES];
            [HUD hide:YES afterDelay:18.0];
            [ self getCommercials];
        }
    }
    
    // Scroll view
    float sizeOfContent = 0;
    NSInteger wd = _continueBtn.frame.origin.y;
    NSInteger ht = _continueBtn.frame.size.height;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

#pragma mark ######
#pragma mark Scroll View Delegate
#pragma mark ######

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat availableHeight = applicationFrame.size.height - 350; // Remove area covered by keyboard
    CGFloat y = viewCenterY - availableHeight/4 ;
    if (y < 0) {
        y = 0;
    }
    [_scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}


#pragma mark ######
#pragma mark Segue Delegate
#pragma mark ######

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue to Confirm transfer money screen");
    if([[segue identifier] isEqualToString:@"ConfirmTransferMoney"]){
        IpadConfirmTransferMoneyViewControllerViewController *vc = [segue destinationViewController];
        vc.transferConfirmMoneyInfo = selectedUserAmount;
    }
}
#pragma mark ########
#pragma mark Color HexString methods
#pragma mark #######

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


#pragma mark ######
#pragma mark Alert  View Delegate
#pragma mark ######

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
    else if(alertView.tag ==1004)
    {
        if (buttonIndex==0)
        {
            _currencyIDLbl.text = [oldDic valueForKey:@"currencyID"];
            _sendMoneyUserCurrencySymbolLbl.text = [oldDic valueForKey:@"sendCurrSymbol1"];
            sendingCurrecyID =  [oldDic valueForKey:@"sendingCurrencyID"];
            NSString *logoimageURl=[oldDic valueForKey:@"oldlogoimageURl"];;
            NSLog(@"Logo imageurl is : %@",logoimageURl);
            NSString *imagePath = @"";
            NSString * flagName = @"";
            flagName = [logoimageURl lastPathComponent];
            imagePath = [appDel getImagePathbyflagName:flagName];
            
            oldImageURL = logoimageURl;
            if(imagePath.length > 0){
                NSData *img = nil;
                img= [NSData dataWithContentsOfFile:imagePath];
                _countryImage.image =[UIImage imageWithData:img];
            }
            else
            {
                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                //this will start the image loading in bg
                dispatch_async(concurrentQueue, ^{
                    NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:logoimageURl]];
                    
                    //this will set the image when loading is finished
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _countryImage.image = [UIImage imageWithData:image];
                        [appDel saveflagsImageToFolder:_countryImage.image imageName:flagName];
                        
                    });
                });
            }
        }
    }
}

@end
