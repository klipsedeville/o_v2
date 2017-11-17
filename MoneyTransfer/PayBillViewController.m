 //
//  PayBillViewController.m
//  MoneyTransfer
//
//  Created by apple on 23/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "PayBillViewController.h"
#import "Controller.h"
#import "ConfirmPaymentViewController.h"
#import "Constants.h"
#import "LoginViewController.h"
#import "CCTextFieldEffects.h"

@interface PayBillViewController ()

@end

@implementation PayBillViewController

#pragma mark ###########
#pragma mark - View Life Cycle methods
#pragma mark ###########

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    _billUserData = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"PayBillDetail"]];
    _amountHeadingLbl.text = [NSString stringWithFormat:@"Amount (%@)",[_billUserData valueForKeyPath:@"bill_provider.country_currency.currency_symbol"]];
    isNumberKeypad = NO;
    
    self.billOptionTableView.dataSource = self;
    self.billOptionTableView.delegate = self;
    
    self.billOptionTableView.layer.cornerRadius = 0.0;
    self.billOptionTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.billOptionTableView.layer.borderWidth= 0.5;
    self.billOptionTableView.bounces = NO;
    self.amountTextField.delegate = self;
    
    PaymentUserData = [[NSMutableDictionary alloc]init];
    _scrollView.bounces = NO;
    
    
    // Check user Session Expired Or not
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
    
    requiredFldArray = [[NSMutableArray alloc] init];
    billOptionDict = [[NSMutableDictionary alloc] init];
    DataArray = [[NSMutableArray alloc]init];
    billOptionArray = [[NSMutableArray alloc]init];
    
    _amountLbl.userInteractionEnabled = YES;
    _amountLbl.tag = 1;
    
    // Bottom border
    amountLayer = [CALayer layer];
    amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
    amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.amountTextField.layer addSublayer:amountLayer];
    _amountHeadingLbl.hidden = YES;
    
    UITapGestureRecognizer *tapGestureAmount = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    [self.amountLbl addGestureRecognizer:tapGestureAmount];
    
    billOptionArray = [_billUserData valueForKeyPath:@"bill_options.title"];
        _billOptionLbl.text = [billOptionArray objectAtIndex:0];
    
        if (billOptionArray.count>0) {
            float height = 40;
            height = height* billOptionArray.count;
    
            if (height> 160) {
                self.billOptionTableView.frame = CGRectMake(self.billOptionTableView.frame.origin.x, self.billOptionTableView.frame.origin.y, self.billOptionTableView.frame.size.width,160 );
    
            }
            else{
                self.billOptionTableView.frame = CGRectMake(self.billOptionTableView.frame.origin.x, self.billOptionTableView.frame.origin.y, self.billOptionTableView.frame.size.width,height );
            }
        }
    NSArray *amountArr = [_billUserData valueForKeyPath:@"bill_options"];
    NSString *amountstr = [[amountArr objectAtIndex:0]valueForKey:@"amount"];
    
    
    _amountLbl.hidden = YES;
    _amountHeadingLbl.hidden = NO;
    _amountTextField.text = [NSString stringWithFormat:@"%.2f",[[[amountArr objectAtIndex:0]valueForKey:@"amount"] floatValue]];
    
    if ( !([_amountTextField.text isEqualToString:@"0.00"]|| [_amountTextField.text  isEqualToString:@""])) {
        _amountTextField.userInteractionEnabled = false;
        
    }
    if ( !([_amountTextField.text containsString:@".00"])) {
          _amountTextField.text = [_amountTextField.text stringByAppendingString:@".00"];
    }
    
    billOptionID =[ NSString stringWithFormat:@"%@",[[amountArr objectAtIndex:0] valueForKey:@"id"]];
    _descriptionLabel.text = [ NSString stringWithFormat:@"%@",[_billUserData valueForKeyPath:@"bill_provider.title"]];
    _navigationTitleTextField.text = @"Bill Details";
    _billNameLbl.text = [[amountArr objectAtIndex:0] valueForKeyPath:@"title"];
    _billOptionLbl.text = [NSString stringWithFormat:@"%@",[billOptionArray objectAtIndex:0]];
    
    // -----------------------  Dynamic view  --------------------------------------
    
    
    NSArray *requiredFieldArray = [_billUserData valueForKey:@"bill_required_fields"];
    
    [requiredInfoView removeFromSuperview];
   
    requiredInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, _amountView.frame.origin.y+_amountView.frame.size.height +17 , SCREEN_WIDTH, 50)];
    requiredInfoView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:requiredInfoView];
    
    UILabel *requiredInfoTitleLbl = [[UILabel alloc] init];
    requiredInfoTitleLbl.frame = CGRectMake(10, 15, SCREEN_WIDTH-20, 20);
    requiredInfoTitleLbl.text = @"REQUIRED INFORMATION";
    requiredInfoTitleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16];
    requiredInfoTitleLbl.textColor = [self colorWithHexString:@"51595c"];
    [requiredInfoView addSubview:requiredInfoTitleLbl];
    
    if (requiredFieldArray.count >0)
    {
        [requiredInfoView removeFromSuperview];
        requiredInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, _amountView.frame.origin.y+_amountView.frame.size.height +17 , SCREEN_WIDTH, (requiredFieldArray.count * 60) + 50)];
        requiredInfoView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:requiredInfoView];
        
        UILabel *requiredInfoTitleLbl = [[UILabel alloc] init];
        requiredInfoTitleLbl.frame = CGRectMake(10, 15, SCREEN_WIDTH-20, 20);
        requiredInfoTitleLbl.text = @"REQUIRED INFORMATION";
        requiredInfoTitleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16];
        requiredInfoTitleLbl.textColor = [self colorWithHexString:@"51595c"];
        [requiredInfoView addSubview:requiredInfoTitleLbl];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,requiredInfoTitleLbl.frame.size.height+requiredInfoTitleLbl.frame.origin.y + 5,SCREEN_WIDTH-20,1)];
        lineView.backgroundColor=[self colorWithHexString:@"51595c"];
        [requiredInfoView addSubview:lineView];
        
        
        for(int i=0; i<[requiredFieldArray count]; i++)
        {
            NSDictionary *tempDict = [requiredFieldArray objectAtIndex:i];
            NSString * placeholderString = [[tempDict valueForKey:@"title"] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            
            NSString *typeStr = [tempDict valueForKeyPath:@"bill_field_type.type"];
            
            if([typeStr isEqualToString:@"text"])
            {
                HoshiTextField *parameterTextField = [[HoshiTextField alloc] initWithFrame:CGRectMake(10.0f, 50+(i*55), SCREEN_WIDTH-20, 40.0f)];
                
                parameterTextField.placeholder = [placeholderString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[placeholderString substringToIndex:1] uppercaseString]];
                
                
                // The size of the placeholder label relative to the font size of the text field, default value is 0.65
                parameterTextField.placeholderFontScale = 1;
                
                // The color of the inactive border, default value is R185 G193 B202
                parameterTextField.borderInactiveColor = [self colorWithHexString:@"51595c"];
                
                // The color of the active border, default value is R106 B121 B137
                parameterTextField.borderActiveColor = [self colorWithHexString:@"3ec6f0"];
                
                // The color of the placeholder, default value is R185 G193 B202
                parameterTextField.placeholderColor = [self colorWithHexString:@"51595c"];
                
                // The color of the cursor, default value is R89 G95 B110
                parameterTextField.cursorColor = [self colorWithHexString:@"3ec6f0"];
                
                // The color of the text, default value is R89 G95 B110
                parameterTextField.textColor = [UIColor blackColor];
                
                parameterTextField.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16];
                
                parameterTextField.delegate = self;
                
                
                // The block excuted when the animation for obtaining focus has completed.
                // Do not use textFieldDidBeginEditing:
                parameterTextField.didBeginEditingHandler = ^{
                };
                
                // The block excuted when the animation for losing focus has completed.
                // Do not use textFieldDidEndEditing:
                parameterTextField.didEndEditingHandler = ^{
                    
                    // ...
                };
                
                [requiredInfoView addSubview:parameterTextField];
                
                NSMutableDictionary *fieldDic = [[ NSMutableDictionary alloc] init];
                [fieldDic setObject: parameterTextField forKey:@"reqFldTextField"];
                [fieldDic setObject: [tempDict valueForKey:@"id"] forKey:@"reqFldID"];
                [fieldDic setObject: parameterTextField.placeholder forKey:@"placeHolder"];
                
                [requiredFldArray addObject:fieldDic];
                
            }
            else if([typeStr isEqualToString:@"select"])
            {
                NSString *optionsString = [tempDict valueForKey:@"select_options"];
                
                NSArray * billSelectOptionArray = [optionsString componentsSeparatedByString:@";"];
                
                requiredInfoView.frame = CGRectMake(requiredInfoView.frame.origin.x, requiredInfoView.frame.origin.y, requiredInfoView.frame.size.width, requiredInfoView.frame.size.height+30);
                
                UILabel *titleLbl = [[UILabel alloc] init];
                titleLbl.frame = CGRectMake(10, (i*75)+50, SCREEN_WIDTH-20, 20);
                titleLbl.text = [NSString stringWithFormat:@"Select a %@",[[tempDict valueForKey:@"title"] stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
                titleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:15];
                titleLbl.textColor = [self colorWithHexString:@"51595c"];
                [requiredInfoView addSubview:titleLbl];
                
                UIButton *genderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [genderBtn addTarget:self action:@selector(genderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [genderBtn setFrame:CGRectMake(10.0f, titleLbl.frame.origin.y + titleLbl.frame.size.height + 5, SCREEN_WIDTH-20, 40.0f)];
                genderBtn.tag = 100+i;
                [requiredInfoView addSubview:genderBtn];
                
                UILabel *genderTitleLbl = [[UILabel alloc] init];
                genderTitleLbl.frame = CGRectMake(0, 0, genderBtn.frame.size.width, genderBtn.frame.size.height);
                genderTitleLbl.text = [billSelectOptionArray objectAtIndex:0];
                genderTitleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:16];
                genderTitleLbl.textColor = [self colorWithHexString:@"51595c"];
                genderTitleLbl.tag = 200+i;
                [genderBtn addSubview:genderTitleLbl];
                
                UIImageView * downArrow = [[UIImageView alloc] init];
                downArrow.frame = CGRectMake(genderBtn.frame.size.width-20, 10, 10, 10);
                downArrow.image = [UIImage imageNamed:@"downArrow.png"];
                [genderBtn addSubview:downArrow];
                
                NSMutableDictionary *fieldDic = [[ NSMutableDictionary alloc] init];
                [fieldDic setObject: genderTitleLbl forKey:@"reqFldTextField"];
                [fieldDic setObject: [tempDict valueForKey:@"id"] forKey:@"reqFldID"];
                [fieldDic setObject: placeholderString forKey:@"placeHolder"];
                
                [requiredFldArray addObject:fieldDic];
                
                
                [billOptionDict setObject:billSelectOptionArray forKey:[NSString stringWithFormat:@"%ld",(long)genderBtn.tag]];
            }
        }
        
        float sizeOfContent = 0;
        NSInteger wd = requiredInfoView.frame.origin.y;
        NSInteger ht = requiredInfoView.frame.size.height+20;
        sizeOfContent = wd+ht;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    }
    
    // Add tool bar on number key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _amountTextField.inputAccessoryView = numberToolbar;
    // Guesture
    UITapGestureRecognizer *gueture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handletap:)];
    gueture.delegate = self;
    [self.view addGestureRecognizer:gueture];
    
}

