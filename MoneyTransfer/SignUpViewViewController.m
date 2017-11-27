//
//  SignUpViewViewController.m
//  MoneyTransfer
//
//  Created by apple on 27/11/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "SignUpViewViewController.h"
#import "LoginViewController.h"
#import "AddCardViewController.h"
#import "Constants.h"
#import "Controller.h"
#import "AppDelegate.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "AsyncImageView.h"
#import "BackPopUp.h"

@interface SignUpViewViewController ()
{
    AppDelegate *appDel;
}

@end

@implementation SignUpViewViewController
static NSString *kCellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [[ NSUserDefaults standardUserDefaults] setInteger:nil forKey:@"timeStamp"];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShade) name:@"removeShade" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusTimer) name:@"statusTimer" object:nil];
    
    _scrollView.bounces = NO;
    
    [_passwordTextfield setSecureTextEntry:YES];
    [_repeatPssTextfield setSecureTextEntry:YES];
    
    allCurrencyArray = [[NSMutableArray alloc]init];
    
    _currencyTableView=[[UITableView alloc]initWithFrame:CGRectMake(_currencyBtn.frame.origin.x,_currencyBtn.frame.origin.y ,_currencyBtn.frame.size.width, 160) style:UITableViewStylePlain];
    _currencyTableView.delegate=self;
    _currencyTableView.dataSource=self;
    [_currencyTableView setAllowsSelection:YES];
    [_currencyTableView setScrollEnabled:YES];
    [self.view2_number addSubview:_currencyTableView];

    _currencyTableView.backgroundColor=[UIColor lightGrayColor];
    _currencyTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _currencyTableView.layer.borderWidth= 0.5;
    _currencyTableView.layer.cornerRadius = 0.0;
    
    _currencyTableView.hidden = YES;
    
    _crossBtn.layer.cornerRadius = _crossBtn.frame.size.height/2.0f;
    _view1_email.hidden = YES;
    _view2_number.hidden = NO;
    _view3_details.hidden = YES;
    _view4_password.hidden = YES;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT-50, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    
    _emailTextfield.inputAccessoryView = numberToolbar;
    _numberTextfield.inputAccessoryView = numberToolbar;
    _firstNameTextfield.inputAccessoryView = numberToolbar;
    _lastnameTextfield.inputAccessoryView = numberToolbar;
    _addressTextfield.inputAccessoryView = numberToolbar;
    _passwordTextfield.inputAccessoryView = numberToolbar;
    _repeatPssTextfield.inputAccessoryView = numberToolbar;
}

-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DuphluxAuthStatus" object:nil];
}

-(void) statusTimer{
    NSString *referneceString =  [[ NSUserDefaults standardUserDefaults] valueForKey:@"DuphuluxReferenceNumber"];
    [self getAuthStatusWebService:referneceString];
}

-(void) removeShade {
    [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"callStatusValue"]  isEqual: @"Continue"]){
        [HUD removeFromSuperview];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = NSLocalizedString(@"Loading...", nil);
        [HUD show:YES];
        [self userRegsiteration];
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
    //        alertview.tag = 1001;
    //        [alertview show];
    //    }
    else{
        
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"" message:@"Verification cancelled." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertview.tag = 1001;
        [alertview show];
    }
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"callStatusValue"];
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cancel"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"verifying"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stop"];
  
    self.emailTextfield.text = @"";
    self.numberTextfield.text = @"";
    self.firstNameTextfield.text = @"";
    self.lastnameTextfield.text = @"";
    self.addressTextfield.text = @"";
    self.passwordTextfield.text = @"";
    self.repeatPssTextfield.text = @"";
    
    // Call Get country list method
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading country...", nil);
    [HUD show:YES];
    [self getCurrencyList];
    
    UIColor *color = [UIColor whiteColor];
    _emailTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"your email address here" attributes:@{NSForegroundColorAttributeName: color}];
    _numberTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"your number" attributes:@{NSForegroundColorAttributeName: color}];
    _firstNameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"your first name" attributes:@{NSForegroundColorAttributeName: color}];
    _lastnameTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"your last name" attributes:@{NSForegroundColorAttributeName: color}];
    _addressTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"your address" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"your password" attributes:@{NSForegroundColorAttributeName: color}];
    _repeatPssTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"repeat password" attributes:@{NSForegroundColorAttributeName: color}];
}

