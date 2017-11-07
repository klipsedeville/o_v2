//
//  AddBillerViewController.m
//  MoneyTransfer
//
//  Created by 050 on 20/09/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "AddBillerViewController.h"
#import "BillPayViewController.h"
#import "Constants.h"
#import "Controller.h"
#import "PayBillViewController.h"
#import "AppDelegate.h"
#import "AsyncImageView.h"

@interface AddBillerViewController ()
{
    AppDelegate *appDel;
}
@end

@implementation AddBillerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _billerNameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Biller Name"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
     _firstNameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"First Name"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
     _lastNameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Last Name"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
     _emailAddressTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Email Address"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _phoneNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Phone Number"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
     _physicalAddressTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Physical Address"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _accountNameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Account Name"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _accountNumberTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Account Number"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
     _billNameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Bill Name"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    _billAmountTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Bill Amount"] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    
    _categoryTableView.hidden = YES;
    _locationTableView.hidden = YES;
    _bankTableView.hidden = YES;

    [_scrollView setContentSize:CGSizeMake( SCREEN_WIDTH, 1250)];
    _scrollView.bounces = NO;
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}

-(void)viewWillAppear:(BOOL)animated{
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletap:)];

    [self.scrollView addGestureRecognizer:tapGesture];
    
    // Call get Bills Category
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    [self GetBillsCategory];
    
    //     Call get States list
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    [self GetStatesList1];
    
    //     Call Get List Banks
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    [self GetListBanks];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    // Check user Session Expired or Not
    
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
    _currencyTableView.scrollEnabled = YES;
    allCurrencyArray = [[NSMutableArray alloc]init];
    
    // Add tool bar on number key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];

    _billerNameTextfield.inputAccessoryView = numberToolbar;
    _firstNameTextfield.inputAccessoryView = numberToolbar;
    _lastNameTextfield.inputAccessoryView = numberToolbar;
    _emailAddressTextfield.inputAccessoryView = numberToolbar;
    _phoneNumberTextfield.inputAccessoryView = numberToolbar;
    _physicalAddressTextfield.inputAccessoryView = numberToolbar;
    _accountNameTextfield.inputAccessoryView = numberToolbar;
    _accountNumberTextfield.inputAccessoryView = numberToolbar;
    _billNameTextfield.inputAccessoryView = numberToolbar;
    _billAmountTextfield.inputAccessoryView = numberToolbar;
    
    // Get receving Currency list
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    [self getReceivingCurrencyList];
    
    _currencyView.hidden = NO;
    _currencyTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,60,25) style:UITableViewStylePlain];
    _currencyTableView.layer.cornerRadius = 0.0;
    _currencyTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _currencyTableView.layer.borderWidth= 0.5;
    _currencyTableView.bounces = NO;
    _currencyTableView.delegate=self;
    _currencyTableView.dataSource=self;
    [_currencyTableView setAllowsSelection:YES];
    [_currencyTableView setScrollEnabled:YES];
    [self.currencyView addSubview:_currencyTableView];
    _currencyTableView.backgroundColor=[UIColor grayColor];
    
    _currencyTableView.hidden = YES;
    _locationTableView.hidden = YES;
    _categoryTableView.hidden = YES;
    _bankTableView.hidden = YES;
    
}

-(void)handletap:(UITapGestureRecognizer*)sender
{
    _categoryTableView.hidden = YES;
    _locationTableView.hidden = YES;
    _bankTableView.hidden = YES;
    self.scrollView.scrollEnabled = YES;
}

