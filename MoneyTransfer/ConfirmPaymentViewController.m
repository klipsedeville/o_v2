//
//  ConfirmPaymentViewController.m
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "ConfirmPaymentViewController.h"
#import "Controller.h"
#import "Constants.h"
#import "PaymentCompletedViewController.h"
#import "LoginViewController.h"
#import "CustomPopUp.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "AsyncImageView.h"
#import "BackPopUp.h"

@interface ConfirmPaymentViewController ()

@end
@implementation ConfirmPaymentViewController
@synthesize paymentData;

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############

- (void)viewDidLoad {
    [super viewDidLoad];
     [[ NSUserDefaults standardUserDefaults] setInteger:nil forKey:@"timeStamp"];
    // Remove the notifications
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DuphluxAuthStatus" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DuphluxAuthStatusCall:) name:@"DuphluxAuthStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShade) name:@"removeShade" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusTimer) name:@"statusTimer" object:nil];
    payBillDict= [[NSMutableDictionary alloc]init];
    
    // Do any additional setup after loading the view.
}
-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DuphluxAuthStatus" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cancel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"verifying"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stop"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    // Check User Session expire or Not
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
    else
    {
        NSLog(@"User Session not expired");
    }
    NSLog(@"UserPaymentData... %@",paymentData);
    
    _billLbl.text = _descriptionBillLbl;
    _optionLbl.text = [paymentData valueForKey:@"option_name"];
    _amountLbl.text = [paymentData valueForKey:@"amount"];
    
    int i = 0;
    
    _fieldView.frame = CGRectMake(_fieldView.frame.origin.x, _fieldView.frame.origin.y, _fieldView.frame.size.width, (76 * _paymentUserData.count)+30);
    
    if (_paymentUserData.count == 0){
        _exchangeRateLbl.frame = CGRectMake(0, 360, SCREEN_WIDTH, _exchangeRateLbl.frame.size.height);
          _lastView.frame = CGRectMake(0, 400, SCREEN_WIDTH, _lastView.frame.size.height);
    }
    else{
        _exchangeRateLbl.frame = CGRectMake(0, 330+_fieldView.frame.size.height, SCREEN_WIDTH, _exchangeRateLbl.frame.size.height);
        _lastView.frame = CGRectMake(0, 370+_fieldView.frame.size.height, SCREEN_WIDTH, _lastView.frame.size.height);
    }
    
    for (int i=0; i< _paymentUserData.count; i++)
    {
        NSDictionary *fieldDic = [ _paymentUserData objectAtIndex:i];
        NSDictionary *valueDic = [ _DataArray objectAtIndex:i];
        
        NSString *fldText = [ valueDic objectForKey:@"collected_data"];
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.frame = CGRectMake(10, 29+(i*76), SCREEN_WIDTH-20, 20);
        titleLbl.text = [fieldDic objectForKey:@"placeHolder"];
        titleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
        titleLbl.textColor = [self colorWithHexString:@"51595c"];
        [_fieldView addSubview:titleLbl];
        
        UILabel *valueLbl = [[UILabel alloc] init];
        valueLbl.frame = CGRectMake(10,titleLbl.frame.size.height+titleLbl.frame.origin.y, SCREEN_WIDTH-20, 30);
        valueLbl.text = fldText;
        valueLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
        valueLbl.textColor = [self colorWithHexString:@"51595c"];
        [_fieldView addSubview:valueLbl];
        
        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(10,valueLbl.frame.size.height+valueLbl.frame.origin.y-5, SCREEN_WIDTH-20, 1)];
        newView.backgroundColor=[self colorWithHexString:@"51595c"];
        [_fieldView addSubview:newView];
    }
    
    billUserData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"PayBillDetail"]];
    
    _billerCategoryLbl.text = [NSString stringWithFormat:@"%@",[billUserData valueForKeyPath:@"bill_provider.title"]];;
    _billerDetailsLbl.text = [NSString stringWithFormat:@"%@",[billUserData valueForKeyPath:@"bill_provider.address"]];;
    
    // Call get Commercial
    [self getCommercials];
    
    float sizeOfContent = 0;
    NSInteger wd = _lastView.frame.origin.y;
    NSInteger ht = _lastView.frame.size.height;
    sizeOfContent = wd+ht+20;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = YES;
    
    UIColor *color = [self colorWithHexString:@"51595c"];
    _fullNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: color}];

    _emailAddressTextFielf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    _phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: color}];
}

