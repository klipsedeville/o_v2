//
//  AddBeneFiciaryViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 19/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "AddBeneFiciaryViewController.h"
#import "SendMoneyViewController.h"
#import "ChannelViewController.h"
#import "Controller.h"
#import "BeneficiariesViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "AppDelegate.h"
#import <ContactsUI/ContactsUI.h>
#import "AsyncImageView.h"

@interface AddBeneFiciaryViewController ()<ABPeoplePickerNavigationControllerDelegate,CNContactViewControllerDelegate,CNContactPickerDelegate>
{
    AppDelegate *appDel;
}

@end

@implementation AddBeneFiciaryViewController

#pragma mark ######
#pragma mark View life cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _countryNameTextField.hidden = YES;
    
    benificiaryData = [[NSMutableDictionary alloc]init];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailAddressTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    self.addressTextView.delegate = self;
    
    previousRect = CGRectZero;
    
    allCurrencyArray = [[NSMutableArray alloc]init];
    
    _currencyTableView=[[UITableView alloc]initWithFrame:CGRectMake(195,8,80,35) style:UITableViewStylePlain];
    
    _currencyTableView.delegate=self;
    _currencyTableView.dataSource=self;
    [_currencyTableView setAllowsSelection:YES];
    [_currencyTableView setScrollEnabled:YES];
    [self.scrollView addSubview:_currencyTableView];
    _currencyTableView.backgroundColor=[UIColor grayColor];
    _currencyTableView.layer.cornerRadius = 0.0;
    _currencyTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _currencyTableView.layer.borderWidth= 0.5;
    _currencyTableView.hidden = YES;
    _currencyTableView.bounces=NO;
    
    _scrollView.bounces = NO;
    
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_emailAddressTextField resignFirstResponder];
    [_phoneNumberTextField resignFirstResponder];
    [_addressTextView resignFirstResponder];
    
    self.firstNameTextField.text = @"";
    self.lastNameTextField.text = @"";
    self.emailAddressTextField.text = @"";
    self.phoneNumberTextField.text = @"";
    self.addressTextView.text = @"";
    
    UIColor *color = [self colorWithHexString:@"51595c"];
    _firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color}];
    
    _lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
    _emailAddressTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    _phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: color}];
    _addressTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Physical Address" attributes:@{NSForegroundColorAttributeName: color}];
    
    // Call Receiving Currency List
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    [self getReceivingCurrencyList];
    
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
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 350);
    
    // Add tool bar on number key pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _firstNameTextField.inputAccessoryView = numberToolbar;
    _lastNameTextField.inputAccessoryView = numberToolbar;
    _emailAddressTextField.inputAccessoryView = numberToolbar;
    _phoneNumberTextField.inputAccessoryView = numberToolbar;
    _addressTextView.inputAccessoryView = numberToolbar;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.currencyTableView]) {
        return NO;
    }
    return YES;
}

#pragma mark ######
#pragma mark Get Receiving Curreny List
#pragma mark ######