#pragma  mark ############
#pragma mark Get Receiving Curreny List
#pragma  mark ############
-(void) getReceivingCurrencyList
{
    // Get all Receving Currency list
    [Controller getAllReceivingCurrencyWithSuccess:^(id responseObject){
        
        NSDictionary *Data = [responseObject valueForKey:@"PayLoad"];
        NSDictionary *currencyData = [ Data valueForKey:@"data"];
        allCurrencyArray = [ currencyData valueForKey:@"currencies"];
        NSDictionary *dict = [ allCurrencyArray objectAtIndex:0];
        _currencyIDLbl.text = [ NSString stringWithFormat:@"%@  ",[dict valueForKey:@"currency_code"]];
        selectCountryCode = [dict valueForKey:@"id"];
        selectedCountryName = [dict valueForKey:@"country_name"];
        
        _billAmountImgLabel.text = [dict valueForKey:@"currency_symbol"];
        
        NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[dict valueForKey:@"flag"]];
        
        NSString *imagePath = @"";
        NSString * flagName = @"";
        flagName = [logoimageURl lastPathComponent];
        imagePath = [appDel getImagePathbyflagName:flagName];
        
        if(imagePath.length > 0){
            NSData *img = nil;
            img= [NSData dataWithContentsOfFile:imagePath];
            self.countryImage.image =[UIImage imageWithData:img];
        }
        else
        {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:logoimageURl]];
                
                //this will set the image when loading is finished
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.countryImage.image = [UIImage imageWithData:image];
                    
                    [appDel saveflagsImageToFolder:self.countryImage.image imageName:flagName];
                    [HUD removeFromSuperview];
                });
            });
        }
        
    }andFailure:^(NSString *errorString){
        
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
            alertview.tag = 1002;
            
            [alertview show];
        }
        
        [HUD removeFromSuperview];
        
    }];
}