-(void)handletap:(UITapGestureRecognizer*)sender
{
    [genderTableView setHidden:YES];
    self.scrollView.scrollEnabled = YES;
}
-(void)cancelNumberPad{
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}

-(void)genderBtnAction : (UIButton *)sender
{
    currentTag = (int)sender.tag;
    [self.view endEditing:YES];
    [genderTableView removeFromSuperview];
    NSArray * billSelectOptionArray = [billOptionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    
    genderTableView=[[UITableView alloc]initWithFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + requiredInfoView.frame.origin.y + sender.frame.size.height - (billSelectOptionArray.count*40) , sender.frame.size.width-22, billSelectOptionArray.count*40 ) style:UITableViewStylePlain];
    
    if(genderTableView.frame.origin.y < 0)
    {
        float height = genderTableView.frame.origin.y;
        
        genderTableView.frame = CGRectMake(genderTableView.frame.origin.x, 5, genderTableView.frame.size.width, (genderTableView.frame.size.height + height)-5 );
    }
    
    genderTableView.delegate=self;
    genderTableView.dataSource=self;
    [genderTableView setAllowsSelection:YES];
    [genderTableView setScrollEnabled:YES];
    [_scrollView addSubview:genderTableView];
    
    genderTableView.backgroundColor=[UIColor lightGrayColor];
    genderTableView.layer.cornerRadius = 0.0;
    genderTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    genderTableView.layer.borderWidth= 0.5;
    genderTableView.bounces = NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.billOptionTableView]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:genderTableView]) {
        return NO;
    }
    
    _billOptionTableView.hidden = YES;
    genderTableView.hidden = YES;
    
    return YES;
}

