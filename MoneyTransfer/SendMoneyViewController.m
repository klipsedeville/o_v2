//
//  SendMoneyViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 17/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "SendMoneyViewController.h"
#import "BeneficiariesViewController.h"
#import "AddCardViewController.h"
#import "TransferHistoryViewController.h"
#import "LoginViewController.h"
#import "UserProfileViewController.h"
#import "Controller.h"
#import "Constants.h"

@interface SendMoneyViewController ()

@end

@implementation SendMoneyViewController

#pragma mark ######
#pragma mark View life cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    
    transactionRequestArray = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.barTintColor = [self colorWithHexString:@"51595c"];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    _scrollView.bounces = NO;
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    self.logoImageView.hidden = NO;
    
    // Check user Session Expired or not
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
    
    menu = NO;
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    self.navigationController.navigationBarHidden = NO;
    
    // Guesture
    UISwipeGestureRecognizer *swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(swipeleft:)];
    [tap setNumberOfTapsRequired: 1];
    [tap setNumberOfTouchesRequired: 1];
    [self.view addGestureRecognizer: tap];
}

#pragma mark ######
#pragma mark Menu Swipe methods
#pragma mark ######

-(void) hideSlideMenuBar
{
    self.sideView.frame = CGRectMake(-self.sideView.frame.size.width, self.sideView.frame.origin.y, self.sideView.frame.size.width, self.sideView.frame.size.height);
    lineView.hidden = NO;
    self.logoImageView.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (menu)
    {
        CGPoint touchPoint=[gestureRecognizer locationInView:self.sideView];
        
        if (touchPoint.x<= self.sideView.frame.size.width) {
            
        }
        else{
            
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
                self.sideView.frame = CGRectMake(-self.sideView.frame.size.width, self.sideView.frame.origin.y, self.sideView.frame.size.width, self.sideView.frame.size.height);
                
                [self.navigationController setNavigationBarHidden:NO];
                
                lineView.hidden = NO;
                self.logoImageView.hidden = NO;
                
                
            } completion:nil];
            
            menu = NO;
        }
    }
}


#pragma mark #####
#pragma mark Get All Recent Transfer methods
#pragma mark #####

-(void) GetRecentTransferList
{
    // get recent transfer list
    [ Controller getRecentTransactionsWithSuccess:^(id responseObject){
        [HUD removeFromSuperview];
    }andFailure:^(NSString *String)
     {
         NSError *error;
         NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers error:&error];
         NSDictionary *payLoadDic = [ json valueForKey:@"PayLoad"];
         BOOL Status = [[ payLoadDic valueForKey:@"status"] boolValue];
         if ( Status == true) {
             [HUD removeFromSuperview];
         }
         else
         {
             if (Status == 0)
             {
                 NSArray *errorArray =[ payLoadDic valueForKeyPath:@"PayLoad.error"];
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
             NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
             [def setObject:@"YES"  forKey:@"UserLogined"];
         }
         
         [HUD removeFromSuperview];
         
     }];
}

#pragma mark #####
#pragma mark Click Action methods
#pragma mark #####

- (IBAction)viewbtn:(id)sender {
    
    if (menu) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.sideView.frame = CGRectMake(-self.sideView.frame.size.width, self.sideView.frame.origin.y, self.sideView.frame.size.width, self.sideView.frame.size.height);
            [self.view setAlpha:1.0];
            lineView.hidden = NO;
            self.logoImageView.hidden = NO;
        } completion:nil];
        
        menu = NO;
    }
    else
    {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.sideView.frame = CGRectMake(0, self.sideView.frame.origin.y, self.sideView.frame.size.width, self.sideView.frame.size.height);
            [self.view setAlpha:1.6];
            [self.navigationController setNavigationBarHidden:YES];
            lineView.hidden = YES;
            self.logoImageView.hidden = YES;
        } completion:nil];
        menu = YES;
    }
}

- (IBAction)sendMoneyBtn:(id)sender {
    // Send money
    [ self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShowBeneficiary" sender:self];
}

- (IBAction)beneficiariesBtn:(id)sender {
    // beneficiary
    [ self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShowBeneficiary" sender:self];
}

- (IBAction)billersBtn:(id)sender {
    
    // Billers
    [ self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"BillPay" sender:self];
}

- (IBAction)transferHistoryBtn:(id)sender {
    
    // Transfer history
    [ self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShowHistory" sender:self];
}

- (IBAction)profileBtn:(id)sender {
    
    // user profile
    [ self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShowProfile" sender:self];
}

- (IBAction)addCardBtn:(id)sender {
    
    // Add card
    [ self hideSlideMenuBar];
    [self performSegueWithIdentifier:@"ShareOrbo" sender:self];
}
- (IBAction)payBillBtn:(id)sender {
    
    // Pay Bill
    [self performSegueWithIdentifier:@"BillPay" sender:self];
}

- (IBAction)logoutBtn:(id)sender {
    
    // User Logout
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Logout from Orobo?" message:@"Are you sure you want to logout from Orobo ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertview.tag = 1001;
    [alertview show];
    
}

#pragma mark #####
#pragma mark Alert Method
#pragma mark #####

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0)
        {
            NSLog(@"Clicked button index 0");
        }
        else
        {
            NSLog(@"Clicked button index other than 0");
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:@"NO"  forKey:@"UserLogined"];
            
            // Call User logout
            [HUD removeFromSuperview];
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = NSLocalizedString(@"Loading...", nil);
            [HUD show:YES];
            [self logoutUser];
        }
    }
    else if(alertView.tag ==1002)
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
#pragma mark #####
#pragma mark Call user logout method
#pragma mark #####

-(void) logoutUser
{
    // logout
    [HUD removeFromSuperview];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil  forKey:@"loginUserData"];
    [def setObject:nil forKey:@"UserLogined"];
    [def setValue:@"Yes" forKey:@"UserLogout"];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LoginViewController class]]) {
            [self.navigationController popToViewController:controller
                                                  animated:YES];
            [self.navigationController setNavigationBarHidden:NO];
            break;
        }
    }
}