#pragma  mark ############
#pragma mark Alert method
#pragma  mark ############

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==100)
    {
        if (buttonIndex ==0)
        {
            [ self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    else if(alertView.tag ==1002)
    {
        if (buttonIndex==0)
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                [ _currencyView removeFromSuperview];
                if ([controller isKindOfClass:[LoginViewController class]]) {
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    [self.navigationController setNavigationBarHidden:NO];
                    break;
                }
            }
        }
        
    }
    else if(alertView.tag ==1003)
    {
        if (buttonIndex==0)
        {
            [ _currencyView removeFromSuperview];
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
#pragma mark Click Action Method
#pragma  mark ############

- (IBAction)ActionNextBtn:(id)sender {
    
    //  Call Add Biller
    if ([_billerNameTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Biller name is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([_firstNameTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"First name is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
        [alertview show];
    }
    else if ([_lastNameTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Last name is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([_emailAddressTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Email is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([_phoneNumberTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Phone number is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([_physicalAddressTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Address is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    
    else if ([_accountNameTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Account name is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([_accountNumberTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Account number is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    
    else if  ([_billNameTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Bill title is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([_billAmountTextfield.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Bill amount is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([_selectLocationLbl.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Location is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
    else if ([_selectBankLbl.text length] == 0){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Bank name is required" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
    }
   
    
    else {
    [self resignFirstResponder];
    
    userData = [[NSMutableDictionary alloc]init];

    [userData setValue:_billNameTextfield.text forKey:@"title"];
     [userData setValue:_billAmountTextfield.text forKey:@"amount"];
    [userData setValue:_billerNameTextfield.text forKey:@"biller_name"];
    [userData setValue:_emailAddressTextfield.text forKey:@"email_address"];
   [userData setValue:_phoneNumberTextfield.text forKey:@"phone_number"];
    [userData setValue:_physicalAddressTextfield.text forKey:@"address"];
    [userData setValue:_selectBankLbl.text forKey:@"bank_name"];
    [userData setValue:_accountNameTextfield.text forKey:@"bank_account_name"];
    [userData setValue:_accountNumberTextfield.text forKey:@"bank_account_number"];
    [userData setValue:_firstNameTextfield.text forKey:@"contact_person"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Processing...", nil);
    [HUD show:YES];
    [ self callAddBiller];
    }
}

#pragma mark ######
#pragma  mark Call Add Beneficiary web method
#pragma mark ######

-(void) callAddBiller
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
    
    NSMutableDictionary *dictC = [[NSMutableDictionary alloc]init];
    [dictC setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"title"]] forKey:@"title"];
    [dictC setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"amount"]] forKey:@"amount"];
    [dictC setValue:@"true" forKey:@"allow_any_amount"];

    NSMutableArray *dictBArray = [[NSMutableArray alloc] init];
    dictBArray[0] = dictC;
    
    NSMutableDictionary *dictB = [[NSMutableDictionary alloc]init];
    [dictB setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"title"]] forKey:@"title"];
    [dictB setValue:selectCatID forKey:@"bill_category_id"];
    [dictB setValue: dictBArray forKey:@"bill_options"];

    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
    [dictA setValue:selectCatID forKey:@"bill_category_id"];
    [dictA setValue:selectCountryCode  forKey:@"country_currency_id"];
    [dictA setValue: selectLocID forKey:@"state_id"];
    
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"bank_account_name"]] forKey:@"title"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"email_address"]] forKey:@"email_address"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"phone_number"]] forKey:@"phone_number"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"address"]] forKey:@"address"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"bank_name"]] forKey:@"bank_id"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"bank_account_name"]] forKey:@"bank_account_name"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"bank_account_number"]] forKey:@"bank_account_number"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"contact_person"]] forKey:@"contact_person"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"email_address"]] forKey:@"contact_person_email_address"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"phone_number"]] forKey:@"contact_person_phone_number"];
    [dictA setValue:[NSString stringWithFormat:@"%@",[userData valueForKey:@"address"]] forKey:@"contact_person_address"];
    
    NSMutableArray *dictAArray = [[NSMutableArray alloc] init];
    dictAArray[0] = dictB;
    
    [dictA setValue:dictAArray forKey:@"bills"];
    
    NSDictionary *headers = @{ @"token": userTokenString,
                               @"cache-control": @"no-cache",
                               @"postman-token": @"e052d2a7-928b-0406-a9a6-d859b881496c",
                               @"content-type": @"application/x-www-form-urlencoded" };
    
    NSMutableData *postData1 = [[NSMutableData alloc] initWithData:[[ NSString stringWithFormat:@"%@=%@",@"",dictA] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [  NSMutableURLRequest requestWithURL:[NSURL
                                                                          
                                                                          URLWithString: [NSString stringWithFormat:@"%@%@" ,BaseUrl, RecommendBiller]]
                                    
                                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                         timeoutInterval:10.0];
    
    [request setHTTPMethod: @"POST"];
    [request setAllHTTPHeaderFields:headers];
//    [request setHTTPBody:postData1];
    
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
                                                                                errorString = @"Your session has been expired.";
                                                                                
                                                                                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
                                                                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Great!" message:@"Your biller information has been received and will be available to accept bill payments within 48hrs." delegate:self cancelButtonTitle:@"Continue" otherButtonTitles: nil];
                                                                            
                                                                            alertview.tag = 100;                         [alertview show];
                                                                            [HUD removeFromSuperview];
                                                                            
                                                                        }
                                                                    });
                                                                });
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                }];
    [dataTask resume];
}

- (IBAction)currencyBtnClicked:(id)sender
{
    // Currency button
    if (allCurrencyArray == NULL)
    {
        _currencyTableView.hidden = YES;
    }
    else if (_currencyTableView.hidden == YES) {
            _currencyView.frame = CGRectMake(SCREEN_WIDTH/2-_currencyView.frame.size.width/2, 38, 90, 25);
            _currencyTableView.frame =CGRectMake(0,0,60,25*(allCurrencyArray.count));
            
            _currencyTableView.hidden = NO;
        [_currencyTableView reloadData];
    }
    else{
        _currencyTableView.hidden = YES;
    }
    _currencyTableView.scrollEnabled = YES;
}



- (void)viewDidLayoutSubviews
{
    [_scrollView setContentSize:CGSizeMake( SCREEN_WIDTH, _lastView.frame.origin.y+_lastView.frame.size.height+50)];

    _scrollView.bounces = NO;
}


- (IBAction)backBtnClicked:(id)sender {
    
    // back button
    [self performSegueWithIdentifier:@"BillPaySegue" sender:self];
}

