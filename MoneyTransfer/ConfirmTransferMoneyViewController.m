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
#import "BackPopUp.h"
#import "DuphluxAuth.h"
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

-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DuphluxAuthStatus" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cancel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"verifying"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stop"];
    // Remove the notifications
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DuphluxAuthStatus" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DuphluxAuthStatusCall:) name:@"DuphluxAuthStatus" object:nil];
    
     [[ NSUserDefaults standardUserDefaults] setInteger:nil forKey:@"timeStamp"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShade) name:@"removeShade" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusTimer) name:@"statusTimer" object:nil];
    transferConfirmMoneyInfoNew = [[NSDictionary alloc]init];
    transferConfirmMoneyInfoNew = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"ConfirmTransferData"]];
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
    
    NSString *dateString = [self stringWithRandomSuffixForFile:@"file.pdf" withLength:4];
    [[ NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"DuphuluxReferenceNumber"];
    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
    [dictA setValue:phoneNumber forKey:@"phone_number"];
    [dictA setValue:@"900" forKey:@"timeout"];
    [dictA setValue:dateString forKey:@"transaction_reference"];
    [dictA setValue:@"com.uve.MoneyTransferApp" forKey:@"redirect_url"];
    
    [DuphluxAuth callAuthMethod:dictA  withSuccess:^( NSString *sucessString)
     {
         [HUD removeFromSuperview];
         NSLog(@"result string %@", sucessString);
         
         NSError *jsonError;
         NSData *objectData = [sucessString dataUsingEncoding:NSUTF8StringEncoding];
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
                 alertview.tag = 1001;
                 [alertview show];
             });
         }
         
     }andFailure:^( NSString *errorString)
     {
         [HUD removeFromSuperview];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
             [HUD removeFromSuperview];
         });
         
     }];
}

-(void) getAuthStatusWebService:( NSString *)referneceString
{
    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
    [dictA setValue:referneceString forKey:@"transaction_reference"];
    
    [DuphluxAuth checkAuthStatusMethod:dictA  withSuccess:^( NSString *sucessString)
     {
         [HUD removeFromSuperview];
         
         NSLog(@"result string %@", sucessString);
         NSError *jsonError;
         NSData *objectData = [sucessString dataUsingEncoding:NSUTF8StringEncoding];
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
                     dispatch_async(dispatch_get_main_queue(), ^{
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
                     });
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
     }andFailure:^( NSString *errorString)
     {
         [HUD removeFromSuperview];
         dispatch_async(dispatch_get_main_queue(), ^{
             [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
             [HUD removeFromSuperview];
             UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Connection error. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alertview show];
         });
         
     }];
}