#pragma  mark ############
#pragma  mark Click Action methods
#pragma  mark ############

- (IBAction)backBtnClicked:(id)sender {
    
    // Back Button
    [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)paymentBtn:(id)sender {
    
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userPhoneNumber = [userDataDict valueForKeyPath:@"User.phone_number"];
    BackPopUp *popUp = [[BackPopUp alloc]initWithNibName:@"BackPopUp"  bundle:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@"normal" forKey:@"hudView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
    
      [self callAuthWebService:userPhoneNumber];
}
- (void)DuphluxAuthStatusCall:(NSNotification *)notification
{
    NSString *referneceString =  [[ NSUserDefaults standardUserDefaults] valueForKey:@"DuphuluxReferenceNumber"];
    BackPopUp *popUp = [[BackPopUp alloc]initWithNibName:@"BackPopUp"  bundle:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@"normal" forKey:@"hudView"];
    [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
    [self getAuthStatusWebService:referneceString];
}

-(void) callAuthWebService:(NSString *) phoneNumber
{
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@", @"https://duphlux.com/webservice/authe/verify.json"];
    NSURL *url = [NSURL URLWithString:ApiUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request addValue:@"0529a925f2afca8e20f770abd6378ed8805b5593" forHTTPHeaderField:@"token"];
    
    NSString *dateString = [self stringWithRandomSuffixForFile:@"file.pdf" withLength:4];
    [[ NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"DuphuluxReferenceNumber"];
    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
    [dictA setValue:userPhoneNumber forKey:@"phone_number"];
    [dictA setValue:@"900" forKey:@"timeout"];
    [dictA setValue:dateString forKey:@"transaction_reference"];
    [dictA setValue:@"com.uve.MoneyTransferApp" forKey:@"redirect_url"];
    
    NSData *PostData = [NSJSONSerialization dataWithJSONObject:dictA options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setHTTPBody:PostData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if communication was successful
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200)
            {
                
                NSString* resultString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"result string %@", resultString);
                NSError *jsonError;
                NSData *objectData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                
                NSLog(@"json string %@", json);
                if ([[json valueForKeyPath:@"PayLoad.status"] boolValue] == YES)
                {
                    NSDictionary *responseDic = [ json valueForKeyPath:@"PayLoad.data"];
                    NSString *redirectURl = [ responseDic valueForKey:@"verification_url"];
                    NSURL *url = [NSURL URLWithString:redirectURl];
                    
                    double timeStamp = [[responseDic valueForKey:@"expires_at"]doubleValue];
                    [[ NSUserDefaults standardUserDefaults] setInteger:timeStamp forKey:@"timeStamp"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSLog(@"%@",url );
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                            [HUD removeFromSuperview];
                        });
                        
                        [[ NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CallDuphluxAuth"];
                        callingPhoneNumber = [NSString stringWithFormat:@"%@", [responseDic valueForKey:@"number"]];
                        CustomPopUp *popUp = [[CustomPopUp alloc]initWithNibName:@"CustomPopUp_iPhone"  bundle:nil];
                        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"hudView"];
                        popUp.popUpMsg = @"You appear to be offline. Please check your net connection and retry.";
                        popUp.callFrom = userPhoneNumber;
                        popUp.OkBtnTitle = @"CALL TO AUTHENTICATE";
                        popUp.callTo = callingPhoneNumber;
                        popUp.delegate = self;
                        [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                        [HUD removeFromSuperview];
                        NSArray *errorArray = [ json valueForKeyPath:@"PayLoad.errors"];
                        
                        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Errors Encountered:" message:[NSString stringWithFormat:@"1. %@",[errorArray objectAtIndex:0]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        alertview.tag = 2001;
                        [alertview show];
                    });
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                    [HUD removeFromSuperview];
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                [HUD removeFromSuperview];
            });
        }
    }];
    [postDataTask resume];
}

