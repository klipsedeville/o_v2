//
//  ChannelViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 23/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "AddBeneFiciaryViewController.h"
#import "SelectAmountViewController.h"
#import "AppDelegate.h"
#import "ChannelViewController.h"
#import "SendMoneyViewController.h"
#import "BeneficiariesViewController.h"
#import "Controller.h"
#import "LoginViewController.h"

@interface ChannelViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ChannelViewController

#pragma mark ######
#pragma mark View life cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"userData....%@",_userData);
    parameterValueArray = [[ NSMutableArray alloc] init];
    fieldCount = 0;
    _scrollView.bounces = NO;
    countryID = [NSString stringWithFormat:@"%@",[_userData valueForKey:@"countryId"]];
    
    channelArray = [[NSMutableArray alloc]init];
    userBeneficiaryData = [[NSMutableArray alloc]init];
    selectedSettlementDic = [[NSMutableDictionary alloc]init];
    DataArray = [[NSMutableArray alloc]init];
    
    _ChannelsTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _ChannelsTableView.layer.borderWidth= 1;
    _ChannelsTableView.bounces = NO;
    
    _channelView.hidden = NO;
    _blankView.hidden = YES;
    _bankView.hidden = YES;

    self.mobileNumberTextfield.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Mobile Number" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.accNameTextfield.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Account Name" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.accNumberTextfield.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Account Number" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    _ChannelsTableView.hidden = YES;
    _titletableView.hidden = YES;
    title_array = [[NSMutableArray alloc]init];
    
    // Check user session expired or not
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
    
    // Add tool bar on number key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _mobileNumberTextfield.inputAccessoryView = numberToolbar;
    _accNameTextfield.inputAccessoryView = numberToolbar;
    _accNumberTextfield.inputAccessoryView = numberToolbar;
    
    
    //     Call Receiving Currency List
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Fetching settlement channels...", nil);
    [HUD show:YES];
    [ self GetChannelSettleMentlist];
}

-(void)handletap:(UITapGestureRecognizer*)sender
{
    [bankslistTableView setHidden:YES];
    [self.ChannelsTableView setHidden:YES];
    self.scrollView.scrollEnabled = YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:bankslistTableView]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:self.ChannelsTableView]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:self.lowerView]) {
        return NO;
    }
    return YES;
}

#pragma mark #####
#pragma Get Settlement Channles method
#pragma mark ######