#pragma mark #####
#pragma mark Recent Transaction Table View Method
#pragma mark #####

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [transactionRequestArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *transferReqDic = [transactionRequestArray objectAtIndex:indexPath.row];
    
    UILabel *businessNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,8,70,15)];
    businessNameLabel.textColor = [self colorWithHexString:@"51595c"];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,28,100,15)];
    statusLabel.textColor = [self colorWithHexString:@"51595c"];
    
    UILabel *sendingAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 8,70,20)];
    sendingAmountLabel.textColor = [self colorWithHexString:@"51595c"];
    
    UILabel *dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 28,125,20)];
    dateTimeLabel.textColor = [self colorWithHexString:@"51595c"];
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40,13, 20, 25)];
    imv.image=[UIImage imageNamed:@"arrow.png"];
    
    businessNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    sendingAmountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    
    [statusLabel setFont: [statusLabel.font fontWithSize: 10]];
    [dateTimeLabel setFont: [dateTimeLabel.font fontWithSize: 10]];
    
    NSString *myString = [transferReqDic valueForKeyPath:@"TransferRequest.created"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    if ([[transferReqDic valueForKeyPath:@"TransferRequest.created"] isKindOfClass:[NSNull class]])
    {
        myString = @"null";
    }
    else
    {
        myString = [transferReqDic valueForKeyPath:@"TransferRequest.created"];
    }
    NSDate *yourDate = [dateFormatter dateFromString:myString];
    dateFormatter.dateFormat = @"MMM dd";
    NSDate *yourTime = [dateFormatter1 dateFromString:myString];
    dateFormatter1.dateFormat = @"HH:mm";
    
    NSLog(@"Your date %@",[dateFormatter stringFromDate:yourDate]);
    NSLog(@"Your Time %@",[dateFormatter1 stringFromDate:yourTime]);
    
    
    if ([[transferReqDic valueForKeyPath:@"Beneficiary.business_name"] isKindOfClass:[NSNull class]])
    {
        businessNameLabel.text = @"null";
    }
    else
    {
        businessNameLabel.text = [ NSString stringWithFormat:@"%@",[transferReqDic valueForKeyPath:@"Beneficiary.business_name"]];
    }
    if ([[transferReqDic valueForKeyPath:@"TransferRequest.sending_amount"] isKindOfClass:[NSNull class]])
    {
        sendingAmountLabel.text = @"null";
    }
    else
    {
        sendingAmountLabel.text = [NSString stringWithFormat:@"-%@%@",[transferReqDic valueForKeyPath:@"SendingCurrency.currency_symbol"],[transferReqDic valueForKeyPath:@"TransferRequest.sending_amount"]];
    }
    if ([[transferReqDic valueForKeyPath:@"Status.title"] isKindOfClass:[NSNull class]])
    {
        statusLabel.text = @"null";
    }
    else
    {
        statusLabel.text = [ NSString stringWithFormat:@"%@",[transferReqDic valueForKeyPath:@"Status.title"]];
    }
    if ([[dateFormatter stringFromDate:yourDate] isKindOfClass:[NSNull class]])
    {
        dateTimeLabel.text = @"null";
    }
    else
    {
        dateTimeLabel.text = [ NSString stringWithFormat:@"%@,%@",[dateFormatter stringFromDate:yourDate],[dateFormatter1 stringFromDate:yourTime]];
    }
    businessNameLabel.text = [businessNameLabel.text stringByReplacingOccurrencesOfString:@"<"                                                                 withString:@""];
    businessNameLabel.text = [businessNameLabel.text stringByReplacingOccurrencesOfString:@">"                                                                 withString:@""];
    
    
    NSLog(@"businessName ...%@",businessNameLabel.text);
    NSLog(@"sending Amount ...%@",sendingAmountLabel.text);
    NSLog(@"status ...%@",statusLabel.text);
    NSLog(@"DateTime ...%@",dateTimeLabel.text);
    
    [cell.contentView addSubview:businessNameLabel];
    [cell.contentView addSubview:statusLabel];
    [cell.contentView addSubview:sendingAmountLabel];
    [cell.contentView addSubview:dateTimeLabel];
    [cell.contentView addSubview:imv];
    
    return cell;
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

@end