-(void) getReceivingCurrencyList
{
    // get receiving Currency list
    [Controller getAllReceivingCurrencyWithSuccess:^(id responseObject){
        
        NSDictionary *Data = [responseObject valueForKey:@"PayLoad"];
        NSDictionary *currencyData = [ Data valueForKey:@"data"];
        allCurrencyArray = [ currencyData valueForKey:@"currencies"];
        
        NSDictionary *dict = [ allCurrencyArray objectAtIndex:0];
        _currencyIDLbl.text = [dict valueForKey:@"currency_code"];
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

#pragma mark ######
#pragma mark Alert Method
#pragma mark ######

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

#pragma mark #############
#pragma mark Click Action Menthods
#pragma mark ######

- (IBAction)currencyBtnClicked:(id)sender
{
    // Currency Button Click
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_emailAddressTextField resignFirstResponder];
    [_phoneNumberTextField resignFirstResponder];
    [_addressTextView resignFirstResponder];
    
    if (allCurrencyArray == NULL)
    {
        _currencyTableView.hidden = YES;
    }
    else if (_currencyTableView.hidden == YES) {
        self.scrollView.scrollEnabled = NO;
        _currencyTableView.frame =CGRectMake(195,8,80,35*(allCurrencyArray.count));
        _currencyTableView.hidden = NO;
        [_currencyTableView reloadData];
    }
    else{
        self.scrollView.scrollEnabled = YES;
        _currencyTableView.hidden = YES;
    }
}
#pragma mark ######
#pragma mark Continue click action method
#pragma mark ######

- (IBAction)continueBtnClicked:(id)sender {
    
    // Continue Button
    [self resignFirstResponder];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    
    NSString *firstName = [self.firstNameTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *lastName = [self.lastNameTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *emailAddress = [self.emailAddressTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *phoneNumber = [self.phoneNumberTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *Address = [self.addressTextView.text stringByTrimmingCharactersInSet:whitespace];
    
    if([firstName length] == 0)
    {
        // If First name empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Provide a first name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
        
    }
    else if ([lastName length] == 0)
    {
        // If last name empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Provide a last name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
        
    }
    else if ([emailAddress length] == 0)
    {
        // If email Address empty
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Provide an email address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertview show];
        
    }
    
    else if([emailAddress length] > 0)
    {
        // If email is valid or Not
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        int checkValue = [emailTest evaluateWithObject:self.emailAddressTextField.text];
        if (checkValue==0)
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Please enter a valid email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertview show];
            
        }
        else if ([phoneNumber length] == 0)
        {
            // If Phone numberis empty
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Provide a  phone Number." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertview show];
            
        }
        else
        {
            [benificiaryData setValue:firstName forKey:@"firstName"];
            [benificiaryData setValue:lastName forKey:@"lastName"];
            [benificiaryData setValue:emailAddress forKey:@"emailAddress"];
            [benificiaryData setValue:phoneNumber forKey:@"phoneNumber"];
            [benificiaryData setValue:Address forKey:@"Address"];
            [benificiaryData setValue:selectCountryCode forKey:@"countryId"];
            [benificiaryData setValue:selectedCountryName forKey:@"CountryName"];
            NSLog(@"Save Benificiary Data .....%@",benificiaryData);
            [self performSegueWithIdentifier:@"ShowChannel" sender:self];
        }
    }
}
- (IBAction)beneficiaryBtnClicked:(id)sender {
    
    // Address Book
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
        
        // When IOS version greator than Equal to 10
        CNContactPickerViewController * picker = [[CNContactPickerViewController alloc] init];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        // When IOS version less than 10
        ABPeoplePickerNavigationController *personPicker = [ABPeoplePickerNavigationController new];
        personPicker.peoplePickerDelegate = self;
        [self presentViewController:personPicker animated:YES completion:nil];
    }
}

- (IBAction)backBtnClicked:(id)sender {
    
    // back button
    [ self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark ######
#pragma mark Segue method
#pragma mark ######

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue to Settlement Channel  screen");
    if([[segue identifier] isEqualToString:@"ShowChannel"]){
        ChannelViewController *vc = [segue destinationViewController];
        vc.userData = benificiaryData;
    }
}

#pragma mark #############
#pragma mark CNContactpicker delegate Menthods
#pragma mark ######

-(void) contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    NSLog(@"Contact : %@",contact);
    
    _firstNameTextField.text = contact.givenName;
    _lastNameTextField.text = contact.familyName;
    
    NSArray <CNLabeledValue<CNPhoneNumber *> *> *phoneNumbers = contact.phoneNumbers;
    CNLabeledValue<CNPhoneNumber *> *firstPhone = [phoneNumbers firstObject];
    CNPhoneNumber *number = firstPhone.value;
    _phoneNumberTextField.text = number.stringValue;
    
    NSArray <CNLabeledValue *> *emailAddresses = contact.emailAddresses;
    CNLabeledValue *emailAdd = [emailAddresses firstObject];
    
    _emailAddressTextField.text = emailAdd.value;
    
}

-(void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    NSLog(@"Cancelled");
}


#pragma mark #############
#pragma mark Address Book Delegate Menthods
#pragma mark ######

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person;
{
    // Show Contact Detail on Text field
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person];
    
    NSString *firstName = [NSString stringWithFormat:@"%@",ABRecordCopyValue(person, kABPersonFirstNameProperty)];
    NSString *lastName = [NSString stringWithFormat:@"%@",ABRecordCopyValue(person, kABPersonLastNameProperty)];
    
    ABMultiValueRef phoneRecord = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phoneRecord, 0);
    ABMultiValueRef emailRecord = ABRecordCopyValue(person, kABPersonEmailProperty);
    CFStringRef emailAddress = ABMultiValueCopyValueAtIndex(emailRecord, 0);
    
    _phoneNumberTextField.text = [NSString stringWithFormat:@"%@",phoneNumber];
    _firstNameTextField.text = firstName;
    _lastNameTextField.text = lastName;
    _emailAddressTextField.text =[NSString stringWithFormat:@"%@",emailAddress];
    
    if ([_phoneNumberTextField.text isEqualToString:@"(null)"])
    {
        _phoneNumberTextField.text = @"";
    }
    if ([_firstNameTextField.text isEqualToString:@"(null)"])
    {
        _firstNameTextField.text = @"";
    }
    if ([_lastNameTextField.text isEqualToString:@"(null)"])
    {
        _lastNameTextField.text = @"";
    }
    if ([_emailAddressTextField.text isEqualToString:@"(null)"])
    {
        _emailAddressTextField.text = @"";
    }
    
    // Dismiss the contacts view controller.
    [self dismissViewControllerAnimated:NO completion:^(){}];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:NO completion:^(){}];
}