#pragma mark ########
#pragma mark Click Action Method
#pragma mark ########

- (IBAction)backBtnClicked:(id)sender {
    
    // Back button
    [ self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)billOptionBtn:(id)sender {
    
    // Bill Option
    if ([billOptionArray count] == 0 )
    {
        _billOptionTableView.hidden = YES;
    }
    else if (_billOptionTableView.hidden == YES) {
        _billOptionTableView.hidden = NO;
        [_billOptionTableView reloadData];
        
        [ _amountTextField resignFirstResponder];
        
    }
    else{
        _billOptionTableView.hidden = NO;
    }
    
    [_scrollView sendSubviewToBack: requiredInfoView];
}

- (IBAction)payBillBtn:(id)sender {
    
    // pay Bill button
    if(_amountTextField.text.length==0 || [_amountTextField.text isEqualToString:@"0.00"])
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Enter an amount" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
        
        return;
    }
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSString *billID =[ NSString stringWithFormat:@"%@", [_billUserData valueForKeyPath:@"bill_provider.bill_category_id"]];
    
    for ( NSDictionary *fieldDic in requiredFldArray) {
        
        NSString *textString;
        
        if([[ fieldDic objectForKey:@"reqFldTextField"] isKindOfClass:[HoshiTextField class]])
        {
            HoshiTextField *fldText = [ fieldDic objectForKey:@"reqFldTextField"];
            textString = [fldText.text stringByTrimmingCharactersInSet:whitespace];
        }
        else
        {
            UILabel *fldText = [ fieldDic objectForKey:@"reqFldTextField"];
            textString = [fldText.text stringByTrimmingCharactersInSet:whitespace];
        }
        
        if(textString.length==0)
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:[NSString stringWithFormat:@"%@ is required",[ fieldDic objectForKey:@"placeHolder"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertview show];
            
            return;
        }
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
        [ dict1 setObject:billID forKey:@"bill_id"];
        [ dict1 setObject:[fieldDic valueForKey:@"reqFldID"] forKey:@"bill_required_field_id"];
        [ dict1 setObject:textString forKey:@"collected_data"];
        [DataArray addObject:dict1];
        
    }
    [PaymentUserData setValue:_billOptionLbl.text forKey:@"option_name"];
    [PaymentUserData setValue:_amountTextField.text forKey:@"amount"];
    [PaymentUserData setValue:billOptionID forKey:@"bill_optionID"];
    [self performSegueWithIdentifier:@"confirmpayment" sender:self];
}