- (IBAction)ActionSelectBillerCategory:(id)sender {
    [self cancelNumberPad];
    UIView *tempVW = [[ UIView alloc] init];
    tempVW.frame = CGRectMake(_categoryView.frame.origin.x, _categoryView.frame.origin.y, _categoryView.frame.size.width, _categoryView.frame.size.height );
    [self scrollViewToCenterOfScreen:tempVW];
    
    _categoryTableView.hidden = NO;
    _locationTableView.hidden = YES;
    _bankTableView.hidden = YES;
    
  [_categoryTableView setContentSize:CGSizeMake( _selectBillerCategoryLbl.frame.size.width, _categoryTableView.frame.size.height)];
    [_categoryTableView reloadData];
    }

- (IBAction)ActionSelectLocation:(id)sender {
    [self cancelNumberPad];
    UIView *tempVW = [[ UIView alloc] init];
    tempVW.frame = CGRectMake(_locationView.frame.origin.x, _locationView.frame.origin.y, _locationView.frame.size.width, _locationView.frame.size.height );
    [self scrollViewToCenterOfScreen:tempVW];
  
    [_locationTableView setContentSize:CGSizeMake( _selectLocationLbl.frame.size.width,_locationTableView.frame.size.height)];
    
    _locationTableView.hidden = NO;
    _categoryTableView.hidden = YES;
    _bankTableView.hidden = YES;
    
    [_locationTableView reloadData];
}

- (IBAction)ActionSelectBank:(id)sender {
    [self cancelNumberPad];
    
    _locationTableView.hidden = YES;
    _categoryTableView.hidden = YES;
    _bankTableView.hidden = NO;
    
    UIView *tempVW = [[ UIView alloc] init];
    tempVW.frame = CGRectMake(_bankView.frame.origin.x, _bankView.frame.origin.y, _bankView.frame.size.width, _bankView.frame.size.height );
     [_bankTableView setContentSize:CGSizeMake( _selectBankLbl.frame.size.width,_bankTableView.frame.size.height)];
    [self scrollViewToCenterOfScreen:tempVW];
    [_bankTableView reloadData];
}

#pragma  mark ############
#pragma mark Table View Method
#pragma  mark ############

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 40;
    }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _currencyTableView) {
    
        cell.backgroundColor = [self colorWithHexString:@"073245"];
    }
    else{

        cell.backgroundColor = [UIColor whiteColor];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _currencyTableView) {
    
        return [allCurrencyArray count];
    }
    else if (tableView == _categoryTableView) {
        return [categoryArray count];
    }
    
    else if (tableView == _locationTableView) {
            return [locationArray count];
    }
    else if (tableView == _bankTableView) {
            return [bankArray count];
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell;

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    if(tableView == _currencyTableView)
    {
        [_currencyTableView setSeparatorColor:[UIColor clearColor]];
        
        NSDictionary *dict;
        dict = [allCurrencyArray objectAtIndex:indexPath.row];
        
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 50, 30)];
    
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:11]];
    titleLabel.text = [dict valueForKey:@"currency_code"];
    [cell.contentView addSubview:titleLabel];
    
        
        AsyncImageView *iconImage = [[AsyncImageView alloc] init];
        iconImage.frame = CGRectMake(5,5,15,15);
        NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[dict valueForKey:@"flag"]];
        
        NSString  *urlStr = [logoimageURl stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
        
        NSURL * imgUrl = [NSURL URLWithString:urlStr];
        iconImage.imageURL = imgUrl;
        
        NSString * flagName = @"";
        flagName = [logoimageURl lastPathComponent];
        [cell.contentView addSubview:iconImage];
        
    }
    else if (tableView == _categoryTableView) {
       cell.textLabel.text = [NSString stringWithFormat:@"%@", categoryArray[indexPath.row]];

        [cell.textLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:17]];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:(218/255.0) green:(218/255.0) blue:(218/255.0) alpha:1.0];
    }
    
    else if (tableView == _locationTableView) {
         cell.textLabel.text = [NSString stringWithFormat:@"%@", locationArray[indexPath.row]];
        
        [cell.textLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:17]];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:(218/255.0) green:(218/255.0) blue:(218/255.0) alpha:1.0];
    }
    else if (tableView == _bankTableView){
         cell.textLabel.text = [NSString stringWithFormat:@"%@", bankArray[indexPath.row]];
        [cell.textLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:17]];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:(218/255.0) green:(218/255.0) blue:(218/255.0) alpha:1.0];
    }
       return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _currencyTableView)
    {
        NSDictionary *dict = [ allCurrencyArray objectAtIndex:indexPath.row];
        _currencyIDLbl.text = [ NSString stringWithFormat:@"%@   ",[dict valueForKey:@"currency_code"]];
        selectCountryCode = [dict valueForKey:@"id"];
        
        selectedCountryName = [dict valueForKey:@"country_name"];
        
        NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[dict valueForKey:@"flag"]];
        
        dispatch_queue_t concurrentQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue1, ^{
            
            UIImage *image = nil;
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoimageURl]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *img=[[UIImageView alloc]init];
                img.image=image;
                [self.countryImage setImage:image];
                [HUD removeFromSuperview];
            });
        });
        selectCountryID = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        _currencyTableView.hidden = YES;
        
    }
    else if (tableView == _categoryTableView) {
        _selectBillerCategoryLbl.text = [NSString stringWithFormat:@"%@", categoryArray[indexPath.row]];
        selectCatID = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        _categoryTableView.hidden = YES;
    }
    
    else if (tableView == _locationTableView) {
        _selectLocationLbl.text = [NSString stringWithFormat:@"%@", locationArray[indexPath.row]];
        selectLocID = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        _locationTableView.hidden = YES;
    }
    else if (tableView == _bankTableView){
        _selectBankLbl.text = [NSString stringWithFormat:@"%@", bankArray[indexPath.row]];
        selectBankID = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        _bankTableView.hidden = YES;
    }

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

