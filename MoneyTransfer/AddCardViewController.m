//
//  AddCardViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 16/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "AddCardViewController.h"
#import "SendMoneyViewController.h"
#import "Controller.h"
#import "Constants.h"
#import "LoginViewController.h"
#import <Foundation/Foundation.h>
#import "BackPopUp.h"

@interface AddCardViewController ()

@end

@implementation AddCardViewController
@synthesize lastSourceView;

#pragma mark ######
#pragma mark View life cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad]; self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    self.cardNumberTextField.delegate = self;
    self.monthTextField.delegate = self;
    self.yearTextField.delegate = self;
    self.cvvTextField.delegate = self;
    self.cardNicknameTextField.delegate = self;
    
    _cardNumberHeadingLbl.hidden = YES;
    _monthHeadingLbl.hidden = YES;
    _yearHeadingLbl.hidden = YES;
    _cvvHeadingLbl.hidden = YES;
    _cardNicknameHeadingLbl.hidden = YES;
    
    CALayer *FirstNameLayer = [CALayer layer];
    FirstNameLayer.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
    FirstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.cardNumberTextField.layer addSublayer:FirstNameLayer];
    
    CALayer *FirstNameLayer1 = [CALayer layer];
    FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
    FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
    [self.monthTextField.layer addSublayer:FirstNameLayer1];
    
    CALayer *FirstNameLayer2 = [CALayer layer];
    FirstNameLayer2.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
    FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
    [self.yearTextField.layer addSublayer:FirstNameLayer2];
    
    CALayer *FirstNameLayer3 = [CALayer layer];
    FirstNameLayer3.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
    FirstNameLayer3.backgroundColor = [UIColor blackColor].CGColor;
    [self.cvvTextField.layer addSublayer:FirstNameLayer3];
    
    CALayer *FirstNameLayer4 = [CALayer layer];
    FirstNameLayer4.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
    FirstNameLayer4.backgroundColor = [UIColor blackColor].CGColor;
    [self.cardNicknameTextField.layer addSublayer:FirstNameLayer4];
    
    UITapGestureRecognizer *tapGestureCardNumber = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureMonth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureYear = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureCvv = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureCardNickname = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    self.cardNumberLbl.userInteractionEnabled = YES;
    self.monthLbl.userInteractionEnabled = YES;
    self.yearLbl.userInteractionEnabled = YES;
    self.cvvLbl.userInteractionEnabled = YES;
    self.cardNicknameLbl.userInteractionEnabled = YES;
    
    [self.cardNumberLbl addGestureRecognizer:tapGestureCardNumber];
    [self.monthLbl addGestureRecognizer:tapGestureMonth];
    [self.yearLbl addGestureRecognizer:tapGestureYear];
    [self.cvvLbl addGestureRecognizer:tapGestureCvv];
    [self.cardNicknameLbl addGestureRecognizer:tapGestureCardNickname];
    
    _cardNumberLbl.tag = 1;
    _monthLbl.tag = 2;
    _yearLbl.tag = 3;
    _cvvLbl.tag = 4;
    _cardNicknameLbl.tag = 5;
    
    // Add tool bar on Number Key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    
    _cardNumberTextField.inputAccessoryView = numberToolbar;
    _monthTextField.inputAccessoryView = numberToolbar;
    _yearTextField.inputAccessoryView = numberToolbar;
    _cvvTextField.inputAccessoryView = numberToolbar;
    _cardNicknameTextField.inputAccessoryView = numberToolbar;
    
}
-(void)cancelNumberPad{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    [super viewWillAppear:animated];
    [CardIOUtilities preload];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
}

#pragma mark ########
#pragma mark Color HexString methods
#pragma mark ######

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

#pragma mark #####
#pragma mark Click Action methods
#pragma mark ######