-(void)GetChannelSettleMentlist
{
    // Get Settlement Channel
    [ Controller GetSettlementChannelListByUCountryID:countryID withSuccess:^(id responseObject){
        
        [HUD removeFromSuperview];
        
    }andFailure:^(NSString *String)
     {
         [HUD removeFromSuperview];
         
         NSLog(@"REceived String..%@", String);
         
         NSError *error;
         NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers error:&error];
         
         NSDictionary *payLoadDic = [ json valueForKey:@"PayLoad"];
         BOOL Status = [[ payLoadDic valueForKey:@"status"] boolValue];
         channelFound = [[ payLoadDic valueForKey:@"status"] boolValue];
         if ( Status == true)
         {
             NSDictionary *dataDic = [ payLoadDic valueForKey:@"data"];
             channelArray= [dataDic objectForKey:@"channels"];
             NSLog(@"channelArray..%@",channelArray);
             
             if (channelArray.count !=0)
             {
                 selectedSettlementDic = [channelArray objectAtIndex:0];
                 
                 NSDictionary *channelInfoDic = [channelArray objectAtIndex:0];
                 _selectMethodLbl.text = [channelInfoDic valueForKey:@"title"];
                 
                 if (channelArray.count == 1)
                 {
                     _ChannelsTableView.hidden = YES;
                     settlement_channel_id = [channelInfoDic valueForKey:@"id"];
                     
                     NSMutableArray *parametersArray = [ [channelArray objectAtIndex:0] valueForKey:@"settlement_channel_parameters"];
                     NSLog(@"settlement_channel_id ...%@",settlement_channel_id);
                     
                     if([[channelInfoDic valueForKey:@"title"] isEqualToString:@"Bank Transfer"])
                     {
                         NSArray * optionArray = [optionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)currentTag]];
                         if ([[[parametersArray objectAtIndex:0] valueForKey:@"settlement_channel_parameter_options"] count ] ==0) {
                           
                             if ([[[parametersArray objectAtIndex:0] valueForKey:@"options_data"] count ] ==0) {
                                 
                             }
                             else{
                                optionArray = [[parametersArray objectAtIndex:0] valueForKey:@"options_data"];
                             }
                         }
                         else
                         {
                              optionArray = [[parametersArray objectAtIndex:0] valueForKey:@"settlement_channel_parameter_options"];
                         }
                        
                         selectedBankName = [[optionArray objectAtIndex:0] valueForKey:@"title"];
                         [bankslistTableView reloadData];
                     }
                 }
                 else
                 {
                     _ChannelsTableView.hidden = YES;
                     [_ChannelsTableView reloadData];
                     settlement_channel_id = [channelInfoDic valueForKey:@"id"];
                 }
                 
                 NSMutableArray *channel_parameters_array= [[ NSMutableArray alloc] init];
                 NSMutableArray *channel_options_array= [[ NSMutableArray alloc] init];
                 NSMutableArray *Main_array= [[ NSMutableArray alloc] init];
                 
                 if ([[[channelArray objectAtIndex:0] valueForKey:@"settlement_channel_parameters"] count] == 0)
                 {
                 }
                 else
                 {
                     for (int i = 0; i <[[[channelArray objectAtIndex:0] valueForKey:@"settlement_channel_parameters"] count] ; i++)
                     {
                         [channel_parameters_array addObject:[[[channelArray objectAtIndex:0] valueForKey:@"settlement_channel_parameters"] objectAtIndex:i]];
                         
                     }
                     NSLog(@"%@",channel_parameters_array);
                     for (int j = 0; j < channel_parameters_array.count; j++)
                     {
                         if ([[[channel_parameters_array objectAtIndex:j] valueForKey:@"settlement_channel_parameter_options"] count] == 0)
                         {
                             if ([[[channel_parameters_array objectAtIndex:j] valueForKey:@"options_data"] count] == 0)
                             {
                             }
                             else{
                                 [channel_options_array addObject:[[channel_parameters_array objectAtIndex:j]valueForKey:@"options_data"]];
                             }
                         }
                         else
                         {
                             [channel_options_array addObject:[[channel_parameters_array objectAtIndex:j]valueForKey:@"settlement_channel_parameter_options"]];
                         }
                     }
                     NSLog(@"%@",channel_options_array);
                     
                     for (int k = 0; k < channel_options_array.count; k++)
                     {
                         //                NSLog(@"%lu",[[[settlement_channel_parameters_options_array objectAtIndex:k]valueForKey:@"settlement_channel_parameter_options"] count]);
                         
                         [Main_array addObject:[channel_options_array objectAtIndex:k]];
                         for (int l = 0; l < [Main_array count]; l++)
                         {
                             [title_array addObject:[[Main_array objectAtIndex:l] valueForKey:@"title"]];
                         }
                     }
                     title_array = [title_array objectAtIndex:0];
                     NSLog(@"%@",[title_array objectAtIndex:0]);
                 }
             }
         }
         else
         {
             NSString *errorMessage  = [ payLoadDic valueForKey:@"error"];
             if ( [errorMessage isEqualToString:@"Authorization failed"])
             {
                 UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 
                 alertview.tag = 1001;
                 [alertview show];
             }
             else
             {
                 UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"No channels found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 
                 alertview.tag = 1002;
                 [alertview show];
             }
         }
         
     }];
    
}
#pragma mark ######
#pragma mark Alertview Delegate methods
#pragma mark ######

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1001)
    {
        if (buttonIndex ==0) {
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"YES"  forKey:@"UserLogined"];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LoginViewController class]]) {
                    [self.navigationController popToViewController:controller                                   animated:YES];
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

#pragma mark ######
#pragma mark Click Events Method
#pragma mark ######

- (IBAction)methodsListShowClick:(id)sender {
    // Show Channel table
    [self.view endEditing:YES];
    
    bankslistTableView.hidden = YES;
    
    if ([channelArray count] == 0 )
    {
        _ChannelsTableView.hidden = YES;
    }
    else if (_ChannelsTableView.hidden == YES) {
        _ChannelsTableView.hidden = NO;
        [_ChannelsTableView reloadData];
        
    }
    else
    {
        _ChannelsTableView.hidden = YES;
    }
    
    [_scrollView sendSubviewToBack: parameterView];
}

- (IBAction)channelsListShowClick:(id)sender {
    [self.view endEditing:YES];
    _titletableView.hidden = NO;
    _titletableView.frame = CGRectMake(7, 7+_channelView.frame.origin.y, _titletableView.frame.size.width, 120);
    [_titletableView reloadData];
}

- (IBAction)banksListShowClick:(id)sender {
    [self.view endEditing:YES];
    _titletableView.hidden = NO;
    _titletableView.frame = CGRectMake(7, 108, _titletableView.frame.size.width, 240);
    [_titletableView reloadData];
}

- (IBAction)backBtnClicked:(id)sender {
    
    // back button
    [ self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ######
#pragma mark Save beneficiary methods
#pragma mark ######

- (IBAction)saveBeneficiaryBtn:(id)sender {
    
    //  Call Save beneficiary
    [self resignFirstResponder];
    DataArray = [[NSMutableArray alloc]init];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];

    if ([ _selectMethodLbl.text isEqualToString:@"Cash Pickup"] || [settlement_channel_id isEqualToString:@"57877e82-2ef0-4f75-951e-360ec0a806da"]){
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = NSLocalizedString(@"Saving beneficiary...", nil);
        [HUD show:YES];
        [ self callAddBeneficiary];
        
        return;
    }
    
    for ( NSDictionary *paraDic in parameterValueArray) {
        NSString *textString;
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
        [ dict1 setObject:settlement_channel_id forKey:@"settlement_channel_id"];
        
        if([[ paraDic objectForKey:@"parameterTextField"] isKindOfClass:[UITextField class]])
        {
            UITextView *paraText = [ paraDic objectForKey:@"parameterTextField"];
            textString = [paraText.text stringByTrimmingCharactersInSet:whitespace];
        }
        else
        {
            UILabel *paraText = [ paraDic objectForKey:@"parameterTextField"];
            UIButton *optionBtn = (UIButton *)[self.view viewWithTag:paraText.tag-100];
            textString = [optionBtn.titleLabel.text stringByTrimmingCharactersInSet:whitespace];
        }
        if(textString.length==0)
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:[NSString stringWithFormat:@"Provide %@",[ paraDic objectForKey:@"placeHolder"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
            return;
        }
        
        [ dict1 setObject:[paraDic objectForKey:@"parameterID"] forKey:@"settlement_channel_parameter_id"];
        [ dict1 setObject:textString forKey:@"collected_data"];
        [DataArray addObject:dict1];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Saving beneficiary...", nil);
    [HUD show:YES];
    [ self callAddBeneficiary];
}

#pragma mark ######
#pragma  mark Call Add Beneficiary web method
#pragma mark ######

-(void) callAddBeneficiary
{
    // Add beneficiary
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    //    double timeStampFromJSON = [[userDataDict valueForKeyPath:@"api_access_token
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    // Create dictionary of data for beneficiary
    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
    [dictA setValue:[NSString stringWithFormat:@"%@",[_userData valueForKey:@"firstName"]] forKey:@"first_name"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[_userData valueForKey:@"lastName"]] forKey:@"last_name"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[_userData valueForKey:@"emailAddress"]] forKey:@"email_address"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[_userData valueForKey:@"countryId"]] forKey:@"country_currency_id"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[_userData valueForKey:@"phoneNumber"]] forKey:@"phone_number"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[_userData valueForKey:@"Address"]] forKey:@"address"];
    [dictA setValue:settlement_channel_id forKey:@"settlement_channel_id"];
    NSLog(@"USER BENFICIARY DATA ADDED...%@",dictA);
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];

    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:dictA, @"Beneficiary", DataArray, @"BeneficiarySettlementChannelData", nil] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    // Encrypt the user token using public data and iv data
    NSData *EncodedData = [FBEncryptorAES encryptData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64TokenString = [EncodedData base64EncodedStringWithOptions:0];
    
    NSMutableData *PostData =[[NSMutableData alloc] initWithData:[base64TokenString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@/%@", BaseUrl, CreateBeneficiary];
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
                        NSLog(@"Transfer request...%@",responseDic );
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"ConfirmAddBeneficiary" sender:self];
                        });
                    }
                }
                
            }
        }
        
    }];
    
    [postDataTask resume];
}

