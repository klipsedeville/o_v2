//
//  SignUpViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "AddCardViewController.h"
#import "Constants.h"
#import "Controller.h"
#import "AppDelegate.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "AsyncImageView.h"
#import "BackPopUp.h"

@interface SignUpViewController ()
{
    AppDelegate *appDel;
}

@end

@implementation SignUpViewController
static NSString *kCellIdentifier = @"cellIdentifier";

#pragma mark ######
#pragma mark View Life Cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ NSUserDefaults standardUserDefaults] setInteger:nil forKey:@"timeStamp"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShade) name:@"removeShade" object:nil];

    // Remove the notifications
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DuphluxAuthStatus" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DuphluxAuthStatusCall:) name:@"DuphluxAuthStatus" object:nil];
    
    
    _scrollView.bounces = NO;
    
    self.emailAddressTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.repeatPasswordTextField.delegate = self;
    self.referralCodeTextField.delegate = self;
    
    [_passwordTextField setSecureTextEntry:YES];
    [_repeatPasswordTextField setSecureTextEntry:YES];
    
    allCurrencyArray = [[NSMutableArray alloc]init];
    
    _currencyTableView=[[UITableView alloc]initWithFrame:CGRectMake(10, _upperMiddleView.frame.origin.y+70, 80, 160) style:UITableViewStylePlain];
    _currencyTableView.delegate=self;
    _currencyTableView.dataSource=self;
    [_currencyTableView setAllowsSelection:YES];
    [_currencyTableView setScrollEnabled:YES];
    [self.scrollView addSubview:_currencyTableView];
    [self.currencyTableView setBackgroundColor: [self colorWithHexString:@"073245"]];
    _currencyTableView.backgroundColor=[UIColor lightGrayColor];
    _currencyTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _currencyTableView.layer.borderWidth= 0.5;
    _currencyTableView.layer.cornerRadius = 0.0;
    
    _currencyTableView.hidden = YES;
    
    // Bottom border
    firstNameLayer = [CALayer layer];
    firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
    firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.firstNameTextField.layer addSublayer:firstNameLayer];
    
    surNameLayer = [CALayer layer];
    surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
    surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.surNameTextField.layer addSublayer:surNameLayer];
    
    CALayer *FirstNameLayer2 = [CALayer layer];
    FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
    FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
    [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
    
    CALayer *FirstNameLayer3 = [CALayer layer];
    FirstNameLayer3.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
    FirstNameLayer3.backgroundColor = [UIColor blackColor].CGColor;
    [self.phoneNumberTextField.layer addSublayer:FirstNameLayer3];
    
    physicalAddressLayer = [CALayer layer];
    physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
    physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
    
    CALayer *FirstNameLayer5 = [CALayer layer];
    FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
    FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
    [self.passwordTextField.layer addSublayer:FirstNameLayer5];
    
    CALayer *FirstNameLayer6 = [CALayer layer];
    FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
    FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
    [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
    
    referralCodeLayer = [CALayer layer];
    referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
    referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
    
    _firstNameLblHeading.hidden = YES;
    _surNameLblHeading.hidden = YES;
    _emailAddressLblHeading.hidden = YES;
    _phoneNumberLblHeading.hidden = NO;
    _physicalAddressLblHeading.hidden = YES;
    _passwordLblheading.hidden = YES;
    _repeatPasswordLblHeading.hidden = YES;
    _referralCodeLblHeading.hidden = YES;
    
    previousRectFirstName = CGRectZero;
    previousRectSurName = CGRectZero;
    previousRectPhysicalAddress = CGRectZero;
    
    //  Add  Tap Guesture On SignUp labels
    UITapGestureRecognizer *tapGestureFirstName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGestureSurName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGestureEmailAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGesturePhnNo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGesturePhysicalAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGesturePassword = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGestureRepeatPassword = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    UITapGestureRecognizer *tapGestureReferralCode = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    self.firstNameLbl.userInteractionEnabled = YES;
    self.surNameLbl.userInteractionEnabled = YES;
    self.emailAddressLbl.userInteractionEnabled = YES;
    self.phoneNumberLbl.userInteractionEnabled = YES;
    self.physicalAddressLbl.userInteractionEnabled = YES;
    self.passwordLbl.userInteractionEnabled = YES;
    self.repeatPasswordLbl.userInteractionEnabled = YES;
    self.referralCodeLbl.userInteractionEnabled = YES;
    
    [self.firstNameLbl addGestureRecognizer:tapGestureFirstName];
    [self.surNameLbl addGestureRecognizer:tapGestureSurName];
    [self.emailAddressLbl addGestureRecognizer:tapGestureEmailAddress];
    [self.phoneNumberLbl addGestureRecognizer:tapGesturePhnNo];
    [self.physicalAddressLbl addGestureRecognizer:tapGesturePhysicalAddress];
    [self.passwordLbl addGestureRecognizer:tapGesturePassword];
    [self.repeatPasswordLbl addGestureRecognizer:tapGestureRepeatPassword];
    [self.referralCodeLbl addGestureRecognizer:tapGestureReferralCode];
    
    [_scrollView setCanCancelContentTouches:YES];
    [_scrollView setUserInteractionEnabled:YES];
    
    _firstNameLbl.tag = 1;
    _surNameLbl.tag = 2;
    _emailAddressLbl.tag = 3;
    _phoneNumberLbl.tag = 4;
    _physicalAddressLbl.tag = 5;
    _passwordLbl.tag = 6;
    _repeatPasswordLbl.tag = 7;
    _referralCodeLbl.tag = 8;
}
-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DuphluxAuthStatus" object:nil];
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
//        [HUD removeFromSuperview];
//        HUD = [[MBProgressHUD alloc] initWithView:self.view];
//        [HUD.customView setBackgroundColor:[UIColor greenColor]];
//        HUD.color = [UIColor blackColor];
//        [self.view addSubview:HUD];
//        HUD.labelText = NSLocalizedString(@"Loading...", nil);
//        [HUD show:YES];
            [self getAuthStatusWebService:referneceString];
    }
    else {
        
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"" message:@"Verification cancelled." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alertview.tag = 1001;
        [alertview show];
    }
     [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"callStatusValue"];
}

-(void) viewWillAppear:(BOOL)animated{
    
    _phoneNumberLbl.hidden = YES;
    [self.scrollView setBackgroundColor: [self colorWithHexString:@"073245"]];
    self.firstNameTextField.text = @"";
    self.surNameTextField.text = @"";
    self.emailAddressTextField.text = @"";
    self.physicalAddressTextField.text = @"";
    self.passwordTextField.text = @"";
    self.repeatPasswordTextField.text = @"";
    self.referralCodeTextField.text = @"";
    
    // Call Get country list method
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading country...", nil);
    [HUD show:YES];
    [self getCurrencyList];
    
    float sizeOfContent = 0;
    NSInteger wd = _lowerView.frame.origin.y;
    NSInteger ht = _lowerView.frame.size.height;
    
    sizeOfContent = wd+ht;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    
    // Add Tool bar on number keyboard
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _firstNameTextField.inputAccessoryView = numberToolbar;
    _surNameTextField.inputAccessoryView = numberToolbar;
    _emailAddressTextField.inputAccessoryView = numberToolbar;
    _phoneNumberTextField.inputAccessoryView = numberToolbar;
    _physicalAddressTextField.inputAccessoryView = numberToolbar;
    _passwordTextField.inputAccessoryView = numberToolbar;
    _repeatPasswordTextField.inputAccessoryView = numberToolbar;
    _referralCodeTextField.inputAccessoryView = numberToolbar;
    
}
-(void)cancelNumberPad{
    [self.view endEditing:YES];
    
}