#pragma mark ########
#pragma mark Call pay bill methods
#pragma mark ########

-(void)callPayBill
{
    
    // call pay bill
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
    [dictA setValue:[NSString stringWithFormat:@"%@",[_billUserData valueForKeyPath:@"bill_category_id"]] forKey:@"bill_id"];
    [dictA setValue:billOptionID forKey:@"bill_option_id"];
    [dictA setValue:_amountTextField.text forKey:@"amount"];
    
//    [dictA setValue:billOptionID forKey:@"exchange_rate"];
//    [dictA setValue:billOptionID forKey:@"fee"];
//    [dictA setValue:billOptionID forKey:@"sending_amount"];
//    [dictA setValue:billOptionID forKey:@"receiving_amount"];
//    [dictA setValue:billOptionID forKey:@"bill_option_id"];
//    [dictA setValue:billOptionID forKey:@"bill_option_id"];
//    
//    NSMutableDictionary *dictB = [[NSMutableDictionary alloc]init];
//    [dictB setValue:[NSString stringWithFormat:@"%@",[_billUserData valueForKeyPath:@"bill_category_id"]] forKey:@"bill_id"];
//    [dictB setValue:@"" forKey:@"bill_required_field_id"];
//    [dictB setValue:@"" forKey:@"collected_data"];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:dictA, @"bill_payment", DataArray, @"bill_collected_field", nil] options:NSJSONWritingPrettyPrinted error:nil];
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
                            alertview.tag = 1002;
                            
                            [alertview show];
                        }
                        
                        
                    }
                    else
                    {
                        [HUD removeFromSuperview];
                        [PaymentUserData setValue:_billOptionLbl.text forKey:@"option_name"];
                        [PaymentUserData setValue:_amountTextField.text forKey:@"amount"];
                        [PaymentUserData setValue:billOptionID forKey:@"bill_optionID"];
                        
                        NSLog(@"Transfer request...%@",responseDic );
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"confirmpayment" sender:self];
                        });
                    }
                }
            }
            else{
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Connection failed. Please make sure you have an active internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertview show];
            }
        }
        else{
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
        }
    }];
    [postDataTask resume];
}

