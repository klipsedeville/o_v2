//
//  BeneficiariesViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 19/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "BeneficiariesViewController.h"
#import "SendMoneyViewController.h"
#import "AddBeneFiciaryViewController.h"
#import "Controller.h"
#import "SelectAmountViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "AsyncImageView.h"

@interface BeneficiariesViewController ()
{
    AppDelegate *appDel;
}

@end

@implementation BeneficiariesViewController

#pragma mark ######
#pragma mark View life cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    _sendMoneyView.frame = CGRectMake(_sendMoneyView.frame.origin.x, SCREEN_HEIGHT, _sendMoneyView.frame.size.width, _sendMoneyView.frame.size.height);
    
    _deleteView.frame = CGRectMake(_deleteView.frame.origin.x, SCREEN_HEIGHT , _deleteView.frame.size.width, _deleteView.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    // Check user Session Expired or not.
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
    
    selectedUser = @"";
    _lowerView.hidden = YES;
    _middleView.hidden = YES;
    _beneficiaryBtn.hidden = YES;
    
    _sendMoneyView.frame = CGRectMake(_sendMoneyView.frame.origin.x, SCREEN_HEIGHT, _sendMoneyView.frame.size.width, _sendMoneyView.frame.size.height);
    
    _deleteView.frame = CGRectMake(_deleteView.frame.origin.x, SCREEN_HEIGHT , _deleteView.frame.size.width, _deleteView.frame.size.height);
    
    // Call Get beneficiaries list
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading beneficiaries...", nil);
    [HUD show:YES];
    [ self GetBeneficiariesList];
    
    _beneficiaryView.hidden = NO;
    [_beneficiaryListTableView reloadData];
    _beneficiaryListTableView.bounces = NO;
    
    // Guesture
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.4; //seconds
    lpgr.delegate = self;
    [_beneficiaryListTableView addGestureRecognizer:lpgr];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [_deleteView addGestureRecognizer:swiperight];
    
    UISwipeGestureRecognizer * swiperight1=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight1:)];
    swiperight1.direction=UISwipeGestureRecognizerDirectionRight;
    [_sendMoneyView addGestureRecognizer:swiperight1];
    
}

#pragma mark ######
#pragma mark Right swipe method
#pragma mark ######

-(void)swiperight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [UIView animateWithDuration:0.8f animations:^{
        
        _deleteView.frame = CGRectMake(SCREEN_WIDTH, _deleteView.frame.origin.y, _deleteView.frame.size.width, _deleteView.frame.size.height);
        
        _deleteView.alpha = 0.1;
        
    }completion:^(BOOL finished){
        
        _deleteView.frame = CGRectMake(0, SCREEN_HEIGHT, _deleteView.frame.size.width, _deleteView.frame.size.height);
        _deleteView.alpha = 1.0;
    }];
}

-(void)swiperight1:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [UIView animateWithDuration:0.8f animations:^{
        
        _sendMoneyView.frame = CGRectMake(SCREEN_WIDTH, _sendMoneyView.frame.origin.y, _sendMoneyView.frame.size.width, _sendMoneyView.frame.size.height);
        
        _sendMoneyView.alpha = 0.1;
        
    }completion:^(BOOL finished){
        
        _sendMoneyView.frame = CGRectMake(0, SCREEN_HEIGHT, _sendMoneyView.frame.size.width, _sendMoneyView.frame.size.height);
        _sendMoneyView.alpha = 1.0;
    }];
}
#pragma mark ######
#pragma mark User long press detection method
#pragma mark ######

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [timer invalidate];
    CGPoint p = [gestureRecognizer locationInView:_beneficiaryListTableView];
    NSIndexPath *indexPath = [_beneficiaryListTableView indexPathForRowAtPoint:p];
    if (indexPath == nil)
    {
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        _deleteView.frame = CGRectMake(_deleteView.frame.origin.x, SCREEN_HEIGHT, _deleteView.frame.size.width, _deleteView.frame.size.height);
        
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            beneficiaryDic = [beneficiaryArray objectAtIndex:indexPath.row];
            selectedBeneficaryID= [beneficiaryDic  valueForKey:@"id"];
            _beneficaryNameLbl.text = [[ NSString stringWithFormat:@"Delete %@?",[beneficiaryDic valueForKeyPath:@"full_name"]]uppercaseString];
            
            _beneficaryNameLbl.lineBreakMode = NSLineBreakByWordWrapping;
            _beneficaryNameLbl.numberOfLines = 0;
            
            _sendMoneyView.frame = CGRectMake(_sendMoneyView.frame.origin.x, SCREEN_HEIGHT, _sendMoneyView.frame.size.width, _sendMoneyView.frame.size.height);
            
            _deleteView.frame = CGRectMake(_deleteView.frame.origin.x, SCREEN_HEIGHT - _deleteView.frame.size.height, _deleteView.frame.size.width, _deleteView.frame.size.height);
            
        } completion:^(BOOL finished){
            
        }];
    }
}