-(void) getAuthStatusWebService:( NSString *)referneceString
{
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@", @"https://duphlux.com/webservice/authe/status.json"];
    NSURL *url = [NSURL URLWithString:ApiUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request addValue:@"0529a925f2afca8e20f770abd6378ed8805b5593" forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
    [dictA setValue:referneceString forKey:@"transaction_reference"];
    
    NSData *PostData = [NSJSONSerialization dataWithJSONObject:dictA options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setHTTPBody:PostData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if communication was successful
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200)
            {
                
                NSString* resultString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"result string %@", resultString);
                NSError *jsonError;
                NSData *objectData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                
                NSLog(@"json string %@", json);
                
                
                if ([[json valueForKeyPath:@"PayLoad.status"] boolValue] == YES)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [HUD removeFromSuperview];
                        if ([[json valueForKeyPath:@"PayLoad.data.verification_status"]  isEqual: @"verified"])
                        {
                            [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"cancel"];
                            [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"verifying"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                            CustomPopUp *popUp = [[CustomPopUp alloc]initWithNibName:@"CustomPopUp_iPhone"  bundle:nil];
                            popUp.popUpMsg = @"You appear to be offline. Please check your net connection and retry.";
                            popUp.OkBtnTitle = @"verify";
                            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"hudView"];
                            popUp.callTo = callingPhoneNumber;
                            popUp.callFrom = userPhoneNumber;
                            popUp.delegate = self;
                            [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
                        }
                        else{
                            
                            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"timerActive"]  isEqual: @"Yes"]){
                            }
                            else{
                                [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                                CustomPopUp *popUp = [[CustomPopUp alloc]initWithNibName:@"CustomPopUp_iPhone"  bundle:nil];
                                popUp.popUpMsg = @"You appear to be offline. Please check your net connection and retry.";
                                popUp.OkBtnTitle = @"CALL TO AUTHENTICATE";
                                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"hudView"];
                                popUp.callTo = callingPhoneNumber;
                                popUp.callFrom = userPhoneNumber;
                                popUp.delegate = self;
                                
                                
                                [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
                            }
                        }
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                        [HUD removeFromSuperview];
                    });
                    NSArray *errorArray = [ json valueForKeyPath:@"PayLoad.error"];
                    if (errorArray != nil){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:[errorArray objectAtIndex:0] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            [alertview show];
                        });
                        
                    }
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                    [HUD removeFromSuperview];
                });
                
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                [HUD removeFromSuperview];
            });
        }
    }];
    [postDataTask resume];
}

#pragma  mark ############
#pragma  mark Call pay bill methods
#pragma  mark ############