#pragma mark ########
#pragma mark Alert  methods
#pragma mark ########

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
    else if(alertView.tag ==1003)
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

#pragma mark ###########
#pragma mark - Table View Method
#pragma mark ###########

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _billOptionTableView) {
        return [billOptionArray count];
    }
    else
    {
        NSArray * billSelectOptionArray = [billOptionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)currentTag]];
        
        return [billSelectOptionArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    if(tableView == _billOptionTableView)
    {
        cell.textLabel.text = [billOptionArray objectAtIndex:indexPath.row];
    }
    else
    {
        NSArray * billSelectOptionArray = [billOptionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)currentTag]];
        
        cell.textLabel.text = [billSelectOptionArray objectAtIndex:indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _billOptionTableView)
    {
        _billOptionLbl.text = [NSString stringWithFormat:@"%@",[billOptionArray objectAtIndex:indexPath.row]];
        
        NSArray *BilloptionArray = [_billUserData valueForKey:@"bill_options"];
        _amountHeadingLbl.hidden = NO;
        _amountLbl.hidden = YES;
        
        _amountTextField.text =[ NSString stringWithFormat:@"%@",[[BilloptionArray objectAtIndex:indexPath.row] valueForKey:@"amount"]];
        
        billOptionID =[ NSString stringWithFormat:@"%@",[[BilloptionArray objectAtIndex:indexPath.row]valueForKey:@"id"]];
        
        _billOptionTableView.hidden = YES;
        
        NSLog(@"Amount text ..%@", _amountTextField.text);
        
        if (!([ _amountTextField.text isEqualToString:@"0.00"] || [ _amountTextField.text isEqualToString:@""])) {
            _amountTextField.userInteractionEnabled = false;
        }
        else{
            _amountTextField.userInteractionEnabled = true;
        }
    }
    else if(tableView == genderTableView)
    {
        UILabel *label = (UILabel *)[self.view viewWithTag:currentTag+100];
        
        NSArray * billSelectOptionArray = [billOptionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)currentTag]];
        
        label.text = [NSString stringWithFormat:@"%@",[billSelectOptionArray objectAtIndex:indexPath.row]];
        
        genderTableView.hidden = YES;
    }
}

