//
//  iPadPaymentPendingViewController.m
//  MoneyTransfer
//
//  Created by 050 on 10/10/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "iPadPaymentPendingViewController.h"
#import "iPadSelectAmountViewController.h"
#import "IpadConfirmTransferMoneyViewControllerViewController.h"
#import "Controller.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface iPadPaymentPendingViewController ()

@end

@implementation iPadPaymentPendingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView.bounces = NO;
    _navigationTitleTextField.text = [ NSString stringWithFormat:@"Bill Payment Status"];
    _referenceNumberLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"reference"]];
    
    NSString *myString = [_transferStatusData valueForKeyPath:@"created"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [df dateFromString:myString];
    [df setDateFormat:@"MMMM dd, HH:MM"];
    NSString *dateString = [df stringFromDate:date];
    _dateLbl.text = dateString;
    
    _bankAccNameLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"bill_provider.title"]];
    _bankAccDescLabl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"bill_provider.contact_person_address"]];
    _billTitleLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"bill.title"]];
    _billOptionTitleLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"bill_option.title"]];
    
    NSString *sendingAmount = [ NSString stringWithFormat:@"%@", [_transferStatusData valueForKeyPath:@"sending_amount"]];
    
    if( ![sendingAmount containsString:@"."]){
        sendingAmount = [ NSString stringWithFormat:@"%@.00", sendingAmount];
    }
    _AmountLbl.text = [ NSString stringWithFormat:@"₦%@.00 ($%@)",[_transferStatusData valueForKeyPath:@"receiving_amount"], sendingAmount];
    _ExRateLbl.text = [ NSString stringWithFormat:@"Ex. Rate: %@1.00 = %@%@.00 Service Fee: %@%@.00",[_transferStatusData valueForKeyPath:@"sending_currency.currency_symbol"],[_transferStatusData valueForKeyPath:@"receiving_currency.currency_symbol"],[_transferStatusData valueForKey:@"exchange_rate"],[_transferStatusData valueForKeyPath:@"sending_currency.currency_symbol"],[_transferStatusData valueForKey:@"fee"]];
    
    _statusLbl.text = [ NSString stringWithFormat:@"%@",[[_transferStatusData valueForKeyPath:@"status.title"]uppercaseString]];
    
    // ---------------------Dynamic View----------------------------
    NSLog(@"Transfer Status Data is :- %@",_transferStatusData);
    
    NSArray *requiredFieldArray = [_transferStatusData valueForKeyPath:@"bill_payment_stages"];
    
    billPaymentID = [ NSString stringWithFormat:@"%@",[[requiredFieldArray objectAtIndex:0] valueForKey:@"bill_payment_id"]];
    
    if ([requiredFieldArray count] > 0){
        NSMutableArray *stageValue = [[NSMutableArray alloc]init];
        NSDictionary *newData = [[NSDictionary alloc]init];
        for (NSDictionary *newData in requiredFieldArray) {
            [stageValue addObject:newData[@"stage"]];
        }
        
        if ([stageValue count] > 0)
        {
            UIView *addView = [[UIView alloc]init];
            addView.frame = CGRectMake(0, _ExRateLbl.frame.origin.y+_ExRateLbl.frame.size.height+20, SCREEN_WIDTH, ((stageValue.count * 60) + 50));
            addView.backgroundColor = [UIColor clearColor];
            //            addView.backgroundColor = [self colorWithHexString:@"51595c"];
            [_scrollView addSubview:addView];
            
            UILabel *trackingLbl = [[UILabel alloc] init];
            trackingLbl.frame = CGRectMake(10, 15, SCREEN_WIDTH-20, 20);
            trackingLbl.text = @"TRACKING";
            trackingLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:14];
            trackingLbl.textColor = [UIColor whiteColor];
            [addView addSubview:trackingLbl];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,trackingLbl.frame.size.height+trackingLbl.frame.origin.y,SCREEN_WIDTH-20,1)];
            lineView.backgroundColor=[UIColor whiteColor];
            [addView addSubview:lineView];
            
            for(int i=0; i<[stageValue count]; i++)
            {
                NSDictionary *selectedStageValue = [stageValue objectAtIndex:i];
                
                UIImageView *stageImage = [[UIImageView alloc]init];
                stageImage.frame = CGRectMake(10, 50+(i*50), 20, 20);
                stageImage.image = [UIImage imageNamed:@"track"];
                [addView addSubview:stageImage];
                
                UILabel *infoTitleLbl = [[UILabel alloc] init];
                infoTitleLbl.frame = CGRectMake(35, 50+(i*50), SCREEN_WIDTH-20, 20);
                infoTitleLbl.text = [ NSString stringWithFormat:@"%@",[selectedStageValue valueForKeyPath:@"title"]];
                infoTitleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:12];
                infoTitleLbl.textColor = [UIColor whiteColor];
                [addView addSubview:infoTitleLbl];
                
                UILabel *infoDateLbl = [[UILabel alloc] init];
                infoDateLbl.frame = CGRectMake(35, 70+(i*50), SCREEN_WIDTH-20, 20);
                NSString *myString = [ NSString stringWithFormat:@"%@",[selectedStageValue valueForKeyPath:@"modified"]];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSDate *date = [df dateFromString:myString];
                [df setDateFormat:@"MMMM dd yyyy, HH:MM"];
                NSString *dateString = [df stringFromDate:date];
                infoDateLbl.text = dateString;
                infoDateLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10];
                infoDateLbl.textColor = [UIColor whiteColor];
                [addView addSubview:infoDateLbl];
            }
            
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, addView.frame.origin.y+addView.frame.size.height);
        }
    }
    