- (IBAction)backBtnClicked:(id)sender;
{
    if ([lastSourceView isEqualToString:@"SingUp"]) {
        [self performSegueWithIdentifier:@"ShowMoney" sender:self];
        
    }
    else
    {
        [ self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)cameraBtn:(id)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (IBAction)saveCardBtn:(id)sender
{
    [self.cardNumberTextField resignFirstResponder];
    [self.monthTextField resignFirstResponder];
    [self.yearTextField resignFirstResponder];
    [self.cvvTextField resignFirstResponder];
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSString *card_number = [self.cardNumberTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *month = [self.monthTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *year = [self.yearTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *cvv = [self.cvvTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *cardNickname = [self.cardNicknameTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    if([card_number length] == 0)
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter Card Number" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([card_number length] != 16)
    {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter 16 Digit Card Number ." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if ([month length] == 0)
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter Month." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([month length] != 0)
    {
        int monthValue = [month intValue];
        if (monthValue > 12) {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Invalid Month" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else if ([year length] == 0)
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter Year." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertview show];
        }
        else if ([year length] != 4)
        {
            UIAlertView *alertview = [[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter 4 Digit year ." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else if ([cvv length] == 0)
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter CVV." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertview show];
        }
        else if ([cardNickname length] == 0)
        {
            // If cardNickname empty
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter card Nickname." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertview show];
            
        }
        
        else
        {
            [HUD removeFromSuperview];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = NSLocalizedString(@"We are verifying your card...", nil);
            [HUD show:YES];
            [ self GetStripeToken];
        }
    }
}

#pragma mark ######
#pragma mark Segue Delegate
#pragma mark ######

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue to Send Money screen");
    if([[segue identifier] isEqualToString:@"ShowSendMoney"]){
        
    }
}

#pragma mark ######
#pragma mark Get Stripe Toekn methods
#pragma mark ######

-(void) GetStripeToken
{
    STPCardParams *card = [[STPCardParams alloc] init];
    card.number = self.cardNumberTextField.text;
    card.cvc = self.cvvTextField.text;
    card.expYear= [self.yearTextField.text integerValue];
    card.expMonth = [self.monthTextField.text integerValue];
    
    if( [STPCardValidator brandForNumber:self.cardNumberTextField.text] == STPCardBrandVisa)
    {
        cardType = @"VISA";
    }
    else if( [STPCardValidator brandForNumber:self.cardNumberTextField.text] == STPCardBrandAmex)
    {
        cardType = @"Amex";
    }
    else if( [STPCardValidator brandForNumber:self.cardNumberTextField.text] == STPCardBrandMasterCard)
    {
        cardType = @"MasterCard";
    }
    else if( [STPCardValidator brandForNumber:self.cardNumberTextField.text] == STPCardBrandDiscover)
    {
        cardType = @"Discover";
    }
    else if( [STPCardValidator brandForNumber:self.cardNumberTextField.text] == STPCardBrandJCB)
    {
        cardType = @"JCB";
    }
    else if( [STPCardValidator brandForNumber:self.cardNumberTextField.text] == STPCardBrandDinersClub)
    {
        cardType = @"DinersClub";
    }
    else if( [STPCardValidator brandForNumber:self.cardNumberTextField.text] == STPCardBrandUnknown)
    {
        cardType = @"Unknown";
    }
    
    [[STPAPIClient sharedClient] createTokenWithCard:card completion:^(STPToken *token, NSError *error){
        if (error) {
            NSLog(@"ERRRRR = %@",error);
            [HUD removeFromSuperview];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                             message:[NSString stringWithFormat:@"%@",error.localizedDescription]
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
            
        }
        else {
            //when credit card details is correct code here
            NSLog(@"Token = %@",token);
            StripeToken = [ NSString stringWithFormat:@"%@",token];
            // call Call Add Card request
            [HUD removeFromSuperview];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = NSLocalizedString(@"Saving card...", nil);
            [HUD show:YES];
            [ self CallAddCard];
        }
    }];
    
}

#pragma mark ######
#pragma mark Call Add Card web methods
#pragma mark ######

-(void) CallAddCard
{
    // Call Add card
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    userDataDict = [ userDataDict valueForKey:@"User"];
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:StripeToken , @"stripe_token", cardType, @"brand", @"CARD" , @"payment_type", _cardNicknameTextField.text, @"alias", nil] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    // Encrypt the user token using public data and iv data
    NSData *EncodedData = [FBEncryptorAES encryptData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64TokenString = [EncodedData base64EncodedStringWithOptions:0];
    
    NSMutableData *PostData =[[NSMutableData alloc] initWithData:[base64TokenString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@/%@", BaseUrl, AddCard];
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
                         dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD removeFromSuperview];
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
                         });
                    }
                    else
                    {
                         dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD removeFromSuperview];
                        NSLog(@"Add Card Response...%@",responseDic );
                        NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
                        
                        NSMutableDictionary *dic = [ userDataDict mutableCopy];
                        NSMutableDictionary *Userdic = [[ dic valueForKey:@"User"] mutableCopy];
                        
                        NSDictionary *cardData = [responseDic valueForKeyPath:@"PayLoad.data.Card"];
                        [Userdic  setObject:cardData forKey:@"card"];
                        [dic setObject:Userdic forKey:@"User"];
                        
                        NSLog(@"%@", dic);
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:dic] forKey:@"loginUserData"];
                        
                            
                            NSString *cardTitle = [ responseDic valueForKeyPath:@"PayLoad.data.Card.title"];
                            NSLog(@"Card title.. %@",cardTitle);
                            
                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Great!" message:@"Card saved successfully" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                            alertview.tag = 100;
                            [alertview show];
                            
                        });
                    }
                     dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD removeFromSuperview];
                     });
                }
                
            }
            else{
                 dispatch_async(dispatch_get_main_queue(), ^{
                [HUD removeFromSuperview];
                 });
            }
        }
        
    }];
    
    [postDataTask resume];
    
}
- (BOOL)validateCustomerInfo {
    
    return YES;
}