//-(void) callAuthWebService:(NSString *) phoneNumber
//{
//    NSString *ApiUrl = [ NSString stringWithFormat:@"%@", @"https://duphlux.com/webservice/authe/verify.json"];
//    NSURL *url = [NSURL URLWithString:ApiUrl];
//
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    request.HTTPMethod = @"POST";
//
//    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
//    [request addValue:@"0529a925f2afca8e20f770abd6378ed8805b5593" forHTTPHeaderField:@"token"];
//
//    NSString *dateString = [self stringWithRandomSuffixForFile:@"file.pdf" withLength:4];
//    [[ NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"DuphuluxReferenceNumber"];
//    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
//    [dictA setValue:userPhoneNumber forKey:@"phone_number"];
//    [dictA setValue:@"900" forKey:@"timeout"];
//    [dictA setValue:dateString forKey:@"transaction_reference"];
//    [dictA setValue:@"com.uve.MoneyTransferApp" forKey:@"redirect_url"];
//
//    NSData *PostData = [NSJSONSerialization dataWithJSONObject:dictA options:NSJSONWritingPrettyPrinted error:nil];
//
//    [request setHTTPBody:PostData];
//
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        //if communication was successful
//        if (!error) {
//            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
//            if (httpResp.statusCode == 200)
//            {
//
//                NSString* resultString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"result string %@", resultString);
//                NSError *jsonError;
//                NSData *objectData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                     options:NSJSONReadingMutableContainers
//                                                                       error:&jsonError];
//
//                NSLog(@"json string %@", json);
//                if ([[json valueForKeyPath:@"PayLoad.status"] boolValue] == YES)
//                {
//                    NSDictionary *responseDic = [ json valueForKeyPath:@"PayLoad.data"];
//                    NSString *redirectURl = [ responseDic valueForKey:@"verification_url"];
//                    NSURL *url = [NSURL URLWithString:redirectURl];
//
//                    double timeStamp = [[responseDic valueForKey:@"expires_at"]doubleValue];
//                    [[ NSUserDefaults standardUserDefaults] setInteger:timeStamp forKey:@"timeStamp"];
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        NSLog(@"%@",url );
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//                            [HUD removeFromSuperview];
//                        });
//
//                        [[ NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CallDuphluxAuth"];
//                        callingPhoneNumber = [NSString stringWithFormat:@"%@", [responseDic valueForKey:@"number"]];
//                        CustomPopUp *popUp = [[CustomPopUp alloc]initWithNibName:@"CustomPopUp_iPhone"  bundle:nil];
//                        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"hudView"];
//                        popUp.popUpMsg = @"You appear to be offline. Please check your net connection and retry.";
//                        popUp.callFrom = userPhoneNumber;
//                        popUp.OkBtnTitle = @"CALL TO AUTHENTICATE";
//                        popUp.callTo = callingPhoneNumber;
//                        popUp.delegate = self;
//                        [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
//                    });
//                }
//                else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//                        [HUD removeFromSuperview];
//                        NSArray *errorArray = [ json valueForKeyPath:@"PayLoad.errors"];
//
//                        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Errors Encountered:" message:[NSString stringWithFormat:@"1. %@",[errorArray objectAtIndex:0]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                        alertview.tag = 2001;
//                        [alertview show];
//                    });
//                }
//            }
//            else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//                    [HUD removeFromSuperview];
//                });
//            }
//        }
//        else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//                [HUD removeFromSuperview];
//            });
//        }
//    }];
//    [postDataTask resume];
//}
//
//-(void) getAuthStatusWebService:( NSString *)referneceString
//{
//    NSString *ApiUrl = [ NSString stringWithFormat:@"%@", @"https://duphlux.com/webservice/authe/status.json"];
//    NSURL *url = [NSURL URLWithString:ApiUrl];
//
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    request.HTTPMethod = @"POST";
//
//    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
//    [request addValue:@"0529a925f2afca8e20f770abd6378ed8805b5593" forHTTPHeaderField:@"token"];
//
//    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
//    [dictA setValue:referneceString forKey:@"transaction_reference"];
//
//    NSData *PostData = [NSJSONSerialization dataWithJSONObject:dictA options:NSJSONWritingPrettyPrinted error:nil];
//
//    [request setHTTPBody:PostData];
//
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        //if communication was successful
//        if (!error) {
//            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
//            if (httpResp.statusCode == 200)
//            {
//
//                NSString* resultString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"result string %@", resultString);
//                NSError *jsonError;
//                NSData *objectData = [resultString dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
//                                                                     options:NSJSONReadingMutableContainers
//                                                                       error:&jsonError];
//
//                NSLog(@"json string %@", json);
//
//
//                if ([[json valueForKeyPath:@"PayLoad.status"] boolValue] == YES)
//                {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        [HUD removeFromSuperview];
//                        if ([[json valueForKeyPath:@"PayLoad.data.verification_status"]  isEqual: @"verified"])
//                        {
//                            [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"cancel"];
//                            [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"verifying"];
//                            [[NSUserDefaults standardUserDefaults] synchronize];
//                            [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//                            CustomPopUp *popUp = [[CustomPopUp alloc]initWithNibName:@"CustomPopUp_iPhone"  bundle:nil];
//                            popUp.popUpMsg = @"You appear to be offline. Please check your net connection and retry.";
//                            popUp.OkBtnTitle = @"verify";
//                            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"hudView"];
//                            popUp.callTo = callingPhoneNumber;
//                            popUp.callFrom = userPhoneNumber;
//                            popUp.delegate = self;
//                            [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
//                        }
//                        else{
//
//                            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"timerActive"]  isEqual: @"Yes"]){
//                            }
//                            else{
//                                [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//                                CustomPopUp *popUp = [[CustomPopUp alloc]initWithNibName:@"CustomPopUp_iPhone"  bundle:nil];
//                                popUp.popUpMsg = @"You appear to be offline. Please check your net connection and retry.";
//                                popUp.OkBtnTitle = @"CALL TO AUTHENTICATE";
//                                [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"hudView"];
//                                popUp.callTo = callingPhoneNumber;
//                                popUp.callFrom = userPhoneNumber;
//                                popUp.delegate = self;
//
//
//                                [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
//                            }
//                        }
//                    });
//                }
//                else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//                        [HUD removeFromSuperview];
//                    });
//                    NSArray *errorArray = [ json valueForKeyPath:@"PayLoad.error"];
//                    if (errorArray != nil){
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:[errorArray objectAtIndex:0] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                            [alertview show];
//                        });
//
//                    }
//                }
//            }
//            else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//                    [HUD removeFromSuperview];
//                });
//
//            }
//        }
//        else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//                [HUD removeFromSuperview];
//            });
//        }
//    }];
//    [postDataTask resume];
//}

#pragma  mark ############
#pragma  mark Call Transfer Request methods
#pragma  mark ############

-(void)callTransferRequest
{
    sending_country_currency = [transferConfirmMoneyInfoNew valueForKey:@"sending_country_currency"];
    receiving_country_currency = [transferConfirmMoneyInfoNew valueForKey:@"receiving_country_currency"];
    sending_amount = [transferConfirmMoneyInfoNew valueForKey:@"sending_amount"];
    receiving_amount = [transferConfirmMoneyInfoNew valueForKey:@"receiving_amount"];
    fee = [transferConfirmMoneyInfoNew valueForKey:@"fee"];
    exchange_rate = [transferConfirmMoneyInfoNew valueForKey:@"exchange_rate"];
    beneficiary_id = [transferConfirmMoneyInfoNew valueForKey:@"beneficiary_id"];
    source = [transferConfirmMoneyInfoNew valueForKey:@"source"];
    
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
    if (alertView.tag ==2001) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"stop"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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

-(void) statusTimer{
    NSString *referneceString =  [[ NSUserDefaults standardUserDefaults] valueForKey:@"DuphuluxReferenceNumber"];
    [self getAuthStatusWebService:referneceString];
}

-(void) removeShade {
    [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"callStatusValue"]  isEqual: @"Continue"]){
        transferConfirmMoneyInfoNew = [[NSDictionary alloc]init];
        transferConfirmMoneyInfoNew = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"ConfirmTransferData"]];
        // Call transfer request
        [HUD removeFromSuperview];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = NSLocalizedString(@"Loading...", nil);
        [HUD show:YES];
        [self callTransferRequest];
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