#pragma mark ######
#pragma mark GEt Beneficiaries List method
#pragma mark ######

-(void)GetBeneficiariesList;
{
    // Get beneficiaries List
    [ Controller GetBeneficiariesListWithSuccess:^(id responseObject){
        
        [HUD removeFromSuperview];
        
    }andFailure:^(NSString *String){
        
        NSLog(@"Received String..%@", String);
        
        NSError *error;
        NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers error:&error];
        
        NSDictionary *payLoadDic = [ json valueForKey:@"PayLoad"];
        BOOL Status = [[ payLoadDic valueForKey:@"status"] boolValue];
        if ( Status == true)
        {
            beneficiaryArray = [ [payLoadDic valueForKey:@"data"] valueForKey:@"beneficiaries"];
            NSLog(@" Beneficiary list Data ..%@", beneficiaryArray);
            
            if ([beneficiaryArray count] != 0)
            {
                _beneficiaryView.hidden = NO;
                _lowerView.hidden = NO;
                _middleView.hidden = NO;
                _beneficiaryBtn.hidden = YES;
                
                [_beneficiaryListTableView reloadData];
            }else{
                _beneficiaryBtn.hidden = NO;
                _beneficiaryView.hidden = YES;
            }

            [_beneficiaryListTableView reloadData];
        }
        else
        {
            if(!String || [String isEqualToString:@"(null)"])
            {
                String = @"Your session has been expired.";
                
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:String delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alertview.tag = 1003;
                
                [alertview show];
            }
            
            [HUD removeFromSuperview];
        }
        
        [HUD removeFromSuperview];
        
    }];
}

#pragma mark ######
#pragma mark Alert methods
#pragma mark ######

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
#pragma mark ######
#pragma mark Call Delete Beneficiary method
#pragma mark ######

- (IBAction)deleteBeneficaryBtn:(id)sender
{
    // Delete beneficary
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userDataDict = [ userDataDict valueForKey:@"User"];
    
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    
    NSString *EncryptKey = [[FBEncryptorAES encryptData:[@"beneficiary_id" dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
    
    EncryptKey= [self URLEncodeStringFromString:EncryptKey];
    
    NSString *EncryptValue = [[FBEncryptorAES encryptData:[selectedBeneficaryID dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
    
    EncryptValue= [self URLEncodeStringFromString:EncryptValue];
    
    NSMutableData *PostData =[[NSMutableData alloc] initWithData:[[NSString stringWithFormat:@"%@=%@",EncryptKey,EncryptValue] dataUsingEncoding:NSUTF8StringEncoding]];
    
//    NSString *ApiUrl = [ NSString stringWithFormat:@"%@/%@", BaseUrl, DeletBeneficary];
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@/%@?%@=%@", BaseUrl, DeletBeneficary,
                        @"beneficiary_id", selectedBeneficaryID];
    NSURL *url = [NSURL URLWithString:ApiUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"PUT";
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request addValue: userTokenString forHTTPHeaderField:@"token"];
    
    [request setHTTPBody:PostData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *receivedData, NSURLResponse *response, NSError *error) {
        
        //if communication was successful
        
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200)
            {
                NSString* resultString= [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
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
                                NSString * errorString =[ responseDic valueForKeyPath:@"PayLoad.error"];
                                
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
                                _sendMoneyView.frame = CGRectMake(_sendMoneyView.frame.origin.x, SCREEN_HEIGHT, _sendMoneyView.frame.size.width, _sendMoneyView.frame.size.height);
                                
                                _deleteView.frame = CGRectMake(_deleteView.frame.origin.x, SCREEN_HEIGHT , _deleteView.frame.size.width, _deleteView.frame.size.height);
                                
                                [ self GetBeneficiariesList];
                                
                            }
                        });
                    });
                }
                else
                {
                    [HUD removeFromSuperview];
                }
            }
        }
        else{
            [HUD removeFromSuperview];
        }
        
    }];
    
    [postDataTask resume];
}

#pragma mark ######
#pragma mark Encode URl APi
#pragma mark ######
- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    // Encode URl
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

#pragma mark ######
#pragma mark Action methods
#pragma mark ######

- (IBAction)SendMoneyBtn:(id)sender
{
    
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userDataDict = [userDataDict valueForKeyPath:@"User"];
    
    if (![[userDataDict valueForKeyPath:@"card.user_id"] isKindOfClass:[NSNull class]])
    //stripe_customerID
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[beneficiaryArray objectAtIndex:index]] forKey:@"beneficiaryUserInfo"];
        [self performSegueWithIdentifier:@"SelectAmount" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"showProfile" sender:self];
    }
}

- (IBAction)backBtnClicked:(id)sender {
    
    // Back button
    [self performSegueWithIdentifier:@"ShowMoney" sender:self];
}

- (IBAction)newBeneficiaryBtn:(id)sender {
    
    // Add Beneficary
    [self performSegueWithIdentifier:@"ShowBeneficiary" sender:self];
}