-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.currencyTableView]) {
        return NO;
    }
    return YES;
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


#pragma mark #####
#pragma mark Click Events methods
#pragma mark ######

- (IBAction)backBtnClicked:(id)sender
{
    // back Button Action
    [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)countryBtn:(id)sender {
    
    // Country Action
    
    [self.emailAddressTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.repeatPasswordTextField resignFirstResponder];
    [self.referralCodeTextField resignFirstResponder];
    
    if (allCurrencyArray == NULL)
    {
        _currencyTableView.hidden = YES;
    }
    else if (_currencyTableView.hidden == YES) {
        _currencyTableView.hidden = NO;
        _currencyTableView.frame =CGRectMake(10, _upperMiddleView.frame.origin.y+70, 80, 40*(allCurrencyArray.count));
        [_currencyTableView reloadData];
    }
    else
    {
        self.scrollView.scrollEnabled = YES;
        _currencyTableView.hidden = YES;
    }
}

- (IBAction)logInBtn:(id)sender {
    
    [ self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ######
#pragma mark User register Button click method
#pragma mark ######

- (IBAction)registerBtn:(id)sender {
    
    // Sign up Action
    [self resignFirstResponder];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    NSString *first_name = [self.firstNameTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *sur_name = [self.surNameTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *email_address = [self.emailAddressTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *phone_number = [self.phoneNumberTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *physical_address = [self.physicalAddressTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *repeat_password = [self.repeatPasswordTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *referral_code = [self.referralCodeTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    if (([first_name length] == 0) && ([sur_name length] == 0 ) && ([email_address length] == 0 )&& ([phone_number length] != 0 ) && ([physical_address length] == 0 ) && ([password length] == 0 ) && ([repeat_password length] == 0 ) && ([referral_code length] == 0 ))
    {
        // If  field Empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please fill the form correctly." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if([first_name length] == 0)
    {
        // If First name empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter your first name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if ([sur_name length] == 0)
    {
        // If last name empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter your last name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if ([email_address length] == 0)
    {
        // If email Address name empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter an valid email address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else if([email_address length] > 0){
        // If email address empty
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        int checkValue = [emailTest evaluateWithObject:self.emailAddressTextField.text];
        if (checkValue==0)
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"You have entered an invalid e-mail address. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else if ([phone_number length] < 5){
            //  If phone number empty
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter a phone number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
            [self.phoneNumberTextField becomeFirstResponder];
        }
        else if ([phone_number length] < 10)
        {
            // If Phone number empty
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter a correct phone number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
            [self.phoneNumberTextField becomeFirstResponder];
        }
        else if ([physical_address length] == 0)
        {
            // If Physical Address empty
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter a physical address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else if ([password length] == 0)
        {
            // If password emptyd
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter a password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else if ([repeat_password length] == 0)
        {
            // If repeat password empty
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter a repeat password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else if (![password isEqualToString:repeat_password])
        {
            // If password & repeat password does not matched
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Password & Repeat password do not match. Please try again. " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertview show];
        }
        else
        {
            userPhoneNumber = phone_number;
            BackPopUp *popUp = [[BackPopUp alloc]initWithNibName:@"BackPopUp"  bundle:nil];
            [[NSUserDefaults standardUserDefaults]setObject:@"normal" forKey:@"hudView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
//            [HUD removeFromSuperview];
//            HUD = [[MBProgressHUD alloc] initWithView:self.view];
//            [self.view addSubview:HUD];
//            [HUD.customView setBackgroundColor:[UIColor greenColor]];
//            HUD.color = [UIColor blackColor];
//            HUD.labelText = NSLocalizedString(@"Loading...", nil);
//            [HUD show:YES];
            [self callAuthWebService:userPhoneNumber];
        }
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
    [request addValue:@"54d5a2b10ecc8252d17108c6ad04a8a1f4cf9b66" forHTTPHeaderField:@"token"];
    
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
    [request addValue:@"54d5a2b10ecc8252d17108c6ad04a8a1f4cf9b66" forHTTPHeaderField:@"token"];
    
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
                          [ self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
                     [HUD removeFromSuperview];
                         if ([[json valueForKeyPath:@"PayLoad.data.verification_status"]  isEqual: @"verified"])
                    {
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
                        
                        CustomPopUp *popUp = [[CustomPopUp alloc]initWithNibName:@"CustomPopUp_iPhone"  bundle:nil];
                        popUp.popUpMsg = @"You appear to be offline. Please check your net connection and retry.";
                       popUp.OkBtnTitle = @"CALL TO AUTHENTICATE";
                        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"hudView"];
                        popUp.callTo = callingPhoneNumber;
                        popUp.callFrom = userPhoneNumber;
                        popUp.delegate = self;
                        
                       
                        [self presentPopupViewController:popUp animationType:MJPopupViewAnimationFade1];
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
                    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:[errorArray objectAtIndex:0] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alertview show];
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
             _phoneNumberLbl.hidden = YES;
             _phoneNumberLblHeading.hidden = NO;
             
             if ([ _firstNameTextField.text isEqual:@""]) {
                 _firstNameLbl.hidden = NO;
                 _firstNameLblHeading.hidden= YES;
             }
             if ([ _surNameTextField.text isEqual:@""]) {
                 _surNameLbl.hidden = NO;
                 _surNameLblHeading.hidden= YES;
             }
             if ([ _emailAddressTextField.text isEqual:@""]) {
                 _emailAddressLbl.hidden = NO;
                 _emailAddressLblHeading.hidden = YES;
                 
                 CALayer *FirstNameLayer2 = [CALayer layer];
                 FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
                 FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
                 [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
                 [_emailAddressTextField resignFirstResponder];
             }
             if ([ _physicalAddressTextField.text isEqual:@""]) {
                 _physicalAddressLbl.hidden = NO;
                 _physicalAddressLblHeading.hidden = YES;
             }
             if ([ _passwordTextField.text isEqual:@""]) {
                 _passwordLbl.hidden = NO;
                 _passwordLblheading.hidden = YES;
                 
                 CALayer *FirstNameLayer5 = [CALayer layer];
                 FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
                 FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
                 [self.passwordTextField.layer addSublayer:FirstNameLayer5];
                 [_passwordTextField resignFirstResponder];
             }
             if ([_repeatPasswordTextField.text isEqual:@""]) {
                 _repeatPasswordLbl.hidden = NO;
                 _repeatPasswordLblHeading.hidden = YES;
                 
                 CALayer *FirstNameLayer6 = [CALayer layer];
                 FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
                 FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
                 [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
                 [_repeatPasswordTextField resignFirstResponder];
                 
             }
             if ([_referralCodeTextField.text isEqual:@""]) {
                 _referralCodeLbl.hidden = NO;
                 _referralCodeLblHeading.hidden = YES;
             }
             
             NSDictionary *dict = [ allCurrencyArray objectAtIndex:0];
             _currencyIDLbl.text = [dict valueForKey:@"currency_code"];
             NSString *phoneSTR = [dict valueForKey:@"country_code"];
             if([[dict valueForKey:@"country_code"] isEqualToString:@""]){
               
                 _phoneNumberTextField.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
             }
             else if (![phoneSTR containsString:@"+" ])
             {
                 _phoneNumberTextField.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
             }
             else
             {
                 _phoneNumberTextField.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
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
  
    [Controller createAccountWithName:self.firstNameTextField.text SurName:self.surNameTextField.text EmailAddress:self.emailAddressTextField.text PhoneNumber:self.phoneNumberTextField.text address:self.physicalAddressTextField.text CountryID:selectCountryCode Password:self.passwordTextField.text ReferralCode:self.referralCodeTextField.text withSuccess:^(id responseObject)
     {
         [HUD removeFromSuperview];
         
         NSInteger status = [[responseObject valueForKeyPath:@"PayLoad.status"] integerValue];
         if (status == 0)
         {
             NSArray *errorArray =[ responseObject valueForKeyPath:@"PayLoad.error"];
             NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
             if (errorArray != nil){
             UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             
             [alertview show];
             }
         }else
         {
             NSDictionary *userProfile = [[ NSDictionary alloc] initWithDictionary:[[responseObject valueForKey:@"PayLoad"] valueForKey:@"data"]];
             [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:userProfile] forKey:@"loginUserData"];
             
             [self performSegueWithIdentifier:@"AddCreditCard" sender:self];
         }
         
     }andFailure:^(NSString *errorString){
         
         [HUD removeFromSuperview];
         
         UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Connection failed. Please make sure you have an active internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         
         [alertview show];
         
     }];
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
    [cell.contentView setBackgroundColor: [self colorWithHexString:@"073245"]];
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
        
        _phoneNumberTextField.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
    }
    else if (![phoneSTR containsString:@"+" ])
    {
        _phoneNumberTextField.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
    }
    else
    {
        _phoneNumberTextField.text = [NSString stringWithFormat:@"+%@", [dict valueForKey:@"country_code"]];
        
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

#pragma mark ###########
#pragma mark - Text Fields Deletgate methods
#pragma mark ###########

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString *first_name = self.firstNameTextField.text ;
    NSString *sur_name = self.surNameTextField.text ;
    NSString *email_address = self.emailAddressTextField.text ;
    NSString *phone_number = self.phoneNumberTextField.text ;
    NSString *physical_address = self.physicalAddressTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *repeat_password = self.repeatPasswordTextField.text;
    NSString *referral_code = self.referralCodeTextField.text;
    
    float sizeOfContent = 0;
    NSInteger wd = _lowerView.frame.origin.y;
    NSInteger ht = _lowerView.frame.size.height;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width,_scrollView.contentSize.height + 220)];
    
    if (textField == _emailAddressTextField)
    {
        _emailAddressLblHeading.textColor= [self colorWithHexString:@"3ec6f0"];
        CALayer *FirstNameLayer14 = [CALayer layer];
        FirstNameLayer14.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
        FirstNameLayer14.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.emailAddressTextField.layer addSublayer:FirstNameLayer14];
        
        if (([first_name length] != 0) ) {
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        else
        {
            _firstNameLblHeading.hidden = YES;
            _firstNameLbl.hidden = NO;
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        if (([sur_name length] != 0) ) {
            _surNameLblHeading.textColor = [UIColor whiteColor];
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        else
        {
            _surNameLblHeading.hidden = YES;
            _surNameLbl.hidden = NO;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        if ([phone_number length] != 0 ) {
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer1];
        }
        if ([physical_address length] != 0 )
        {
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        else
        {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        if ([password length] != 0 )
        {
            _passwordLblheading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        else
        {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        if ([repeat_password length] != 0 )
        {
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        else
        {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        if ([referral_code length] != 0 ) {
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
        else
        {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
    }
    
    if (textField == _phoneNumberTextField)
    {
        
        UIView *tempVW = [[ UIView alloc] init];
        
        tempVW.frame = CGRectMake(_phoneNumberTextField.frame.origin.x, _phoneNumberTextField.frame.origin.y+20, _phoneNumberTextField.frame.size.width, _phoneNumberTextField.frame.size.height );
        
        [self scrollViewToCenterOfScreen:tempVW];
        
        _phoneNumberLblHeading.textColor= [self colorWithHexString:@"3ec6f0"];
        
        CALayer *FirstNameLayer1 = [CALayer layer];
        FirstNameLayer1.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
        FirstNameLayer1.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.phoneNumberTextField.layer addSublayer:FirstNameLayer1];
        
        if (([first_name length] != 0) )
        {
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        else
        {
            _firstNameLblHeading.hidden = YES;
            _firstNameLbl.hidden = NO;
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        if (([sur_name length] != 0) ) {
            _surNameLblHeading.textColor = [UIColor whiteColor];
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        else
        {
            _surNameLblHeading.hidden = YES;
            _surNameLbl.hidden = NO;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        if (([email_address length] != 0) ) {
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        else
        {
            _emailAddressLblHeading.hidden = YES;
            _emailAddressLbl.hidden = NO;
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        if ([physical_address length] != 0 )
        {
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        else
        {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        if ([password length] != 0 )
        {
            _passwordLblheading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        else
        {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        if ([repeat_password length] != 0 )
        {
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        else
        {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        if ([referral_code length] != 0 ) {
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
        else
        {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
    }
    if (textField == _passwordTextField)
    {
        UIView *tempVW = [[ UIView alloc] init];
        
        tempVW.frame = CGRectMake(_passwordTextField.frame.origin.x, _passwordTextField.frame.origin.y+120, _passwordTextField.frame.size.width, _passwordTextField.frame.size.height );
        
        [self scrollViewToCenterOfScreen:tempVW];
        
        _passwordLblheading.textColor= [self colorWithHexString:@"3ec6f0"];
        CALayer *FirstNameLayer11 = [CALayer layer];
        FirstNameLayer11.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
        FirstNameLayer11.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.passwordTextField.layer addSublayer:FirstNameLayer11];
        
        if (([first_name length] != 0) ) {
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        else
        {
            _firstNameLblHeading.hidden = YES;
            _firstNameLbl.hidden = NO;
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        if (([sur_name length] != 0) ) {
            _surNameLblHeading.textColor = [UIColor whiteColor];
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        else
        {
            _surNameLblHeading.hidden = YES;
            _surNameLbl.hidden = NO;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        if (([email_address length] != 0) ) {
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        else
        {
            _emailAddressLblHeading.hidden = YES;
            _emailAddressLbl.hidden = NO;
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        if ([phone_number length] != 0 ) {
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer1];
        }
        if ([physical_address length] != 0 )
        {
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        else
        {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        if ([repeat_password length] != 0 )
        {
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        else
        {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        if ([referral_code length] != 0 ) {
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
        }
        else
        {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
    }
    if (textField == _repeatPasswordTextField)
    {
        UIView *tempVW = [[ UIView alloc] init];
        
        tempVW.frame = CGRectMake(_repeatPasswordTextField.frame.origin.x, _repeatPasswordTextField.frame.origin.y+140, _repeatPasswordTextField.frame.size.width, _repeatPasswordTextField.frame.size.height );
        
        [self scrollViewToCenterOfScreen:tempVW];
        
        _repeatPasswordLblHeading.textColor= [self colorWithHexString:@"3ec6f0"];
        CALayer *FirstNameLayer10 = [CALayer layer];
        FirstNameLayer10.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
        FirstNameLayer10.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer10];
        
        if (([first_name length] != 0) ) {
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        else
        {
            _firstNameLblHeading.hidden = YES;
            _firstNameLbl.hidden = NO;
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        if (([sur_name length] != 0) ) {
            _surNameLblHeading.textColor = [UIColor whiteColor];
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        else
        {
            _surNameLblHeading.hidden = YES;
            _surNameLbl.hidden = NO;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        if (([email_address length] != 0) ) {
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        else
        {
            _emailAddressLblHeading.hidden = YES;
            _emailAddressLbl.hidden = NO;
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        if ([phone_number length] != 0 ) {
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer1];
        }
        if ([physical_address length] != 0 )
        {
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        else
        {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        if ([password length] != 0 )
        {
            _passwordLblheading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        else
        {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        if ([referral_code length] != 0 ) {
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
        }
        else
        {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
    }
    if (textField == _referralCodeTextField)
    {
        UIView *tempVW = [[ UIView alloc] init];
        
        tempVW.frame = CGRectMake(_referralCodeTextField.frame.origin.x, _referralCodeTextField.frame.origin.y+140, _referralCodeTextField.frame.size.width, _referralCodeTextField.frame.size.height );
        
        [self scrollViewToCenterOfScreen:tempVW];
        
        _referralCodeLblHeading.textColor= [self colorWithHexString:@"3ec6f0"];
        referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
        referralCodeLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        
        if (([first_name length] != 0) ) {
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        else
        {
            _firstNameLblHeading.hidden = YES;
            _firstNameLbl.hidden = NO;
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        if (([sur_name length] != 0) ) {
            _surNameLblHeading.textColor = [UIColor whiteColor];
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        else
        {
            _surNameLblHeading.hidden = YES;
            _surNameLbl.hidden = NO;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        if (([email_address length] != 0) ) {
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        else
        {
            _emailAddressLblHeading.hidden = YES;
            _emailAddressLbl.hidden = NO;
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        if ([phone_number length] != 0 ) {
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer1];
        }
        if ([physical_address length] != 0 )
        {
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        else
        {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        if ([password length] != 0 )
        {
            _passwordLblheading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        else
        {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        if ([repeat_password length] != 0 )
        {
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        else
        {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    float sizeOfContent = 0;
    NSInteger wd = _lowerView.frame.origin.y;
    NSInteger ht = _lowerView.frame.size.height;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 350;
    
    CGFloat y = viewCenterY - availableHeight / 7.0;
    if (y < 0) {
        y = 0;
    }
    [_scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

#pragma mark #############
#pragma mark TextView Delegate Menthods
#pragma mark ######

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *first_name = self.firstNameTextField.text ;
    NSString *sur_name = self.surNameTextField.text ;
    NSString *email_address = self.emailAddressTextField.text ;
    NSString *phone_number = self.phoneNumberTextField.text ;
    NSString *physical_address = self.physicalAddressTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *repeat_password = self.repeatPasswordTextField.text;
    NSString *referral_code = self.referralCodeTextField.text;
    
    float sizeOfContent = 0;
    NSInteger wd = _lowerView.frame.origin.y;
    NSInteger ht = _lowerView.frame.size.height;
    
    sizeOfContent = wd+ht;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width,_scrollView.contentSize.height + 220)];
    
    
    if (textView == _firstNameTextField)
    {
        _firstNameLblHeading.textColor= [self colorWithHexString:@"3ec6f0"];
        firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
        firstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.firstNameTextField.layer addSublayer:firstNameLayer];
        
        if (([sur_name length] != 0) ) {
            
            _surNameLblHeading.textColor = [UIColor whiteColor];
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        else
        {
            _surNameLblHeading.hidden = YES;
            _surNameLbl.hidden = NO;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        if (([email_address length] != 0) ) {
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        else
        {
            _emailAddressLblHeading.hidden = YES;
            _emailAddressLbl.hidden = NO;
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        if ([phone_number length] != 0 ) {
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer1];
        }
        if ([physical_address length] != 0 )
        {
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        else
        {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        if ([password length] != 0 )
        {
            _passwordLblheading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        else
        {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        if ([repeat_password length] != 0 )
        {
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        else
        {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        if ([referral_code length] != 0 ) {
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
        }
        else
        {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
    }
    if (textView == _surNameTextField)
    {
        _surNameLblHeading.textColor= [self colorWithHexString:@"3ec6f0"];
        surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
        surNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.surNameTextField.layer addSublayer:surNameLayer];
        
        
        if (([first_name length] != 0) ) {
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        else
        {
            _firstNameLblHeading.hidden = YES;
            _firstNameLbl.hidden = NO;
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        if (([email_address length] != 0) ) {
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        else
        {
            _emailAddressLblHeading.hidden = YES;
            _emailAddressLbl.hidden = NO;
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        if ([phone_number length] != 0 ) {
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer1];
        }
        if ([physical_address length] != 0 )
        {
            
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        else
        {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        }
        if ([password length] != 0 )
        {
            _passwordLblheading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        else
        {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        if ([repeat_password length] != 0 )
        {
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        else
        {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        if ([referral_code length] != 0 ) {
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
        }
        else
        {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
    }
    if (textView == _physicalAddressTextField)
    {
        
        UIView *tempVW = [[ UIView alloc] init];
        
        tempVW.frame = CGRectMake(_physicalAddressTextField.frame.origin.x, _physicalAddressTextField.frame.origin.y+160, _physicalAddressTextField.frame.size.width, _physicalAddressTextField.frame.size.height );
        
        [self scrollViewToCenterOfScreen:tempVW];
        
        
        _physicalAddressLblHeading.textColor= [self colorWithHexString:@"3ec6f0"];
        physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
        physicalAddressLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        
        if (([first_name length] != 0) ) {
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        else
        {
            _firstNameLblHeading.hidden = YES;
            _firstNameLbl.hidden = NO;
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
        }
        if (([sur_name length] != 0) ) {
            _surNameLblHeading.textColor = [UIColor whiteColor];
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        else
        {
            _surNameLblHeading.hidden = YES;
            _surNameLbl.hidden = NO;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
        }
        if (([email_address length] != 0) ) {
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        else
        {
            _emailAddressLblHeading.hidden = YES;
            _emailAddressLbl.hidden = NO;
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
        }
        if ([phone_number length] != 0 ) {
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer1 = [CALayer layer];
            FirstNameLayer1.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer1.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer1];
        }
        if ([password length] != 0 )
        {
            _passwordLblheading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        else
        {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
        }
        if ([repeat_password length] != 0 )
        {
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        else
        {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
        }
        if ([referral_code length] != 0 ) {
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
        else
        {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        }
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
    {
        CGRect frame = txtView.frame;
        frame.size.height = [self contentSizeRectForTextView:txtView].size.height;
        txtView.frame= frame;
        
        
        if (txtView == _firstNameTextField)
        {
            if(txtView.frame.size.height > _surNameTextField.frame.size.height)
            {
                if (txtView.frame.size.height > 35)
                {
                    UITextPosition* pos = txtView.endOfDocument;
                    CGRect currentRect = [txtView caretRectForPosition:pos];
                    
                    if (currentRect.origin.y > previousRectFirstName.origin.y)
                    {
                        
                        
                        CGFloat increasedHeight = currentRect.origin.y -previousRectFirstName.origin.y ;
                        
                        _upperView.frame = CGRectMake(_upperView.frame.origin.x, _upperView.frame.origin.y, _upperView.frame.size.width, _upperView.frame.size.height+increasedHeight);
                        
                        _upperMiddleView.frame = CGRectMake(_upperMiddleView.frame.origin.x,_upperMiddleView.frame.origin.y+increasedHeight, _upperMiddleView.frame.size.width, _upperMiddleView.frame.size.height);
                        
                        _lowerMiddleView.frame = CGRectMake(_lowerMiddleView.frame.origin.x,_lowerMiddleView.frame.origin.y+increasedHeight, _lowerMiddleView.frame.size.width, _lowerMiddleView.frame.size.height);
                        
                        _lowerView.frame = CGRectMake(_lowerView.frame.origin.x,_lowerView.frame.origin.y+increasedHeight, _lowerView.frame.size.width, _lowerView.frame.size.height);
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
                            
                            firstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                            
                            [self.firstNameTextField.layer addSublayer:firstNameLayer];
                        }];
                    }
                    else
                    {
                        CGFloat increasedHeight = previousRectFirstName.origin.y-currentRect.origin.y ;
                        _upperView.frame = CGRectMake(_upperView.frame.origin.x, _upperView.frame.origin.y, _upperView.frame.size.width, _upperView.frame.size.height-increasedHeight);
                        
                        _upperMiddleView.frame = CGRectMake(_upperMiddleView.frame.origin.x,_upperMiddleView.frame.origin.y-increasedHeight, _upperMiddleView.frame.size.width, _upperMiddleView.frame.size.height);
                        
                        _lowerMiddleView.frame = CGRectMake(_lowerMiddleView.frame.origin.x,_lowerMiddleView.frame.origin.y-increasedHeight, _lowerMiddleView.frame.size.width, _lowerMiddleView.frame.size.height);
                        
                        _lowerView.frame = CGRectMake(_lowerView.frame.origin.x,_lowerView.frame.origin.y-increasedHeight, _lowerView.frame.size.width, _lowerView.frame.size.height);
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
                            
                            firstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                            
                            [self.firstNameTextField.layer addSublayer:firstNameLayer];
                        }];
                        
                    }
                    previousRectFirstName = currentRect;
                }
            }
            else
            {
                _upperView.frame = CGRectMake(_upperView.frame.origin.x, _upperView.frame.origin.y, _upperView.frame.size.width, _upperView.frame.size.height);
                _upperMiddleView.frame = CGRectMake(_upperMiddleView.frame.origin.x,_upperMiddleView.frame.origin.y, _upperMiddleView.frame.size.width, _upperMiddleView.frame.size.height);
                
                _lowerMiddleView.frame = CGRectMake(_lowerMiddleView.frame.origin.x,_lowerMiddleView.frame.origin.y, _lowerMiddleView.frame.size.width, _lowerMiddleView.frame.size.height);
                
                _lowerView.frame = CGRectMake(_lowerView.frame.origin.x,_lowerView.frame.origin.y, _lowerView.frame.size.width, _lowerView.frame.size.height);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    
                    firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
                    
                    firstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                    
                    [self.firstNameTextField.layer addSublayer:firstNameLayer];
                }];
                
            }
        }
        else if(txtView == _surNameTextField)
        {
            if(txtView.frame.size.height > _firstNameTextField.frame.size.height)
            {
                
                if (txtView.frame.size.height >33)
                {
                    UITextPosition* pos = txtView.endOfDocument;
                    CGRect currentRect = [txtView caretRectForPosition:pos];
                    
                    if (currentRect.origin.y > previousRectSurName.origin.y)
                    {
                        
                        CGFloat increasedHeight = currentRect.origin.y -previousRectSurName.origin.y ;
                        
                        _upperView.frame = CGRectMake(_upperView.frame.origin.x, _upperView.frame.origin.y, _upperView.frame.size.width, _upperView.frame.size.height+increasedHeight);
                        
                        _upperMiddleView.frame = CGRectMake(_upperMiddleView.frame.origin.x,_upperMiddleView.frame.origin.y+increasedHeight, _upperMiddleView.frame.size.width, _upperMiddleView.frame.size.height);
                        
                        _lowerMiddleView.frame = CGRectMake(_lowerMiddleView.frame.origin.x,_lowerMiddleView.frame.origin.y+increasedHeight, _lowerMiddleView.frame.size.width, _lowerMiddleView.frame.size.height);
                        
                        _lowerView.frame = CGRectMake(_lowerView.frame.origin.x,_lowerView.frame.origin.y+increasedHeight, _lowerView.frame.size.width, _lowerView.frame.size.height);
                        
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
                            
                            surNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                            
                            [self.surNameTextField.layer addSublayer:surNameLayer];
                            
                        }];
                    }
                    else
                    {
                        CGFloat increasedHeight = previousRectSurName.origin.y-currentRect.origin.y ;
                        _upperView.frame = CGRectMake(_upperView.frame.origin.x, _upperView.frame.origin.y, _upperView.frame.size.width, _upperView.frame.size.height-increasedHeight);
                        _upperMiddleView.frame = CGRectMake(_upperMiddleView.frame.origin.x,_upperMiddleView.frame.origin.y-increasedHeight, _upperMiddleView.frame.size.width, _upperMiddleView.frame.size.height);
                        
                        _lowerMiddleView.frame = CGRectMake(_lowerMiddleView.frame.origin.x,_lowerMiddleView.frame.origin.y-increasedHeight, _lowerMiddleView.frame.size.width, _lowerMiddleView.frame.size.height);
                        
                        _lowerView.frame = CGRectMake(_lowerView.frame.origin.x,_lowerView.frame.origin.y-increasedHeight, _lowerView.frame.size.width, _lowerView.frame.size.height);
                        
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
                            
                            surNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                            [self.surNameTextField.layer addSublayer:surNameLayer];
                            
                        }];
                    }
                    previousRectSurName = currentRect;
                }
            }
            else
            {
                _upperView.frame = CGRectMake(_upperView.frame.origin.x, _upperView.frame.origin.y, _upperView.frame.size.width, _upperView.frame.size.height);
                _upperMiddleView.frame = CGRectMake(_upperMiddleView.frame.origin.x,_upperMiddleView.frame.origin.y, _upperMiddleView.frame.size.width, _upperMiddleView.frame.size.height);
                
                _lowerMiddleView.frame = CGRectMake(_lowerMiddleView.frame.origin.x,_lowerMiddleView.frame.origin.y, _lowerMiddleView.frame.size.width, _lowerMiddleView.frame.size.height);
                
                _lowerView.frame = CGRectMake(_lowerView.frame.origin.x,_lowerView.frame.origin.y, _lowerView.frame.size.width, _lowerView.frame.size.height);
                
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    
                    surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
                    
                    surNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                    
                    [self.surNameTextField.layer addSublayer:surNameLayer];
                }];
            }
        }
        else if (txtView == _physicalAddressTextField)
        {
            
            if (txtView.frame.size.height > 35)
            {
                
                UITextPosition* pos = txtView.endOfDocument;
                CGRect currentRect = [txtView caretRectForPosition:pos];
                
                if (currentRect.origin.y > previousRectPhysicalAddress.origin.y)
                {
                    
                    CGFloat increasedHeight = currentRect.origin.y -previousRectPhysicalAddress.origin.y ;
                    
                    _upperView.frame = CGRectMake(_upperView.frame.origin.x, _upperView.frame.origin.y, _upperView.frame.size.width, _upperView.frame.size.height);
                    
                    _upperMiddleView.frame = CGRectMake(_upperMiddleView.frame.origin.x,_upperMiddleView.frame.origin.y, _upperMiddleView.frame.size.width, _upperMiddleView.frame.size.height);
                    
                    _lowerMiddleView.frame = CGRectMake(_lowerMiddleView.frame.origin.x,_lowerMiddleView.frame.origin.y, _lowerMiddleView.frame.size.width, _lowerMiddleView.frame.size.height+increasedHeight);
                    
                    _lowerView.frame = CGRectMake(_lowerView.frame.origin.x,_lowerView.frame.origin.y+increasedHeight, _lowerView.frame.size.width, _lowerView.frame.size.height);
                    
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
                        
                        physicalAddressLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                        [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
                        
                    }];
                }
                else
                {
                    CGFloat increasedHeight = previousRectPhysicalAddress.origin.y-currentRect.origin.y ;
                    _upperView.frame = CGRectMake(_upperView.frame.origin.x, _upperView.frame.origin.y, _upperView.frame.size.width, _upperView.frame.size.height);
                    _upperMiddleView.frame = CGRectMake(_upperMiddleView.frame.origin.x,_upperMiddleView.frame.origin.y, _upperMiddleView.frame.size.width, _upperMiddleView.frame.size.height);
                    _lowerView.frame = CGRectMake(_lowerView.frame.origin.x,_lowerView.frame.origin.y-increasedHeight, _lowerView.frame.size.width, _lowerView.frame.size.height);
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
                        
                        physicalAddressLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                        
                        [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
                    }];
                }
                previousRectPhysicalAddress = currentRect;
            }
            
            else
            {
                
                _upperView.frame = CGRectMake(_upperView.frame.origin.x, _upperView.frame.origin.y, _upperView.frame.size.width, _upperView.frame.size.height);
                
                _upperMiddleView.frame = CGRectMake(_upperMiddleView.frame.origin.x,_upperMiddleView.frame.origin.y, _upperMiddleView.frame.size.width, _upperMiddleView.frame.size.height);
                
                _lowerView.frame = CGRectMake(_lowerView.frame.origin.x,_lowerView.frame.origin.y, _lowerView.frame.size.width, _lowerView.frame.size.height);
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
                    
                    physicalAddressLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
                    
                    [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
                }];
            }
        }
        
        return YES;
    }
    [txtView resignFirstResponder];
    return NO;
}

- (CGRect)contentSizeRectForTextView:(UITextView *)textView
{
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    CGRect textBounds = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    CGFloat width =  (CGFloat)ceil(textBounds.size.width + textView.textContainerInset.left + textView.textContainerInset.right);
    CGFloat height = (CGFloat)ceil(textBounds.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom);
    return CGRectMake(0, 0, width, height);
}

-(void)keyboardWillHide
{
    float sizeOfContent = 0;
    NSInteger wd = _lowerView.frame.origin.y;
    NSInteger ht = _lowerView.frame.size.height;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

#pragma mark ######
#pragma mark Guesture Regonizer method
#pragma mark ######

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)DidRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    [self.view endEditing:YES];
    
    UILabel *label = (UILabel*)[gesture view];
    if ( label.tag == 1)
    {
        _firstNameLbl.hidden = YES;
        _firstNameLblHeading.hidden= NO;
        
        firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
        firstNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.firstNameTextField.layer addSublayer:firstNameLayer];
        
        [_firstNameTextField becomeFirstResponder];
        if ([ _surNameTextField.text isEqual:@""]) {
            _surNameLbl.hidden = NO;
            _surNameLblHeading.hidden= YES;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            [_surNameTextField resignFirstResponder];
        }
        else
        {
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            _surNameLblHeading.textColor = [UIColor whiteColor];
        }
        if ([ _emailAddressTextField.text isEqual:@""]) {
            _emailAddressLbl.hidden = NO;
            _emailAddressLblHeading.hidden = YES;
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            
            [_emailAddressTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
        }
        if (![ _phoneNumberTextField.text isEqual:@""]) {
            _phoneNumberLbl.hidden = NO;
            _phoneNumberLblHeading.hidden = NO;
            
            CALayer *FirstNameLayer3 = [CALayer layer];
            FirstNameLayer3.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer3.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer3];
            
            [_phoneNumberTextField resignFirstResponder];
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
        }
        if ([ _physicalAddressTextField.text isEqual:@""]) {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            [_physicalAddressTextField resignFirstResponder];
        }
        else
        {
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            
        }
        if ([ _passwordTextField.text isEqual:@""]) {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            [_passwordTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            _passwordLblheading.textColor = [UIColor whiteColor];
            
        }
        if ([_repeatPasswordTextField.text isEqual:@""]) {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            [_repeatPasswordTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
        }
        
        if ([_referralCodeTextField.text isEqual:@""]) {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            [_referralCodeTextField resignFirstResponder];
        }
        else
        {
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
        }
    }
    if ( label.tag == 2)
    {
        _surNameLbl.hidden = YES;
        _surNameLblHeading.hidden= NO;
        
        [_surNameTextField becomeFirstResponder];
        
        surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
        surNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.surNameTextField.layer addSublayer:surNameLayer];
        
        if ([ _firstNameTextField.text isEqual:@""]) {
            _firstNameLbl.hidden = NO;
            _firstNameLblHeading.hidden= YES;
            
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            [_firstNameTextField resignFirstResponder];
        }
        else
        {
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            _firstNameLblHeading.textColor = [UIColor whiteColor];
        }
        if ([ _emailAddressTextField.text isEqual:@""]) {
            _emailAddressLbl.hidden = NO;
            _emailAddressLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            [_emailAddressTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
        }
        if (![ _phoneNumberTextField.text isEqual:@""]) {
            _phoneNumberLbl.hidden = NO;
            _phoneNumberLblHeading.hidden = NO;
            
            CALayer *FirstNameLayer3 = [CALayer layer];
            FirstNameLayer3.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer3.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer3];
            [_phoneNumberTextField resignFirstResponder];
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            
        }
        
        if ([ _physicalAddressTextField.text isEqual:@""]) {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            
            
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            
            [_physicalAddressTextField resignFirstResponder];
        }
        else
        {
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            
        }
        if ([ _passwordTextField.text isEqual:@""]) {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            
            [_passwordTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            
            _passwordLblheading.textColor = [UIColor whiteColor];
            
        }
        if ([_repeatPasswordTextField.text isEqual:@""]) {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            
            [_repeatPasswordTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
        }
        if ([_referralCodeTextField.text isEqual:@""]) {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
            [_referralCodeTextField resignFirstResponder];
            
        }
        else
        {
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
        }
    }
    if ( label.tag == 3)
    {
        _emailAddressLbl.hidden = YES;
        _emailAddressLblHeading.hidden = NO ;
        [_emailAddressTextField becomeFirstResponder];
        CALayer *FirstNameLayer14 = [CALayer layer];
        FirstNameLayer14.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
        FirstNameLayer14.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.emailAddressTextField.layer addSublayer:FirstNameLayer14];
        
        if ([ _firstNameTextField.text isEqual:@""]) {
            _firstNameLbl.hidden = NO;
            _firstNameLblHeading.hidden= YES;
            
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            [_firstNameTextField resignFirstResponder];
        }
        else
        {
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            
        }
        if ([ _surNameTextField.text isEqual:@""]) {
            _surNameLbl.hidden = NO;
            _surNameLblHeading.hidden= YES;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            
            [_surNameTextField resignFirstResponder];
            
        }
        else
        {
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            
            _surNameLblHeading.textColor = [UIColor whiteColor];
        }
        
        if (![ _phoneNumberTextField.text isEqual:@""]) {
            _phoneNumberLbl.hidden = NO;
            _phoneNumberLblHeading.hidden = NO;
            
            CALayer *FirstNameLayer3 = [CALayer layer];
            FirstNameLayer3.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer3.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer3];
            
            [_phoneNumberTextField resignFirstResponder];
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            
        }
        
        if ([ _physicalAddressTextField.text isEqual:@""]) {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            
            
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            
            [_physicalAddressTextField resignFirstResponder];
        }
        else
        {
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            
        }
        if ([ _passwordTextField.text isEqual:@""]) {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            
            [_passwordTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            
            _passwordLblheading.textColor = [UIColor whiteColor];
            
        }
        
        if ([_repeatPasswordTextField.text isEqual:@""]) {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            
            [_repeatPasswordTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            
        }
        
        if ([_referralCodeTextField.text isEqual:@""]) {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            [_referralCodeTextField resignFirstResponder];
        }
        else
        {
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
        }
    }
    if ( label.tag == 4)
    {
        _phoneNumberLbl.hidden = YES;
        _phoneNumberLblHeading.hidden = NO;
        [_phoneNumberTextField becomeFirstResponder];
        CALayer *FirstNameLayer7 = [CALayer layer];
        FirstNameLayer7.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
        FirstNameLayer7.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.phoneNumberTextField.layer addSublayer:FirstNameLayer7];
        if ([ _firstNameTextField.text isEqual:@""]) {
            _firstNameLbl.hidden = NO;
            _firstNameLblHeading.hidden= YES;
            
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            [_firstNameTextField resignFirstResponder];
        }
        else
        {
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            
        }
        if ([ _surNameTextField.text isEqual:@""]) {
            _surNameLbl.hidden = NO;
            _surNameLblHeading.hidden= YES;
            
            
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            
            [_surNameTextField resignFirstResponder];
            
        }
        else
        {
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            
            _surNameLblHeading.textColor = [UIColor whiteColor];
        }
        
        if ([ _physicalAddressTextField.text isEqual:@""]) {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            
            
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            
            [_physicalAddressTextField resignFirstResponder];
        }
        else
        {
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
            
        }
        if ([ _passwordTextField.text isEqual:@""]) {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            
            [_passwordTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            _passwordLblheading.textColor = [UIColor whiteColor];
            
        }
        if ([_repeatPasswordTextField.text isEqual:@""]) {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            
            [_repeatPasswordTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            
        }
        
        if ([_referralCodeTextField.text isEqual:@""]) {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
            [_referralCodeTextField resignFirstResponder];
            
        }
        else
        {
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
        }
    }
    if ( label.tag == 5)
    {
        _physicalAddressLbl.hidden = YES;
        _physicalAddressLblHeading.hidden = NO;
        
        [_physicalAddressTextField becomeFirstResponder];
        
        physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
        physicalAddressLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
        
        if ([ _firstNameTextField.text isEqual:@""]) {
            _firstNameLbl.hidden = NO;
            _firstNameLblHeading.hidden= YES;
            
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            [_firstNameTextField resignFirstResponder];
        }
        else
        {
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            
        }
        if ([ _surNameTextField.text isEqual:@""]) {
            _surNameLbl.hidden = NO;
            _surNameLblHeading.hidden= YES;
            
            
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            
            [_surNameTextField resignFirstResponder];
            
        }
        else
        {
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            
            _surNameLblHeading.textColor = [UIColor whiteColor];
        }
        
        if ([ _emailAddressTextField.text isEqual:@""]) {
            _emailAddressLbl.hidden = NO;
            _emailAddressLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            
            [_emailAddressTextField resignFirstResponder];
            
            
        }
        else
        {
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
        }
        
        
        if (![ _phoneNumberTextField.text isEqual:@""]) {
            _phoneNumberLbl.hidden = NO;
            _phoneNumberLblHeading.hidden = NO;
            
            CALayer *FirstNameLayer3 = [CALayer layer];
            FirstNameLayer3.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer3.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer3];
            
            [_phoneNumberTextField resignFirstResponder];
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            
        }
        
        if ([ _passwordTextField.text isEqual:@""]) {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            
            [_passwordTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            
            _passwordLblheading.textColor = [UIColor whiteColor];
            
        }
        
        if ([_repeatPasswordTextField.text isEqual:@""]) {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            
            [_repeatPasswordTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
            
        }
        
        if ([_referralCodeTextField.text isEqual:@""]) {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
            [_referralCodeTextField resignFirstResponder];
            
        }
        else
        {
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
            
        }
    }
    
    if ( label.tag == 6)
    {
        _passwordLbl.hidden = YES;
        _passwordLblheading.hidden = NO;
        
        [_passwordTextField becomeFirstResponder];
        
        CALayer *FirstNameLayer11 = [CALayer layer];
        FirstNameLayer11.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
        FirstNameLayer11.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.passwordTextField.layer addSublayer:FirstNameLayer11];
        
        if ([ _firstNameTextField.text isEqual:@""]) {
            _firstNameLbl.hidden = NO;
            _firstNameLblHeading.hidden= YES;
            
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            [_firstNameTextField resignFirstResponder];
        }
        else
        {
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            
        }
        if ([ _surNameTextField.text isEqual:@""]) {
            _surNameLbl.hidden = NO;
            _surNameLblHeading.hidden= YES;
            
            
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            
            [_surNameTextField resignFirstResponder];
            
        }
        else
        {
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            
            _surNameLblHeading.textColor = [UIColor whiteColor];
        }
        
        if ([ _emailAddressTextField.text isEqual:@""]) {
            _emailAddressLbl.hidden = NO;
            _emailAddressLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            
            [_emailAddressTextField resignFirstResponder];
            
            
        }
        else
        {
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
        }
        
        
        if (![ _phoneNumberTextField.text isEqual:@""]) {
            _phoneNumberLbl.hidden = NO;
            _phoneNumberLblHeading.hidden = NO;
            
            CALayer *FirstNameLayer3 = [CALayer layer];
            FirstNameLayer3.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer3.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer3];
            
            [_phoneNumberTextField resignFirstResponder];
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
            
            
        }
        
        if ([ _physicalAddressTextField.text isEqual:@""]) {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            
            [_physicalAddressTextField resignFirstResponder];
        }
        else
        {
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
        }
        
        if ([_repeatPasswordTextField.text isEqual:@""]) {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            [_repeatPasswordTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
        }
        
        if ([_referralCodeTextField.text isEqual:@""]) {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            [_referralCodeTextField resignFirstResponder];
            
        }
        else
        {
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
        }
    }
    if ( label.tag == 7)
    {
        _repeatPasswordLbl.hidden = YES;
        _repeatPasswordLblHeading.hidden = NO;
        [_repeatPasswordTextField becomeFirstResponder];
        CALayer *FirstNameLayer10 = [CALayer layer];
        FirstNameLayer10.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
        FirstNameLayer10.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer10];
        
        if ([ _firstNameTextField.text isEqual:@""]) {
            _firstNameLbl.hidden = NO;
            _firstNameLblHeading.hidden= YES;
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            [_firstNameTextField resignFirstResponder];
        }
        else
        {
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            _firstNameLblHeading.textColor = [UIColor whiteColor];
        }
        if ([ _surNameTextField.text isEqual:@""]) {
            _surNameLbl.hidden = NO;
            _surNameLblHeading.hidden= YES;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            [_surNameTextField resignFirstResponder];
        }
        else
        {
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            _surNameLblHeading.textColor = [UIColor whiteColor];
        }
        
        if ([ _emailAddressTextField.text isEqual:@""]) {
            _emailAddressLbl.hidden = NO;
            _emailAddressLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            
            [_emailAddressTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
        }
        if (![ _phoneNumberTextField.text isEqual:@""]) {
            _phoneNumberLbl.hidden = NO;
            _phoneNumberLblHeading.hidden = NO;
            CALayer *FirstNameLayer3 = [CALayer layer];
            FirstNameLayer3.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer3.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer3];
            [_phoneNumberTextField resignFirstResponder];
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
        }
        if ([ _physicalAddressTextField.text isEqual:@""]) {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            [_physicalAddressTextField resignFirstResponder];
        }
        else
        {
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
        }
        if ([ _passwordTextField.text isEqual:@""]) {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            [_passwordTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            _passwordLblheading.textColor = [UIColor whiteColor];
        }
        if ([_referralCodeTextField.text isEqual:@""]) {
            _referralCodeLbl.hidden = NO;
            _referralCodeLblHeading.hidden = YES;
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            [_referralCodeTextField resignFirstResponder];
            
        }
        else
        {
            referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
            referralCodeLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
            
            _referralCodeLblHeading.textColor = [UIColor whiteColor];
        }
    }
    if ( label.tag == 8)
    {
        _referralCodeLbl.hidden = YES;
        _referralCodeLblHeading.hidden = NO;
        [_referralCodeTextField becomeFirstResponder];
        referralCodeLayer.frame = CGRectMake(0.0f, self.referralCodeTextField.frame.size.height - 1, self.referralCodeTextField.frame.size.width, 1.0f);
        referralCodeLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.referralCodeTextField.layer addSublayer:referralCodeLayer];
        
        if ([ _firstNameTextField.text isEqual:@""]) {
            _firstNameLbl.hidden = NO;
            _firstNameLblHeading.hidden= YES;
            
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            [_firstNameTextField resignFirstResponder];
        }
        else
        {
            firstNameLayer.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
            firstNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.firstNameTextField.layer addSublayer:firstNameLayer];
            _firstNameLblHeading.textColor = [UIColor whiteColor];
            
        }
        if ([ _surNameTextField.text isEqual:@""]) {
            _surNameLbl.hidden = NO;
            _surNameLblHeading.hidden= YES;
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            
            [_surNameTextField resignFirstResponder];
        }
        else
        {
            surNameLayer.frame = CGRectMake(0.0f, self.surNameTextField.frame.size.height - 1, self.surNameTextField.frame.size.width, 1.0f);
            surNameLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.surNameTextField.layer addSublayer:surNameLayer];
            _surNameLblHeading.textColor = [UIColor whiteColor];
        }
        
        if ([ _emailAddressTextField.text isEqual:@""]) {
            _emailAddressLbl.hidden = NO;
            _emailAddressLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            
            [_emailAddressTextField resignFirstResponder];
            
        }
        else
        {
            CALayer *FirstNameLayer2 = [CALayer layer];
            FirstNameLayer2.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            FirstNameLayer2.backgroundColor = [UIColor blackColor].CGColor;
            [self.emailAddressTextField.layer addSublayer:FirstNameLayer2];
            
            _emailAddressLblHeading.textColor = [UIColor whiteColor];
        }
        if (![ _phoneNumberTextField.text isEqual:@""]) {
            _phoneNumberLbl.hidden = NO;
            _phoneNumberLblHeading.hidden = NO;
            
            CALayer *FirstNameLayer3 = [CALayer layer];
            FirstNameLayer3.frame = CGRectMake(0.0f, self.phoneNumberTextField.frame.size.height - 1, self.phoneNumberTextField.frame.size.width, 1.0f);
            FirstNameLayer3.backgroundColor = [UIColor blackColor].CGColor;
            [self.phoneNumberTextField.layer addSublayer:FirstNameLayer3];
            
            [_phoneNumberTextField resignFirstResponder];
            _phoneNumberLblHeading.textColor = [UIColor whiteColor];
        }
        
        if ([ _physicalAddressTextField.text isEqual:@""]) {
            _physicalAddressLbl.hidden = NO;
            _physicalAddressLblHeading.hidden = YES;
            
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            [_physicalAddressTextField resignFirstResponder];
        }
        else
        {
            physicalAddressLayer.frame = CGRectMake(0.0f, self.physicalAddressTextField.frame.size.height - 1, self.physicalAddressTextField.frame.size.width, 1.0f);
            physicalAddressLayer.backgroundColor = [UIColor blackColor].CGColor;
            [self.physicalAddressTextField.layer addSublayer:physicalAddressLayer];
            _physicalAddressLblHeading.textColor = [UIColor whiteColor];
        }
        if ([ _passwordTextField.text isEqual:@""]) {
            _passwordLbl.hidden = NO;
            _passwordLblheading.hidden = YES;
            
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            
            [_passwordTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer5 = [CALayer layer];
            FirstNameLayer5.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
            FirstNameLayer5.backgroundColor = [UIColor blackColor].CGColor;
            [self.passwordTextField.layer addSublayer:FirstNameLayer5];
            _passwordLblheading.textColor = [UIColor whiteColor];
        }
        
        if ([_repeatPasswordTextField.text isEqual:@""]) {
            _repeatPasswordLbl.hidden = NO;
            _repeatPasswordLblHeading.hidden = YES;
            
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            [_repeatPasswordTextField resignFirstResponder];
        }
        else
        {
            CALayer *FirstNameLayer6 = [CALayer layer];
            FirstNameLayer6.frame = CGRectMake(0.0f, self.repeatPasswordTextField.frame.size.height - 1, self.repeatPasswordTextField.frame.size.width, 1.0f);
            FirstNameLayer6.backgroundColor = [UIColor blackColor].CGColor;
            [self.repeatPasswordTextField.layer addSublayer:FirstNameLayer6];
            _repeatPasswordLblHeading.textColor = [UIColor whiteColor];
        }
    }
    
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

@end
