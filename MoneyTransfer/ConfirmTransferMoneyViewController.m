//
//  ConfirmTransferMoneyViewController.m
//  MoneyTransfer
//
//  Created by apple on 07/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "ConfirmTransferMoneyViewController.h"
#import "Controller.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CustomPopUp.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "AsyncImageView.h"

@interface ConfirmTransferMoneyViewController ()

@end

@implementation ConfirmTransferMoneyViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    transferConfirmMoneyInfoNew = [[NSDictionary alloc]init];
     transferConfirmMoneyInfoNew = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"ConfirmTransferData"]];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShade) name:@"removeShade" object:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    NSLog(@"TransferConfirm Money info...%@",_transferConfirmMoneyInfo);
    
    // Check user Session Expire or not
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
    
    _last4DigitCreditCardLbl.text = [ NSString stringWithFormat:@"%@",[userDataDict valueForKeyPath:@"card.title"]];
    
    if ([transferConfirmMoneyInfoNew valueForKeyPath:@"sending_amount"] != nil){
    _sendingAmountTransferLbl.text = [ NSString stringWithFormat:@"%@%@",[transferConfirmMoneyInfoNew valueForKeyPath:@"sending_money_user_CurrencySymbol"],[transferConfirmMoneyInfoNew valueForKeyPath:@"sending_amount"]];
    }
 
   _SendingMoneyUserNameLbl.text = [ NSString stringWithFormat:@"%@",[transferConfirmMoneyInfoNew valueForKeyPath:@"sending_money_username"]];
    
    NSString *str = [[ NSString stringWithFormat:@"%@",[transferConfirmMoneyInfoNew valueForKeyPath:@"sending_money_username_country"]]lowercaseString];
    NSMutableString *result = [str mutableCopy];
    [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                      withString:[[substring substringToIndex:1] uppercaseString]];
                            }];
    NSLog(@"%@", result);
    _sendingMoneyUserCountryNameLbl.text = result;
    _exchangeRateLbl.text  = [ NSString stringWithFormat:@"Ex. Rate: %@1.00 to %@%@.00 Fee %@%@.00",[transferConfirmMoneyInfoNew valueForKey:@"sending_money_user_CurrencySymbol"],[transferConfirmMoneyInfoNew valueForKey:@"receiving_money_user_CurrencySymbol"],[transferConfirmMoneyInfoNew valueForKey:@"exchange_rate"],[transferConfirmMoneyInfoNew valueForKeyPath:@"sending_money_user_CurrencySymbol"],[transferConfirmMoneyInfoNew valueForKey:@"fee"]];

    sending_country_currency = [transferConfirmMoneyInfoNew valueForKey:@"sending_country_currency"];
    receiving_country_currency = [transferConfirmMoneyInfoNew valueForKey:@"receiving_country_currency"];
    sending_amount = [transferConfirmMoneyInfoNew valueForKey:@"sending_amount"];
    receiving_amount = [transferConfirmMoneyInfoNew valueForKey:@"receiving_amount"];
    fee = [transferConfirmMoneyInfoNew valueForKey:@"fee"];
    exchange_rate = [transferConfirmMoneyInfoNew valueForKey:@"exchange_rate"];
    beneficiary_id = [transferConfirmMoneyInfoNew valueForKey:@"beneficiary_id"];
    source = [transferConfirmMoneyInfoNew valueForKey:@"source"];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width,335)];
}

#pragma  mark ############
#pragma  mark Click action methods
#pragma  mark ############

- (IBAction)backBtnClicked:(id)sender {
    // back Button
    [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendMoneyBtn:(id)sender {
    
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    CustomPopUp *popUp = [[CustomPopUp alloc]initWithNibName:@"CustomPopUp_iPhone"  bundle:nil];
    popUp.popUpMsg = @"You appear to be offline. Please check your net connection and retry.";
    popUp.callFrom = [userDataDict valueForKeyPath:@"phone_number"];
    popUp.delegate = self;
    
    [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
    
    }

#pragma  mark ############
#pragma  mark Call Transfer Request methods
#pragma  mark ############

-(void)callTransferRequest
{
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
    [dictA setValue:beneficiary_id forKey:@"beneficiary_id"];
    [dictA setValue:exchange_rate forKey:@"exchange_rate"];
    [dictA setValue:fee forKey:@"fee"];
    [dictA setValue:receiving_amount forKey:@"receiving_amount"];
    [dictA setValue:receiving_country_currency forKey:@"receiving_country_currency"];
    [dictA setValue:sending_amount forKey:@"sending_amount"];
    [dictA setValue:sending_country_currency forKey:@"sending_country_currency"];
    
    [dictA setValue:@"ios" forKey:@"source"];
    
    NSLog(@"Transfer Requested DATA ADDED...%@",dictA);
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:dictA, @"TransferRequest", nil] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    // Encrypt the user token using public data and iv data
    NSData *EncodedData = [FBEncryptorAES encryptData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64TokenString = [EncodedData base64EncodedStringWithOptions:0];
    
    NSMutableData *PostData =[[NSMutableData alloc] initWithData:[base64TokenString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@/%@", BaseUrl, TransferRequest];
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
                    
                    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data1  options:NSJSONReadingMutableContainers error:&error];
                    
                    dispatch_queue_t concurrentQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(concurrentQueue1, ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"] integerValue];
                            if (status == 0)
                            {
                                [HUD removeFromSuperview];
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
                                NSLog(@"Transfer request...%@",responseDic );
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self performSegueWithIdentifier:@"TransferComplete" sender:self];
                                });
                            }
                        });
                    });
                }
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
}

#pragma mark ########
#pragma mark Color HexString methods
#pragma  mark ############

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
        [self callTransferRequest];
        
        
    }
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"callStatusValue"];
}
@end