#pragma mark ###########
#pragma mark - Text Fields Deletgate methods
#pragma mark ###########

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _categoryTableView.hidden = YES;
    _locationTableView.hidden = YES;
    _bankTableView.hidden = YES;
   [_scrollView setContentSize:CGSizeMake( SCREEN_WIDTH, _lastView.frame.origin.y+_lastView.frame.size.height+50)];
    if (textField == _billerNameTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_billerNameTextfield.frame.origin.x, _billerView.frame.origin.y, _billerNameTextfield.frame.size.width, _billerNameTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _firstNameTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_firstNameTextfield.frame.origin.x, _nameView.frame.origin.y, _firstNameTextfield.frame.size.width, _firstNameTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    
    else if (textField == _lastNameTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_lastNameTextfield.frame.origin.x, _nameView.frame.origin.y, _lastNameTextfield.frame.size.width, _lastNameTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _emailAddressTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_emailAddressTextfield.frame.origin.x, _emailView.frame.origin.y, _emailAddressTextfield.frame.size.width, _emailAddressTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _phoneNumberTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_phoneNumberTextfield.frame.origin.x, _numberView.frame.origin.y, _phoneNumberTextfield.frame.size.width, _phoneNumberTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
else if (textField == _physicalAddressTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_physicalAddressTextfield.frame.origin.x, _addressView.frame.origin.y, _physicalAddressTextfield.frame.size.width, _physicalAddressTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _accountNameTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_accountNameTextfield.frame.origin.x, _accNameView.frame.origin.y, _accountNameTextfield.frame.size.width, _accountNameTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _accountNumberTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_accountNumberTextfield.frame.origin.x, _accountNumberView.frame.origin.y, _accountNumberTextfield.frame.size.width, _accountNumberTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _billNameTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_billNameTextfield.frame.origin.x, _billNameView.frame.origin.y, _billNameTextfield.frame.size.width, _billNameTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _billAmountTextfield)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_billAmountTextfield.frame.origin.x, _lastView.frame.origin.y, _billAmountTextfield.frame.size.width, _billAmountTextfield.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
   _scrollView.bounces = NO;
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

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat availableHeight = applicationFrame.size.height - 350; // Remove area covered by keyboard
    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }
    [_scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

-(void)keyboardWillHide
{
    [_scrollView setContentSize:CGSizeMake( SCREEN_WIDTH, _lastView.frame.origin.y+_lastView.frame.size.height+50)];
    _scrollView.bounces = NO;

    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)cancelNumberPad{
    [self.view endEditing:YES];
    [_scrollView setContentSize:CGSizeMake( SCREEN_WIDTH, _lastView.frame.origin.y+_lastView.frame.size.height+50)];
    _scrollView.bounces = NO;
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)doneWithNumberPad{
    [self.view endEditing:YES];
    [_scrollView setContentSize:CGSizeMake( SCREEN_WIDTH, _lastView.frame.origin.y+_lastView.frame.size.height+50)];
    _scrollView.bounces = NO;
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark ##########
#pragma mark Get Bills List With Currency ID
#pragma mark ##########

-(void)GetStatesList1
{
    // Get bill states list
    
    [Controller GetBillStatesListByCountryID:@"154" withSuccess:^(id responseObject)
     {
         [HUD removeFromSuperview];
     }andFailure:^(NSString *String){
         
         NSLog(@"State String..%@", String);
         NSError *error;
         NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers error:&error];
         
         NSDictionary *payLoadDic = [ json valueForKey:@"PayLoad"];
         BOOL Status = [ [payLoadDic valueForKey:@"status"]boolValue];
         
         if ( Status  == YES)
         {
             locationArray= [ payLoadDic valueForKeyPath:@"data.states.title"];
             [_locationTableView reloadData];

             [HUD removeFromSuperview];
             
         }
         else{
             [HUD removeFromSuperview];
             NSArray *errorArray =[ payLoadDic valueForKeyPath:@"PayLoad.error"];
             
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
         
     }];
}

#pragma  mark ############
#pragma mark Get Bill category list
#pragma  mark ############

-(void)GetBillsCategory
{
    // Get bill categry
    [Controller getBillsCategoriesWithSuccess:^(id responseObject)
     {
         [HUD removeFromSuperview];
     }andFailure:^(NSString *String){
         
         NSLog(@"Bills String..%@", String);
         NSError *error;
         NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers error:&error];
         
         NSDictionary *payLoadDic = [ json valueForKey:@"PayLoad"];
         BOOL Status = [ [payLoadDic valueForKey:@"status"]boolValue];
         
         if ( Status  == YES)
         {
             //             int x = 0;
             categoryArray= [ payLoadDic valueForKeyPath:@"data.categories.title"];

             [_categoryTableView reloadData];

             [HUD removeFromSuperview];
             
                     }
         else{
             [HUD removeFromSuperview];
             NSArray *errorArray =[ payLoadDic valueForKeyPath:@"PayLoad.error"];
             
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
         
     }];
}

#pragma  mark ############
#pragma mark Get List Banks
#pragma  mark ############

-(void)GetListBanks
{
    // Get bill states list
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    userDataDict = [ userDataDict valueForKey:@"User"];
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    NSMutableData *PostData;
    
    NSString *ApiUrl = [ NSString stringWithFormat: @"%@%@?%@=%@" ,BaseUrl, ListBanks, @"currency_id", @"154"];
    ApiUrl = [ApiUrl stringByReplacingOccurrencesOfString:@"\x10" withString:@""];
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
                
                NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
                id responseDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                 NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"]integerValue];
                
                if (status == 0)
                    {
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
                    }
                    else
                    {
                        [HUD removeFromSuperview];
                        NSLog(@"Bank String..%@",responseDic );

                        bankArray= [ responseDic valueForKeyPath:@"PayLoad.data.banks.title"];
                        [_bankTableView reloadData];
                        
                        [HUD removeFromSuperview];

                    }
            }
            else{
                [HUD removeFromSuperview];
            }
        }
        
    }];
    
    [postDataTask resume];
}


@end