//    float sizeOfContent = 0;
//    NSInteger wd = _statusView.frame.origin.y;
//    NSInteger ht = _statusView.frame.size.height+45;
//    sizeOfContent = wd+ht;
//    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
}

#pragma mark ########
#pragma mark Click Action methods
#pragma mark ########

-(IBAction)backBtnClicked:(id)sender{
    
    // back button
    [ self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)contactCustomerSupportBtnClicked:(id)sender{
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Support Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Confirm Payment",
                            @"Cancel Bill",
                            @"Open Dispute",
                            @"Contact Support",
                            nil];
    [popup showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self confirm];
            break;
        case 1:
            [self cancel];
            break;
        case 2:
            [self open];
            break;
        case 3:
            [self mail];
            break;
        default:
            break;
    }
    
}
-(void)confirm{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Confirm Receipt" message:@"Are you sure you want to confirm this payment as fulfilled?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertview.tag = 100;
    [alertview show];
}
-(void)cancel{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Cancel Bill Payment" message:@"Are you sure you want to cancel this payment?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertview.tag = 200;
    [alertview show];
}
-(void)open{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"" message:@"2: Open Dispute" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alertview.tag = 300;
    [alertview show];
}
-(void)mail{
    // Contact Customer Support
    // Email Subject
    NSString *emailTitle = @"Bill Payment Enquiry";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"care@orobo.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self.navigationController presentViewController:mc animated:YES completion:NULL];
    }
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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

#pragma mark ######
#pragma mark AlertView Delegate method
#pragma mark ######

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==100) {
        [ self confirmPaymentAPI];
    }
    else if (alertView.tag ==200) {
        [ self cancelBillAPI];
    }
    else if (alertView.tag ==300) {
        [self openDisputeAPI];
    }
    
}

-(void)openDisputeAPI{
    
}
-(void)confirmPaymentAPI{
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:billPaymentID, @"id", nil] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    // Encrypt the user token using public data and iv data
    NSData *EncodedData = [FBEncryptorAES encryptData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64TokenString = [EncodedData base64EncodedStringWithOptions:0];
    
    NSMutableData *PostData =[[NSMutableData alloc] initWithData:[base64TokenString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@%@", BaseUrl, ConfirmBillPaymentFulfillment];
    NSURL *url = [NSURL URLWithString:ApiUrl];
    
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Processing...", nil);
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
                    
                    NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"] integerValue];
                    
                    if (status == 0)
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [HUD removeFromSuperview];
                            [HUD hide:YES];
                            NSArray *errorArray =[ responseDic valueForKeyPath:@"PayLoad.error"];
                            NSLog(@"error ..%@", errorArray);
                            
                            NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
                            
                            if(!errorString || [errorString isEqualToString:@"(null)"])
                            {
                                errorString = @"Your sesssion has been expired.";
                                
                                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Error!" message:[NSString stringWithFormat:@"1. %@", errorString] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                alertview.tag = 1003;
                                
                                [alertview show];
                            }
                            else
                            {
                                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Error!" message:[NSString stringWithFormat:@"1. %@", errorString] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                
                                [alertview show];
                            }
                        });
                    }
                    else
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [HUD removeFromSuperview];
                            [HUD hide:YES];
                            NSLog(@"Response...%@",responseDic );
                            
                            NSDictionary *myData = [responseDic valueForKeyPath:@"Payload.data"];
                            
                        });
                    }
                }
                
            }
            else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [HUD removeFromSuperview];
                    [HUD hide:YES];
                });
            }
        }
        
    }];
    
    [postDataTask resume];
    
}
-(void)cancelBillAPI{
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:billPaymentID, @"id", @"", @"reason", nil] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    // Encrypt the user token using public data and iv data
    NSData *EncodedData = [FBEncryptorAES encryptData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64TokenString = [EncodedData base64EncodedStringWithOptions:0];
    
    NSMutableData *PostData =[[NSMutableData alloc] initWithData:[base64TokenString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@%@", BaseUrl, cancelBill];
    NSURL *url = [NSURL URLWithString:ApiUrl];
    
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Processing...", nil);
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
                    
                    NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"] integerValue];
                    
                    if (status == 0)
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [HUD removeFromSuperview];
                            [HUD hide:YES];
                            NSArray *errorArray =[ responseDic valueForKeyPath:@"PayLoad.error"];
                            NSLog(@"error ..%@", errorArray);
                            
                            NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
                            
                            if(!errorString || [errorString isEqualToString:@"(null)"])
                            {
                                errorString = @"Your sesssion has been expired.";
                                
                                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Error!" message:[NSString stringWithFormat:@"1. %@", errorString] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                alertview.tag = 1003;
                                
                                [alertview show];
                            }
                            else
                            {
                                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Error!" message:[NSString stringWithFormat:@"1. %@", errorString] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                
                                [alertview show];
                            }
                        });
                    }
                    else
                    {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [HUD removeFromSuperview];
                            [HUD hide:YES];
                            NSLog(@"Response...%@",responseDic );
                            
                            NSDictionary *myData = [responseDic valueForKeyPath:@"Payload.data"];
                            
                        });
                    }
                }
                
            }
            else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [HUD removeFromSuperview];
                    [HUD hide:YES];
                });
            }
        }
        
    }];
    
    [postDataTask resume];
}

@end