-(void)callPayBill
{
    // Pay Bill
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    userDataDict = [userDataDict valueForKeyPath:@"User"];
   
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    // Create dictionary of data for beneficiary
    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
    NSArray * billArray = [billUserData valueForKey:@"bill_options"];
    NSDictionary *billIDDict = [billArray objectAtIndex:0];
    
    [dictA setValue:[billIDDict valueForKeyPath:@"bill_id"] forKey:@"bill_id"];
    [dictA setValue:[billUserData valueForKeyPath:@"bill_provider.bill_provider_id"] forKey:@"bill_provider_id"];
    [dictA setValue:[paymentData valueForKey:@"bill_optionID"] forKey:@"bill_option_id"];
    [dictA setValue:[ rateDic valueForKeyPath:@"PayLoad.data.exchange_rate"] forKey:@"exchange_rate"];
    [dictA setValue:[rateDic valueForKeyPath:@"PayLoad.data.fee"] forKey:@"fee"];
    [dictA setValue:[ rateDic valueForKeyPath:@"PayLoad.data.sending_amount"] forKey:@"sending_amount"];
    [dictA setValue:[ rateDic valueForKeyPath:@"PayLoad.data.receiving_amount"] forKey:@"receiving_amount"];
    [dictA setValue:[userDataDict valueForKeyPath:@"country_currency.id"] forKey:@"sending_country_currency"];
    [dictA setValue:[billUserData valueForKeyPath:@"bill_provider.country_currency.id"] forKey:@"receiving_country_currency"];
    [dictA setValue:_fullNameTextField.text forKey:@"beneficiary_name"];
    [dictA setValue:_phoneNumberTextField.text forKey:@"beneficiary_phone_number"];
    [dictA setValue:_emailAddressTextFielf.text forKey:@"beneficiary_email_address"];
    [dictA setValue:@"ios" forKey:@"source"];
    
    
    NSLog(@"Bill DATA ADDED...%@",dictA);
  
    NSMutableArray *billCollectionArry = [[ NSMutableArray alloc] init];
    
    if (_paymentUserData.count != 0)
    {
        for(int i=0; i< _paymentUserData.count; i++)
        {
            NSDictionary *valuedic =[_DataArray objectAtIndex:i];

            NSMutableDictionary *dictB = [[NSMutableDictionary alloc]init];
            [dictB setValue:[billIDDict valueForKeyPath:@"bill_id"] forKey:@"bill_id"];
            [dictB setValue:[valuedic valueForKey:@"bill_required_field_id"] forKey:@"bill_required_field_id"];
            [dictB setValue:[valuedic valueForKey:@"collected_data"] forKey:@"collected_data"];
            
           [billCollectionArry addObject:dictB];
        }
    }
    
    NSData *data;
    
    if (billCollectionArry.count ==0) {
        data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:dictA, @"BillPayment", nil] options:NSJSONWritingPrettyPrinted error:nil];
    }
    else{
        data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:dictA, @"BillPayment", billCollectionArry, @"BillCollectedField", nil] options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    // Encrypt the user token using public data and iv data
    NSData *EncodedData = [FBEncryptorAES encryptData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64TokenString = [EncodedData base64EncodedStringWithOptions:0];
    
    NSMutableData *PostData =[[NSMutableData alloc] initWithData:[base64TokenString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@/%@", BaseUrl, PayBill];
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
                    [HUD removeFromSuperview];
                    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data1  options:NSJSONReadingMutableContainers error:&error];
                    
                    NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"] integerValue];
                    
                    if (status == 0)
                    {
                        NSArray *errorArray =[ responseDic valueForKeyPath:@"PayLoad.error"];
                        NSLog(@"error ..%@", errorArray);
                        
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
                        [HUD removeFromSuperview];
                        payBillDict = [responseDic valueForKeyPath:@"PayLoad.data"];
                        NSLog(@"Transfer request...%@",responseDic );
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"TransferPayment" sender:self];
                        });
                    }
                }
                
            }
            else{
                 [HUD removeFromSuperview];
            }
        }
        
    }];
    
    [postDataTask resume];
}
#pragma  mark ############
#pragma mark Alertview Delegate methods
#pragma  mark ############

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1001)
    {
        if (buttonIndex ==0) {
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"YES"  forKey:@"UserLogined"];
            
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
    if (alertView.tag ==2001) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"stop"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue to Beneficiary screen");
    if([[segue identifier] isEqualToString:@"TransferPayment"]){
        
        PaymentCompletedViewController *vc = [segue destinationViewController];
        vc.transactionData = payBillDict;
    }
}

#pragma mark ########
#pragma mark Color HexString methods
#pragma mark ########

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

-(void) statusTimer{
    NSString *referneceString =  [[ NSUserDefaults standardUserDefaults] valueForKey:@"DuphuluxReferenceNumber"];
    [self getAuthStatusWebService:referneceString];
}

-(void) removeShade {
    [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
    
     if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"callStatusValue"]  isEqual: @"Continue"]){
        
        // Call change password
        [HUD removeFromSuperview];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = NSLocalizedString(@"Loading...", nil);
        [HUD show:YES];
        [self callPayBill];
        
    }
     else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"callStatusValue"]  isEqual: @"Yes"])
     {
         NSString *referneceString =  [[ NSUserDefaults standardUserDefaults] valueForKey:@"DuphuluxReferenceNumber"];
         BackPopUp *popUp = [[BackPopUp alloc]initWithNibName:@"BackPopUp"  bundle:nil];
         [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
         [[NSUserDefaults standardUserDefaults]setObject:@"normal" forKey:@"hudView"];
         [self getAuthStatusWebService:referneceString];
     }
    //    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"cancel"]  isEqual: @"Yes"]){
    //        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"" message:@"Authentication has been cancelled." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //        alertview.tag = 2001;
    //        [alertview show];
    //    }
     else{
         
         UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"" message:@"Verification cancelled." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         alertview.tag = 2001;
         [alertview show];
     }
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"callStatusValue"];
}

#pragma mark ########
#pragma mark get Commercial data method
#pragma  mark ############