- (IBAction)plusBtn:(id)sender {
    
    // Add Beneficary
    [self performSegueWithIdentifier:@"ShowBeneficiary" sender:self];
    
}

#pragma mark ######
#pragma mark Table View Methods
#pragma mark ######

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [beneficiaryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    NSDictionary *billerDic = [beneficiaryArray objectAtIndex:indexPath.row];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(10,5, SCREEN_WIDTH-100, 25)];
    userName.textColor = [UIColor blackColor];
    userName.text = [ NSString stringWithFormat:@"%@",[billerDic valueForKeyPath:@"full_name"]];
    userName.lineBreakMode = NSLineBreakByWordWrapping;
    userName.numberOfLines = 0;
    [cell.contentView addSubview:userName];
    userName.font = [UIFont fontWithName:@"MyriadPro-Regular" size:18];
    
    UILabel *ChannelName = [[UILabel alloc] initWithFrame:CGRectMake(10,30, SCREEN_WIDTH-100,15)];
    ChannelName.font = [UIFont fontWithName:@"MyriadPro-Regular" size:9];
    ChannelName.textColor = [UIColor lightGrayColor];
    ChannelName.text = [ NSString stringWithFormat:@"%@",[billerDic valueForKeyPath:@"settlement_channel.title"]];
    ChannelName.textColor = [ UIColor blackColor];
    [cell.contentView addSubview:ChannelName];
    
    UILabel *userCountryname = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40,30,30,15)];
    userCountryname.font = [UIFont fontWithName:@"MyriadPro-Regular" size:9];
    userCountryname.textColor = [UIColor lightGrayColor];
    userCountryname.textColor = [ UIColor blackColor];
    userCountryname.textAlignment = NSTextAlignmentRight;
    userCountryname.text = [ NSString stringWithFormat:@"%@",[billerDic valueForKeyPath:@"country_currency.currency_code"]];
    [cell.contentView addSubview:userCountryname];
    
   
    AsyncImageView *iconImage = [[AsyncImageView alloc] init];
    iconImage.frame = CGRectMake(SCREEN_WIDTH-27,5,15,20);
   NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[billerDic valueForKeyPath:@"country_currency.flag"]];
    
    NSString  *urlStr = [logoimageURl stringByReplacingOccurrencesOfString:@"" withString:@"%20"];

    NSURL * imgUrl = [NSURL URLWithString:urlStr];
    iconImage.imageURL = imgUrl;
    
    NSString * flagName = @"";
    flagName = [logoimageURl lastPathComponent];
    [cell.contentView addSubview:iconImage];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    cell.tag = indexPath.row;
    [cell addGestureRecognizer:tapGestureRecognizer];
    
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.6; //seconds
    [cell addGestureRecognizer:lpgr];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *endLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 0.5)];
    endLabel.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:endLabel];
    return cell;
}

-(void)cellTapped:(UITapGestureRecognizer*)tap
{
    CGPoint location = [tap locationInView:_beneficiaryListTableView];
    NSIndexPath *path = [_beneficiaryListTableView indexPathForRowAtPoint:location];
    index = path.row;
    [timer invalidate];
    beneficiaryDic = [beneficiaryArray objectAtIndex:path.row];
    
    if (_deleteView.frame.origin.y < SCREEN_HEIGHT)
    {
        _deleteView.frame = CGRectMake(_deleteView.frame.origin.x, SCREEN_HEIGHT, _deleteView.frame.size.width, _deleteView.frame.size.height);
    }
    
    _sendMoneyView.frame = CGRectMake(_sendMoneyView.frame.origin.x, SCREEN_HEIGHT, _sendMoneyView.frame.size.width, _sendMoneyView.frame.size.height);
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        _sendingMoneyUserNameLbl.text = [[ NSString stringWithFormat:@"SEND MONEY TO %@?",[beneficiaryDic valueForKeyPath:@"full_name"]]uppercaseString];
        _sendingMoneyUserNameLbl.lineBreakMode = NSLineBreakByWordWrapping;
        _sendingMoneyUserNameLbl.numberOfLines = 0;
        
        _sendMoneyView.frame = CGRectMake(_sendMoneyView.frame.origin.x, SCREEN_HEIGHT-_sendMoneyView.frame.size.height, _sendMoneyView.frame.size.width, _sendMoneyView.frame.size.height);
        
    } completion:nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideSendMoneyView) userInfo:nil repeats:NO];
}
- (void) hideSendMoneyView
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        _sendMoneyView.frame = CGRectMake(_sendMoneyView.frame.origin.x, SCREEN_HEIGHT, _sendMoneyView.frame.size.width, _sendMoneyView.frame.size.height);
        
    } completion:nil];
    
}
#pragma mark ######
#pragma mark Segue method
#pragma mark ######

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSLog(@"segue to Select Amount screen");
//    if([[segue identifier] isEqualToString:@"SelectAmount"]){
//
//        SelectAmountViewController * vc = [segue destinationViewController];
//        vc.beneficiaryUserInfo =   [beneficiaryArray objectAtIndex:index];
//    }
//}

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

@end