#pragma mark ###########
#pragma mark - Guesture Recogniser Method
#pragma mark ###########

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)DidRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    UILabel *label = (UILabel*)[gesture view];
    if ( label.tag == 1)
    {
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        amountLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        
    }
}
#pragma mark ###########
#pragma mark - Text Fields Deletgate methods
#pragma mark ###########

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    genderTableView.hidden = YES;
    NSLog(@"textfield y %f",textField.frame.origin.y + requiredInfoView.frame.origin.y);
    [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width,_scrollView.contentSize.height + 200)];
    
    if([textField.superview isEqual:requiredInfoView] )
    {
        if(textField.frame.origin.y + requiredInfoView.frame.origin.y > 195)
        {
            UIView *tempVW = [[ UIView alloc] init];
            
            tempVW.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y+350, textField.frame.size.width, textField.frame.size.height );
            [self scrollViewToCenterOfScreen:tempVW];
        }
    }
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    
    NSString *amountno = [self.amountTextField.text stringByTrimmingCharactersInSet:whitespace];
    if (textField == _amountTextField)
    {
        isNumberKeypad = YES;
        
        UIView *tempVW = [[ UIView alloc] init];
        
        tempVW.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y+50, textField.frame.size.width, textField.frame.size.height );
        
        [self scrollViewToCenterOfScreen:tempVW];
        
        if ([ amountno isEqualToString:@"0.00"]|| [amountno isEqualToString:@""])
        {
            _amountTextField.userInteractionEnabled = true;
            _amountTextField.text = @"";
        }
        _amountHeadingLbl.textColor= [self colorWithHexString:@"51595c"];
        UIColor *color = [self colorWithHexString:@"51595c"];
        
        _amountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0.00" attributes:@{NSForegroundColorAttributeName: color}];
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        
        amountLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([ _amountTextField.text isEqual:@""]) {
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        [_amountTextField resignFirstResponder];
    }
    else
    {
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        
        _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
    }
    
    isNumberKeypad = NO;
    float sizeOfContent = 0;
    NSInteger wd = requiredInfoView.frame.origin.y;
    NSInteger ht = requiredInfoView.frame.size.height;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 350; // Remove area covered by keyboard
    
    CGFloat y = viewCenterY - availableHeight ;
    if (y < 0) {
        y = 0;
    }
    [_scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

#pragma mark ########
#pragma mark Segue methods
#pragma mark ########

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue to Beneficiary screen");
    if([[segue identifier] isEqualToString:@"confirmpayment"])
    {
        
        ConfirmPaymentViewController*vc = [segue destinationViewController];
        vc.paymentData = PaymentUserData;
        vc.paymentUserData = requiredFldArray;
        vc.DataArray = DataArray;
        vc.descriptionBillLbl = _billNameLbl.text;
        vc.billCategoryId = [_billUserData valueForKeyPath:@"bill_category_id"];
    }
}

#pragma mark ########
#pragma mark Detect Touch methods
#pragma mark ########

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    
    if(touch.view ==_billOptionTableView){
        _billOptionTableView.hidden = NO;
    }
    else
    {
        _billOptionTableView.hidden = YES;
    }
    
    if(touch.view ==genderTableView){
        genderTableView.hidden = NO;
    }
    else
    {
        genderTableView.hidden = YES;
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

@end