- (IBAction)ActionCrossBtn:(id)sender {
//        [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ActionNextBtn:(id)sender {
}

#pragma mark ######
#pragma Scroll View method
#pragma mark ######

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

    CGFloat availableHeight = applicationFrame.size.height - 350; // Remove area covered by keyboard

    CGFloat y = viewCenterY - availableHeight / 2.0;
    if (y < 0) {
        y = 0;
    }

}

-(void)cancelNumberPad
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
}

-(void)doneWithNumberPad
{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
}

- (IBAction)countryBtn:(id)sender {
    
    // Country Action
    
    if (allCurrencyArray == NULL)
    {
        _currencyTableView.hidden = YES;
    }
    else if (_currencyTableView.hidden == YES) {
        _currencyTableView.hidden = NO;
     
        _currencyTableView.frame =CGRectMake(_currencyBtn.frame.origin.x,_currencyBtn.frame.origin.y ,_currencyBtn.frame.size.width, 40*(allCurrencyArray.count));
        [_currencyTableView reloadData];
    }
    else
    {
        self.scrollView.scrollEnabled = YES;
        _currencyTableView.hidden = YES;
    }
}

- (void)DuphluxAuthStatusCall:(NSNotification *)notification
{
    NSString *referneceString =  [[ NSUserDefaults standardUserDefaults] valueForKey:@"DuphuluxReferenceNumber"];
    BackPopUp *popUp = [[BackPopUp alloc]initWithNibName:@"BackPopUp"  bundle:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@"normal" forKey:@"hudView"];
    [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
    //    [HUD removeFromSuperview];
    //    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //    [self.view addSubview:HUD];
    //    [HUD.customView setBackgroundColor:[UIColor greenColor]];
    //    HUD.color = [UIColor blackColor];
    //    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    //    [HUD show:YES];
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
    
    //    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
    //                                                          dateStyle:NSDateFormatterShortStyle
    //                                                          timeStyle:NSDateFormatterFullStyle];
    NSString *dateString = [self stringWithRandomSuffixForFile:@"file.pdf" withLength:4];
    [[ NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"DuphuluxReferenceNumber"];
    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
    [dictA setValue:phoneNumber forKey:@"phone_number"];
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
                        alertview.tag = 1001;
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
                            //                    [HUD removeFromSuperview];
                            //                    HUD = [[MBProgressHUD alloc] initWithView:self.view];
                            //                    [self.view addSubview:HUD];
                            //                    HUD.labelText = NSLocalizedString(@"Loading...", nil);
                            //                    [HUD show:YES];
                            //                    [self userRegsiteration];
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
#pragma mark ######
#pragma mark Get Currency List method
#pragma mark ######

-(void) getCurrencyList
{
    // get Currency list
    [Controller getAllSendingCurrencyWithSuccess:^(id responseObject)
     {
         NSDictionary *Data = [responseObject valueForKey:@"PayLoad"];
         NSDictionary *currencyData = [ Data valueForKey:@"data"];
         allCurrencyArray = [ currencyData valueForKey:@"currencies"];
         
         if (allCurrencyArray.count != 0)
         {
             NSDictionary *dict = [ allCurrencyArray objectAtIndex:0];
             _currencyIDLbl.text = [dict valueForKey:@"currency_code"];
             NSString *phoneSTR = [dict valueForKey:@"country_code"];
             if([[dict valueForKey:@"country_code"] isEqualToString:@""]){
                 
                 _numberTextfield.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
             }
             else if (![phoneSTR containsString:@"+" ])
             {
                 _numberTextfield.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
             }
             else
             {
                 _numberTextfield.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
             }
             
             // Select the country code used for user registration process
             selectCountryCode = [dict valueForKey:@"id"];
             
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
             
         }
     }andFailure:^(NSString *errorString)
     {
         [HUD removeFromSuperview];
         
     }];
}
#pragma mark ######
#pragma mark User Regsiteration method
#pragma mark ######

-(void) userRegsiteration
{
    // User registeration
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:self.firstNameTextfield.text, @"first_name",@"middle", @"middle_name",self.lastnameTextfield.text, @"last_name", self.emailTextfield.text, @"email_address", self.numberTextfield.text, @"phone_number", selectCountryCode, @"country_currency_id",self.passwordTextfield.text, @"password", @"", @"referral_code", nil]options:NSJSONWritingPrettyPrinted error:nil];
    
    NSMutableData *PostData =[[NSMutableData alloc]initWithData:data];
    
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@/%@", BaseUrl, SignUp];
    NSURL *url = [NSURL URLWithString:ApiUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
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
                
                if (data)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD removeFromSuperview];
                    });
                    id responseDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"] integerValue];
                    
                    if (status == 0)
                    {
                        NSArray *errorArray =[ responseDic valueForKeyPath:@"PayLoad.error"];
                        NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
                        if (errorArray != nil){
                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            
                            [alertview show];
                        }
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *userProfile = [[ NSDictionary alloc] initWithDictionary:[[responseDic valueForKey:@"PayLoad"] valueForKey:@"data"]];
                            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:userProfile] forKey:@"loginUserData"];
                            
                            
                            [self performSegueWithIdentifier:@"AddCreditCard" sender:self];
                            
                        });
                    }
                }
                
            }
            else{
                [HUD removeFromSuperview];
                
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Connection failed. Please make sure you have an active internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertview show];
            }
        }
        
    }];
    
    [postDataTask resume];
}