#pragma mark ######
#pragma mark Card.io delegate methods
#pragma mark ######

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@. type:%ld", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv , (long)info.cardType);
    
    // Use the card info...
    NSString * cardtypeNumber =  [ CardIOCreditCardInfo  displayStringForCardType:info.cardType usingLanguageOrLocale:@"EN"];
    NSLog(@"Get type.. %@", cardtypeNumber);
    
    if( [cardtypeNumber isEqualToString:@"0" ])
    {
        cardType = @"Unknown";
    }
    else if( [cardtypeNumber isEqualToString:@"1" ])
    {
        cardType = @"Ambiguous";
    }
    else if( [cardtypeNumber isEqualToString:@"3" ])
    {
        cardType = @"Amex";
    }
    else if( [cardtypeNumber isEqualToString:@"4" ])
    {
        cardType = @"VISA";
    }
    else if( [cardtypeNumber isEqualToString:@"5" ])
    {
        cardType = @"MasterCard";
    }
    else if( [cardtypeNumber isEqualToString:@"6" ])
    {
        cardType = @"Discover";
    }
    else if( [cardtypeNumber isEqualToString:@"J" ])
    {
        cardType = @"JCB";
    }
    
    self.cardNumberTextField.text = [ NSString stringWithFormat:@"%@", info.cardNumber];
    self.monthTextField.text = [ NSString stringWithFormat:@"%lu", (unsigned long)info.expiryMonth];
    self.yearTextField.text = [ NSString stringWithFormat:@"%lu", (unsigned long)info.expiryYear];
    self.cvvTextField.text = [ NSString stringWithFormat:@"%@", info.cvv];
    
    if (![_cardNumberTextField.text isEqualToString:@""]) {
        _cardNumberLbl.hidden = YES;
        _cardNumberHeadingLbl.hidden = NO;
    }
    if (![_monthTextField.text isEqualToString:@""]) {
        _monthLbl.hidden = YES;
        _monthHeadingLbl.hidden = NO;
    }
    if (![_yearTextField.text isEqualToString:@""]) {
        _yearLbl.hidden = YES;
        _yearHeadingLbl.hidden = NO;
    }
    if (![_cvvTextField.text isEqualToString:@""]) {
        _cvvLbl.hidden = YES;
        _cvvHeadingLbl.hidden = NO;
    }
    
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ########
#pragma mark TextField Delegate methods
#pragma mark ######

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView setContentOffset:CGPointMake(0, 60) animated:YES];
    if (textField == _cardNumberTextField)
    {
        _cardNumberHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.cardNumberTextField.layer addSublayer:FirstNameLayer];
        
        if ([ _monthTextField.text isEqual:@""]) {
            _monthLbl.hidden = NO;
            _monthHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
            _monthHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _yearTextField.text isEqual:@""]) {
            _yearLbl.hidden = NO;
            _yearHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            _yearHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cvvTextField.text isEqual:@""]) {
            _cvvLbl.hidden = NO;
            _cvvHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            _cvvHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        if ([ _cardNicknameTextField.text isEqual:@""]) {
            _cardNicknameLbl.hidden = NO;
            _cardNicknameHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            _cardNicknameHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        
    }
    if (textField == _monthTextField)
    {
        _monthHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.monthTextField.layer addSublayer:FirstNameLayer];
        
        if ([ _cardNumberTextField.text isEqual:@""]) {
            _cardNumberLbl.hidden = NO;
            _cardNumberHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            [_cardNumberTextField resignFirstResponder];
            _cardNumberHeadingLbl.textColor = [UIColor whiteColor];
        }
        
        if ([ _yearTextField.text isEqual:@""]) {
            _yearLbl.hidden = NO;
            _yearHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            _yearHeadingLbl.textColor = [UIColor whiteColor];
        }
        
        if ([ _cvvTextField.text isEqual:@""]) {
            _cvvLbl.hidden = NO;
            _cvvHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            
            _cvvHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cardNicknameTextField.text isEqual:@""]) {
            _cardNicknameLbl.hidden = NO;
            _cardNicknameHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            _cardNicknameHeadingLbl.textColor = [UIColor whiteColor];
            
        }
    }
    if (textField == _yearTextField)
    {
        _yearHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.yearTextField.layer addSublayer:FirstNameLayer];
        
        if ([_cardNumberTextField.text isEqual:@""]) {
            _cardNumberLbl.hidden = NO;
            _cardNumberHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
            _cardNumberHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        if ([ _monthTextField.text isEqual:@""]) {
            _monthLbl.hidden = NO;
            _monthHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            _monthHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cvvTextField.text isEqual:@""]) {
            _cvvLbl.hidden = NO;
            _cvvHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            
            _cvvHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cardNicknameTextField.text isEqual:@""]) {
            _cardNicknameLbl.hidden = NO;
            _cardNicknameHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            _cardNicknameHeadingLbl.textColor = [UIColor whiteColor];
            
        }
    }
    if (textField == _cvvTextField)
    {
        _cvvHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.cvvTextField.layer addSublayer:FirstNameLayer];
        
        if ([ _cardNumberTextField.text isEqual:@""]) {
            _cardNumberLbl.hidden = NO;
            _cardNumberHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
            _cardNumberHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _monthTextField.text isEqual:@""]) {
            _monthLbl.hidden = NO;
            _monthHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
            _monthHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        if ([ _yearTextField.text isEqual:@""]) {
            _yearLbl.hidden = NO;
            _yearHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
            _yearHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cardNicknameTextField.text isEqual:@""]) {
            _cardNicknameLbl.hidden = NO;
            _cardNicknameHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            _cardNicknameHeadingLbl.textColor = [UIColor whiteColor];
            
        }
    }
    
    if (textField == _cardNicknameTextField)
    {
        //        UIView *tempVW = [[ UIView alloc] init];
        //
        //        tempVW.frame = CGRectMake(_cardNicknameTextField.frame.origin.x, _monthTextField.frame.origin.y, _cardNicknameTextField.frame.size.width, _cardNicknameTextField.frame.size.height );
        //
        //        [self scrollViewToCenterOfScreen:tempVW];
        
        _cardNicknameHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.cardNicknameTextField.layer addSublayer:FirstNameLayer];
        
        if ([ _cardNumberTextField.text isEqual:@""]) {
            _cardNumberLbl.hidden = NO;
            _cardNumberHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
            _cardNumberHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _monthTextField.text isEqual:@""]) {
            _monthLbl.hidden = NO;
            _monthHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
            _monthHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        if ([ _yearTextField.text isEqual:@""]) {
            _yearLbl.hidden = NO;
            _yearHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
            _yearHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cvvTextField.text isEqual:@""]) {
            _cvvLbl.hidden = NO;
            _cvvHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            _cvvHeadingLbl.textColor = [UIColor whiteColor];
            
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  // return NO to not change text
{
    if (string.length == 0) //BackSpace
        
    {
        return YES;
    }
    
    if((textField== self.cardNumberTextField )&& textField.text.length==16)
    {
        return false;
    }
    if((textField== self.monthTextField )&& textField.text.length==2)
    {
        return false;
    }
    if((textField== self.yearTextField )&& textField.text.length==4)
    {
        return false;
    }
    if((textField== self.cvvTextField )&& textField.text.length==4)
    {
        return false;
    }
    
    return YES;
}

#pragma mark #####
#pragma mark Alert View Delegate
#pragma mark ######

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==1002)
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
    if(alertView.tag ==100)
    {
        if (buttonIndex==0)
        {
            
            [self performSegueWithIdentifier:@"ShowMoney" sender:self];
        }
    }
    
}

