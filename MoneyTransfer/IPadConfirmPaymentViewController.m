//
//  IPadConfirmPaymentViewController.m
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "IPadConfirmPaymentViewController.h"
#import "Controller.h"
#import "Constants.h"
#import "PaymentCompletedViewController.h"
#import "IPadPaymentCompletedViewController.h"
#import "iPadLoginViewController.h"


@interface IPadConfirmPaymentViewController ()

@end

@implementation IPadConfirmPaymentViewController
@synthesize paymentData;

#pragma mark ########
#pragma mark View Life Cycle
#pragma mark ########

- (void)viewDidLoad {
    [super viewDidLoad];
    
    payBillDict= [[NSMutableDictionary alloc]init];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    _billLbl.text = _descriptionBillLbl;
    _optionLbl.text = [paymentData valueForKey:@"optionName"];
    _amountLbl.text = [paymentData valueForKey:@"amount"];
    
    int i = 0;
    
    _fieldView.frame = CGRectMake(_fieldView.frame.origin.x, _fieldView.frame.origin.y, _fieldView.frame.size.width, (93 * _paymentUserData.count));
    
    for ( NSDictionary *fieldDic in _paymentUserData) {
        
        UITextView *fldText = [ fieldDic objectForKey:@"reqFldTextField"];
        
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.frame = CGRectMake(20, 10+(i*93), SCREEN_WIDTH-40, 26);
        titleLbl.text = [fieldDic objectForKey:@"placeHolder"];
        titleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:20];
        titleLbl.textColor = [self colorWithHexString:@"51595c"];
        [_fieldView addSubview:titleLbl];
        
        UILabel *valueLbl = [[UILabel alloc] init];
        valueLbl.frame = CGRectMake(20,titleLbl.frame.size.height+titleLbl.frame.origin.y, SCREEN_WIDTH-40, 40);
        valueLbl.text = fldText.text;
        valueLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:30];
        valueLbl.textColor = [self colorWithHexString:@"51595c"];
        [_fieldView addSubview:valueLbl];
        
        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(20,valueLbl.frame.size.height+valueLbl.frame.origin.y, SCREEN_WIDTH-40, 2)];
        newView.backgroundColor=[self colorWithHexString:@"51595c"];
        [_fieldView addSubview:newView];
        
        i++;
    }
    
    float sizeOfContent = 0;
    NSInteger wd = _fieldView.frame.origin.y;
    NSInteger ht = _fieldView.frame.size.height;
    
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    _scrollView.bounces = NO;
}

- (IBAction)backBtnClicked:(id)sender {
    
    [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)paymentBtn:(id)sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];

    [self callPayBill];
}

#pragma mark ########
#pragma mark Call pay bill
#pragma mark ########

-(void)callPayBill
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
    [dictA setValue:_billCategoryId forKey:@"bill_id"];
    [dictA setValue:[paymentData valueForKey:@"billOptionID"] forKey:@"bill_option_id"];
    [dictA setValue:_amountLbl.text forKey:@"amount"];
    
    NSLog(@"Bill DATA ADDED...%@",dictA);
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:dictA, @"BillPayment", _DataArray, @"BillCollectedField", nil] options:NSJSONWritingPrettyPrinted error:nil];
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
                        
                        payBillDict = [responseDic valueForKeyPath:@"PayLoad.data.BillPayment"];
                        
                        NSLog(@"Transfer request...%@",responseDic );
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"TransferPayment" sender:self];
                            
                        });
                    }
                }
                
            }
        }
        
    }];
    
    [postDataTask resume];
}

#pragma mark ########
#pragma mark Segue method
#pragma mark ########

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@"segue to Beneficiary screen");
    if([[segue identifier] isEqualToString:@"TransferPayment"]){
        IPadPaymentCompletedViewController *vc = [segue destinationViewController];
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

#pragma mark ########
#pragma mark Alert view Delegate
#pragma mark ########

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
    
}

@end