#pragma mark ######
#pragma mark Table View delegate methods
#pragma mark ######

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
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    NSDictionary *dict;
    dict = [allCurrencyArray objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 70, 30)];
    
    titleLabel.textColor = [self colorWithHexString:@"51595c"];
    [titleLabel setFont:[UIFont fontWithName:@"flama" size:15]];
    titleLabel.text = [dict valueForKey:@"currency_code"];
    [cell.contentView addSubview:titleLabel];
    
    
    AsyncImageView *iconImage = [[AsyncImageView alloc] init];
    iconImage.frame = CGRectMake(5,10,20, 20);
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
    _currencyTableView.hidden = YES;
    self.scrollView.scrollEnabled = YES;
    
}

#pragma mark ###########
#pragma mark Text Field delegate methods
#pragma mark ######

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width,350)];
    if (textField == _firstNameTextField)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_firstNameTextField.frame.origin.x, _firstNameTextField.frame.origin.y+50, _firstNameTextField.frame.size.width, _firstNameTextField.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _lastNameTextField)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_lastNameTextField.frame.origin.x, _lastNameTextField.frame.origin.y+50, _lastNameTextField.frame.size.width, _lastNameTextField.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _emailAddressTextField)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_emailAddressTextField.frame.origin.x, _emailAddressTextField.frame.origin.y+50, _emailAddressTextField.frame.size.width, _emailAddressTextField.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _phoneNumberTextField)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_phoneNumberTextField.frame.origin.x, _phoneNumberTextField.frame.origin.y+50, _phoneNumberTextField.frame.size.width, _phoneNumberTextField.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
    else if (textField == _addressTextView)
    {
        UIView *tempVW = [[ UIView alloc] init];
        tempVW.frame = CGRectMake(_addressTextView.frame.origin.x, _addressTextView.frame.origin.y+50, _addressTextView.frame.size.width, _addressTextView.frame.size.height );
        [self scrollViewToCenterOfScreen:tempVW];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    float sizeOfContent = 0;
    NSInteger wd = _lowerView.frame.origin.y;
    NSInteger ht = _lowerView.frame.size.height;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    //    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 350);
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

#pragma mark ######
#pragma mark Scroll View methods
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