-(void)getCommercials
{
    // get Commercial
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    NSString *direction = @"0";
    NSString *amountText= [paymentData valueForKey:@"amount"];
    
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:[userDataDict valueForKeyPath:@"country_currency.id"], @"sending_currency", [billUserData valueForKeyPath:@"bill_provider.country_currency.id"], @"receiving_currency",amountText, @"amount",direction, @"direction", nil] options:NSJSONWritingPrettyPrinted error:nil];
    
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
    
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    
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
                    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data1  options:NSJSONReadingMutableContainers error:&error];
                    rateDic = [responseDic mutableCopy];
                    NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"] integerValue];
                    
                    if (status == 0)
                    {
                        [HUD removeFromSuperview];
                        [HUD hide:YES];
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
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            NSLog(@"Get Commercial Response...%@",responseDic );
                            [HUD removeFromSuperview];
                            [HUD hide:YES];
                            NSDictionary *myData = [responseDic valueForKeyPath:@"Payload.data"];
                            
                            _exchangeRateLbl.text  = [ NSString stringWithFormat:@"Ex. Rate: %@1.00 = %@%@.00 Service fee %@%@.00",[userDataDict valueForKeyPath:@"country_currency.currency_symbol"],[billUserData valueForKeyPath:@"bill_provider.country_currency.currency_symbol"],[ responseDic valueForKeyPath:@"PayLoad.data.exchange_rate"],[userDataDict valueForKeyPath:@"country_currency.currency_symbol"],[responseDic valueForKeyPath:@"PayLoad.data.fee"]];
                            
                            _amountLbl.text = [ NSString stringWithFormat:@"%@ %@ (%@ %.02f)",[billUserData valueForKeyPath:@"bill_provider.country_currency.currency_symbol"],amountText,[userDataDict valueForKeyPath:@"country_currency.currency_symbol"],[[responseDic valueForKeyPath:@"PayLoad.data.sending_amount"]floatValue]];
                            
                        });
                    }
                }
            }
            else{
                [HUD removeFromSuperview];
                [HUD hide:YES];
            }
        }
    }];
    
    [postDataTask resume];
    
}

#pragma mark ###########
#pragma mark - Text Fields Deletgate methods
#pragma mark ###########

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (SCREEN_HEIGHT ==480)
    {
        if (textField == self.fullNameTextField) {
            [self scrollViewToCenterOfScreen:self.lastView];
        }
        if (textField == self.emailAddressTextFielf) {
            [self scrollViewToCenterOfScreen:self.lastView];
        }
        if (textField == self.phoneNumberTextField) {
            [self scrollViewToCenterOfScreen:self.lastView];
        }
    }
    else  if (SCREEN_HEIGHT ==568) {
        if (textField == self.fullNameTextField) {
            [self scrollViewToCenterOfScreen:self.lastView];
        }
        if (textField == self.emailAddressTextFielf) {
            [self scrollViewToCenterOfScreen:self.lastView];
        }
        if (textField == self.phoneNumberTextField) {
            [self scrollViewToCenterOfScreen:self.lastView];
        }
    }
    else
    {
        if (textField == self.fullNameTextField) {
            [self scrollViewToCenterOfScreen:self.lastView];
        }
        if (textField == self.emailAddressTextFielf) {
            [self scrollViewToCenterOfScreen:self.lastView];
        }
        if (textField == self.phoneNumberTextField) {
            [self scrollViewToCenterOfScreen:self.lastView];
        }
        
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:.5f
                     animations:^{
                         [self.scrollView setContentOffset:CGPointMake(0, -63) animated:YES];
                     }
                     completion:^(BOOL finished){
                     }
     ];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) //BackSpace
    {
        return YES;
    }
    
    return YES;
}

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 350; // Remove area covered by keyboard
    
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [self.scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

- (NSString *)stringWithRandomSuffixForFile:(NSString *)file withLength:(int)length
{
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSString *fileExtension = [file pathExtension];
    NSString *fileName = [file stringByDeletingPathExtension];
    NSMutableString *randomString = [NSMutableString stringWithFormat:@"%@_", fileName];
    
    for (int x = 0; x < length; x++) {
        [randomString appendFormat:@"%C", [alphabet characterAtIndex: arc4random_uniform((int)[alphabet length]) % [alphabet length]]];
    }
    [randomString appendFormat:@".%@", fileExtension];
    
    NSLog(@"## randomString: %@ ##", randomString);
    return randomString;
}

@end