#pragma mark ######
#pragma mark Table View delegate methods
#pragma mark ######

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 30.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _ChannelsTableView) {
        
        return [channelArray count];
    }
    else{

        return [title_array count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if(tableView == _ChannelsTableView)
    {
        
        cell.textLabel.text = [[channelArray objectAtIndex:indexPath.row]valueForKeyPath:@"title"];
        cell.textLabel.font=[UIFont fontWithName:@"MyriadPro-Regular" size:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor colorWithRed:(218/255.0) green:(218/255.0) blue:(218/255.0) alpha:1.0];
        
    }
    else
    {
        cell.textLabel.text = [title_array objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:@"MyriadPro-Regular" size:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor colorWithRed:(218/255.0) green:(218/255.0) blue:(218/255.0) alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _ChannelsTableView)
    {
        _selectMethodLbl.text = [[channelArray objectAtIndex:indexPath.row]valueForKeyPath:@"title"];
        
        _ChannelsTableView.hidden = YES;
        
        selectedSettlementDic = [channelArray objectAtIndex:indexPath.row];
        
        settlement_channel_id = [selectedSettlementDic valueForKey:@"id"];
        
        title_array = [[NSMutableArray alloc]init];
        
        NSMutableArray *settlement_channel_parameters_array = [[NSMutableArray alloc]init];
        NSMutableArray *settlement_channel_parameters_options_array = [[NSMutableArray alloc]init];
        NSMutableArray *Main_array = [[NSMutableArray alloc]init];

        if ([[[channelArray objectAtIndex:indexPath.row] valueForKey:@"settlement_channel_parameters"] count] == 0)
        {
            
        }
        else
        {
            for (int i = 0; i <[[[channelArray objectAtIndex:indexPath.row] valueForKey:@"settlement_channel_parameters"] count] ; i++)
            {
                [settlement_channel_parameters_array addObject:[[[channelArray objectAtIndex:indexPath.row] valueForKey:@"settlement_channel_parameters"] objectAtIndex:i]];
                
            }
            NSLog(@"%@",settlement_channel_parameters_array);
            for (int j = 0; j < settlement_channel_parameters_array.count; j++)
            {
                if ([[[settlement_channel_parameters_array objectAtIndex:j] valueForKey:@"settlement_channel_parameter_options"] count] == 0)
                {
                    if ([[[settlement_channel_parameters_array objectAtIndex:j] valueForKey:@"options_data"] count] == 0)
                    {
                    }
                    else{
                       [settlement_channel_parameters_options_array addObject:[[settlement_channel_parameters_array objectAtIndex:j]valueForKey:@"options_data"]];
                    }
                }
                else
                {
                    [settlement_channel_parameters_options_array addObject:[[settlement_channel_parameters_array objectAtIndex:j]valueForKey:@"settlement_channel_parameter_options"]];
                }
            }
            NSLog(@"%@",settlement_channel_parameters_options_array);
            
            for (int k = 0; k < settlement_channel_parameters_options_array.count; k++)
            {
   
                [Main_array addObject:[settlement_channel_parameters_options_array objectAtIndex:k]];
                for (int l = 0; l < [Main_array count]; l++)
                {
                    [title_array addObject:[[Main_array objectAtIndex:l] valueForKey:@"title"]];
                }
            }
            title_array = [title_array objectAtIndex:0];
            NSLog(@"%@",[title_array objectAtIndex:0]);
            
        }
        
        if ([_selectMethodLbl.text  isEqual: @"Airtime"]){
            _channelView.hidden = NO;
            _blankView.hidden = YES;
            _bankView.hidden = YES;
            _channelNameLbl.text = title_array[0];
        }
        else if ([_selectMethodLbl.text  isEqual: @"Cash Pickup"]){
            _channelView.hidden = YES;
            _blankView.hidden = NO;
            _bankView.hidden = YES;
        }
        else{
            _channelView.hidden = YES;
            _blankView.hidden = YES;
            _bankView.hidden = NO;
            _bankTypeLbl.text = title_array[0];
        }
    }

    else{
        if ([_selectMethodLbl.text  isEqual: @"Airtime"]){
            _channelNameLbl.text = title_array[indexPath.row];
            _titletableView.hidden = YES;
        }
        else if ([_selectMethodLbl.text  isEqual: @"Bank Transfer"]){
            _bankTypeLbl.text = title_array[indexPath.row];
            _titletableView.hidden = YES;
        }
    }
}

-(void)cellTapped:(UITapGestureRecognizer*)tap
{
    CGPoint location = [tap locationInView:bankslistTableView];
    NSIndexPath *path = [bankslistTableView indexPathForRowAtPoint:location];
    NSArray * optionArray = [optionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)currentTag]];
    NSDictionary *bankDetialDict = [optionArray objectAtIndex:path.row];
    NSString *titleStr = [NSString stringWithFormat:@"%@",[bankDetialDict valueForKey:@"id"]];
    
    UIButton *optionBtn = (UIButton *)[self.view viewWithTag:currentTag];
    [optionBtn setTitle:titleStr forState:UIControlStateNormal];
    [optionBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    UILabel *label = (UILabel *)[self.view viewWithTag:currentTag+100];
    label.text = [NSString stringWithFormat:@"%@",[bankDetialDict valueForKey:@"title"]];
    
    [bankslistTableView removeFromSuperview];
}

-(void)bankBtnAction : (UIButton *)sender
{
    [self.view endEditing:YES];
    currentTag = (int)sender.tag;
    
    NSArray * optionArray = [optionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)currentTag]];
    [bankslistTableView removeFromSuperview];
    bankslistTableView=[[UITableView alloc]initWithFrame:CGRectMake(sender.frame.origin.x,sender.frame.origin.y +[sender superview].frame.origin.y , sender.frame.size.width-22, optionArray.count*50 ) style:UITableViewStylePlain];
    
    float height = bankslistTableView.frame.size.height + bankslistTableView.frame.origin.y;
    
    if(height > SCREEN_HEIGHT-120)
    {
        bankslistTableView.frame = CGRectMake(bankslistTableView.frame.origin.x, bankslistTableView.frame.origin.y, bankslistTableView.frame.size.width, (SCREEN_HEIGHT-120)-bankslistTableView.frame.origin.y);
    }
    
    bankslistTableView.delegate=self;
    bankslistTableView.dataSource=self;
    [bankslistTableView setAllowsSelection:YES];
    [bankslistTableView setScrollEnabled:YES];
    [_scrollView addSubview:bankslistTableView];
    
    // bank list table view Border
    bankslistTableView.backgroundColor=[UIColor lightGrayColor];
    bankslistTableView.layer.cornerRadius = 0.0;
    bankslistTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bankslistTableView.layer.borderWidth= 0.5;
    bankslistTableView.bounces = NO;
}

#pragma mark ###########
#pragma mark Text Field delegate methods
#pragma mark ######

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width,_scrollView.contentSize.height + 200)];
 
    if (textField == _accNameTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(textField.frame.origin.x, _accNumberTextfield.frame.origin.y+5, textField.frame.size.width, textField.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _accNumberTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y+5, textField.frame.size.width, textField.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    float sizeOfContent = 0;
    NSInteger wd = parameterView.frame.origin.y;
    NSInteger ht = parameterView.frame.size.height;
    sizeOfContent = wd+ht;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

#pragma mark ######
#pragma mark Segue Delegate method
#pragma mark ######

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue to Beneficiary Added Screen");
    if([[segue identifier] isEqualToString:@"ShowBeneficiary"]){
        
    }
}

#pragma mark ######
#pragma mark Scroll view Delegate method
#pragma mark ######

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat availableHeight = applicationFrame.size.height - 350; // Remove area covered by keyboard
    CGFloat y = viewCenterY - availableHeight / 7.0;
    if (y < 0) {
        y = 0;
    }
    [_scrollView setContentOffset:CGPointMake(0, y) animated:YES];
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

-(void)cancelNumberPad{
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}

@end