#pragma mark #############
#pragma mark UITableView delegate methods
#pragma mark #############
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allCurrencyArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    NSDictionary *dict;
    dict = [ allCurrencyArray objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 70, 30)];
    
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:15]];
    titleLabel.text = [dict valueForKey:@"currency_code"];
    [cell.contentView addSubview:titleLabel];
    
    
    
    AsyncImageView *iconImage = [[AsyncImageView alloc] init];
    iconImage.frame = CGRectMake(10,10,20, 20);
    NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[dict valueForKey:@"flag"]];
    
    NSString  *urlStr = [logoimageURl stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
    
    NSURL * imgUrl = [NSURL URLWithString:urlStr];
    iconImage.imageURL = imgUrl;
    
    NSString * flagName = @"";
    flagName = [logoimageURl lastPathComponent];
    [cell.contentView addSubview:iconImage];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [ allCurrencyArray objectAtIndex:indexPath.row];
    _currencyIDLbl.text = [dict valueForKey:@"currency_code"];
    
    NSString *phoneSTR = [dict valueForKey:@"country_code"];
    if([[dict valueForKey:@"country_code"] isEqualToString:@""]){
        
        _numberTextfield.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
    }
    else if (![phoneSTR containsString:@"+" ])
    {
        _numberTextfield.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
    }
    else
    {
        _numberTextfield.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
        
    }
    
    selectCountryCode = [dict valueForKey:@"id"];
    NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[dict valueForKey:@"flag"]];
    
    NSString *imagePath = @"";
    NSString * flagName = @"";
    flagName = [logoimageURl lastPathComponent];
    imagePath = [appDel getImagePathbyflagName:flagName];
    
    if(imagePath.length > 0){
        NSData *img = nil;
        img= [NSData dataWithContentsOfFile:imagePath];
        _countryImage.image =[UIImage imageWithData:img];
    }
    else
    {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:logoimageURl]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                _countryImage.image = [UIImage imageWithData:image];
                [appDel saveflagsImageToFolder:_countryImage.image imageName:flagName];
            });
        });
    }
    _currencyTableView.hidden = YES;
    self.scrollView.scrollEnabled = YES;
}

#pragma mark ######
#pragma mark Segue Delegate method
#pragma mark ######

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"AddCreditCard"]){
        AddCardViewController *vc = [segue destinationViewController];
        vc.lastSourceView = @"SingUp";
    }
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

#pragma mark ######
#pragma mark AlertView Delegate method
#pragma mark ######

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1001) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"stop"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

@end