#pragma mark #####
#pragma mark Guesture Recognizer methods
#pragma mark ######

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)DidRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    UILabel *label = (UILabel*)[gesture view];
    if ( label.tag == 1)
    {
        _cardNumberLbl.hidden = YES;
        _cardNumberHeadingLbl.hidden= NO;
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.cardNumberTextField.layer addSublayer:FirstNameLayer];
        
        [_cardNumberTextField becomeFirstResponder];
        
        if ([ _monthTextField.text isEqual:@""]) {
            _monthLbl.hidden = NO;
            _monthHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
            _monthHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _yearTextField.text isEqual:@""]) {
            _yearLbl.hidden = NO;
            _yearHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            _yearHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        if ([ _cvvTextField.text isEqual:@""]) {
            _cvvLbl.hidden = NO;
            _cvvHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            _cvvHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cardNicknameTextField.text isEqual:@""]) {
            _cardNicknameLbl.hidden = NO;
            _cardNicknameHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
            _cardNicknameHeadingLbl.textColor = [UIColor whiteColor];
        }
    }
    
    if ( label.tag == 2)
    {
        _monthLbl.hidden = YES;
        _monthHeadingLbl.hidden= NO;
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.monthTextField.layer addSublayer:FirstNameLayer];
        
        [_monthTextField becomeFirstResponder];
        
        if ([ _cardNumberTextField.text isEqual:@""]) {
            _cardNumberLbl.hidden = NO;
            _cardNumberHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            [_cardNumberTextField resignFirstResponder];
            _cardNumberHeadingLbl.textColor = [UIColor whiteColor];
        }
        
        if ([ _yearTextField.text isEqual:@""]) {
            _yearLbl.hidden = NO;
            _yearHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
            _yearHeadingLbl.textColor = [UIColor whiteColor];
        }
        
        if ([ _cvvTextField.text isEqual:@""]) {
            _cvvLbl.hidden = NO;
            _cvvHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            _cvvHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cardNicknameTextField.text isEqual:@""]) {
            _cardNicknameLbl.hidden = NO;
            _cardNicknameHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
            _cardNicknameHeadingLbl.textColor = [UIColor whiteColor];
        }
    }
    
    if ( label.tag == 3)
    {
        _yearLbl.hidden = YES;
        _yearHeadingLbl.hidden= NO;
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.yearTextField.layer addSublayer:FirstNameLayer];
        
        [_yearTextField becomeFirstResponder];
        
        if ([_cardNumberTextField.text isEqual:@""]) {
            _cardNumberLbl.hidden = NO;
            _cardNumberHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
            _cardNumberHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        if ([ _monthTextField.text isEqual:@""]) {
            _monthLbl.hidden = NO;
            _monthHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
            _monthHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cvvTextField.text isEqual:@""]) {
            _cvvLbl.hidden = NO;
            _cvvHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            
            _cvvHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cardNicknameTextField.text isEqual:@""]) {
            _cardNicknameLbl.hidden = NO;
            _cardNicknameHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
            _cardNicknameHeadingLbl.textColor = [UIColor whiteColor];
        }
    }
    if ( label.tag == 4)
    {
        _cvvLbl.hidden = YES;
        _cvvHeadingLbl.hidden= NO;
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.cvvTextField.layer addSublayer:FirstNameLayer];
        
        [_cvvTextField becomeFirstResponder];
        
        if ([ _cardNumberTextField.text isEqual:@""]) {
            _cardNumberLbl.hidden = NO;
            _cardNumberHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            _cardNumberHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _monthTextField.text isEqual:@""]) {
            _monthLbl.hidden = NO;
            _monthHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
            _monthHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        if ([ _yearTextField.text isEqual:@""]) {
            _yearLbl.hidden = NO;
            _yearHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
            _yearHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cardNicknameTextField.text isEqual:@""]) {
            _cardNicknameLbl.hidden = NO;
            _cardNicknameHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNicknameTextField.layer addSublayer:FirstNameLayer1];
            
            _cardNicknameHeadingLbl.textColor = [UIColor whiteColor];
        }
    }
    
    if ( label.tag == 5)
    {
        _cardNicknameLbl.hidden = YES;
        _cardNicknameHeadingLbl.hidden= NO;
        
        CALayer *FirstNameLayer = [CALayer layer];
        FirstNameLayer.frame = CGRectMake(0.0f, self.cardNicknameTextField.frame.size.height - 1, self.cardNicknameTextField.frame.size.width, 1.0f);
        FirstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.cardNicknameTextField.layer addSublayer:FirstNameLayer];
        
        [_cardNicknameTextField becomeFirstResponder];
        
        if ([ _cardNumberTextField.text isEqual:@""]) {
            _cardNumberLbl.hidden = NO;
            _cardNumberHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cardNumberTextField.frame.size.height - 1, self.cardNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cardNumberTextField.layer addSublayer:FirstNameLayer1];
            _cardNumberHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _monthTextField.text isEqual:@""]) {
            _monthLbl.hidden = NO;
            _monthHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.monthTextField.frame.size.height - 1, self.monthTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.monthTextField.layer addSublayer:FirstNameLayer1];
            
            _monthHeadingLbl.textColor = [UIColor whiteColor];
            
        }
        if ([ _yearTextField.text isEqual:@""]) {
            _yearLbl.hidden = NO;
            _yearHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.yearTextField.frame.size.height - 1, self.yearTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.yearTextField.layer addSublayer:FirstNameLayer1];
            
            _yearHeadingLbl.textColor = [UIColor whiteColor];
        }
        if ([ _cvvTextField.text isEqual:@""]) {
            _cvvLbl.hidden = NO;
            _cvvHeadingLbl.hidden= YES;
            
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            
        }
        else
        {
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.cvvTextField.frame.size.height - 1, self.cvvTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.cvvTextField.layer addSublayer:FirstNameLayer1];
            
            _cvvHeadingLbl.textColor = [UIColor whiteColor];
        }
        
    }
}



@end

