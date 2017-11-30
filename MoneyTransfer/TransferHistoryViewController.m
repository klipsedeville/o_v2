//
//  TransferHistoryViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 23/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "TransferHistoryViewController.h"
#import "SendMoneyViewController.h"
#import "Controller.h"
#import "LoginViewController.h"
#import "TransferPendingViewController.h"
#import "PaymentPendingViewController.h"
#import "NSData+Base64.h"

@interface TransferHistoryViewController ()

@end

@implementation TransferHistoryViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorColor = [UIColor clearColor];
   }

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    transferHistoryArray = [[NSMutableArray alloc]init];
    
    // Get recent  transfer list
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Fetching ...", nil);
    [HUD show:YES];
    [ self GetRecentTransferList];
    
    if ([transferHistoryArray count] == 0) {
        
        _tableView.hidden = YES;
    }
    else
    {
        _tableView.hidden = NO;
    }
    
    _transferView.backgroundColor = [UIColor colorWithRed:69.0/255.0 green:192.0/255.0 blue:235.0/255.0 alpha:1.0] ;
    
    _billView.backgroundColor = [UIColor colorWithRed:16.0/255.0 green:80.0/255.0 blue:107.0/255.0 alpha:1.0];

    // Check user session Expire or Not
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
    
    }

#pragma  mark ############
#pragma Click Action Method
#pragma  mark ############

- (IBAction)backBtnClicked:(id)sender {
    
    // back button
    [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ActionTransferBtn:(id)sender {
    
    _transferView.backgroundColor = [UIColor colorWithRed:69.0/255.0 green:192.0/255.0 blue:235.0/255.0 alpha:1.0] ;
    
    _billView.backgroundColor = [UIColor colorWithRed:16.0/255.0 green:80.0/255.0 blue:107.0/255.0 alpha:1.0];
    
    [transferHistoryArray removeAllObjects];
    
    // Get recent  transfer list
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Fetching ...", nil);
    [HUD show:YES];
    [ self GetRecentTransferList];
    
    if ([transferHistoryArray count] == 0) {
        
        _tableView.hidden = YES;
    }
    else
    {
        _tableView.hidden = NO;
    }

}

- (IBAction)ActionBillBtn:(id)sender {
    
    _transferView.backgroundColor = [UIColor colorWithRed:16.0/255.0 green:80.0/255.0 blue:107.0/255.0 alpha:1.0];
    
    _billView.backgroundColor = [UIColor colorWithRed:69.0/255.0 green:192.0/255.0 blue:235.0/255.0 alpha:1.0] ;
    
     [transferHistoryArray removeAllObjects];
    
    // Get recent  bills list
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Fetching ...", nil);
    [HUD show:YES];
    
    [ self GetRecentBillPaymentList];
    
    if ([transferHistoryArray count] == 0) {
        
        _tableView.hidden = YES;
    }
    else
    {
        _tableView.hidden = NO;
    }

}

#pragma mark #####
#pragma mark Get All Recent Transfer methods
#pragma mark #####

-(void) GetRecentTransferList
{
    // GetRecent transfer list
    listTypes = @"Transfer";
    [ Controller getRecentTransactionsWithSuccess:^(id responseObject){
        [HUD removeFromSuperview];
    }andFailure:^(NSString *String)
     {
         if(!String || [String isEqualToString:@"(null)"])
         {
             String = @"Your session has been expired.";
             
             UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:String delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             alertview.tag = 1003;
             [alertview show];
         }
         else
         {
             NSLog(@"REceived String..%@", String);
             NSError *error;
             NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingMutableContainers error:&error];
             NSDictionary *payLoadDic = [ json valueForKey:@"PayLoad"];
             BOOL Status = [[ payLoadDic valueForKey:@"status"] boolValue];
             if ( Status == true) {
                 NSDictionary *dataDic = [ payLoadDic valueForKey:@"data"];
                 transferHistoryArray = [dataDic valueForKey:@"transfer_requests"];
                 NSLog(@" Transfer list Data ..%@", transferHistoryArray);
                 if([transferHistoryArray count] != 0){
                     _tableView.hidden = NO;
                     [_tableView reloadData];
                 }
             }
         }
         [HUD removeFromSuperview];
     }];
}

#pragma mark #####
#pragma mark Get All Recent Bill payment methods
#pragma mark #####

-(void) GetRecentBillPaymentList
{
    // Get Recent Bill Payment list
    listTypes = @"Payment";
    [ Controller getRecentBillPaymentWithSuccess:^(id responseObject){
        [HUD removeFromSuperview];
    }andFailure:^(NSString *String)
     {
         if(!String || [String isEqualToString:@"(null)"])
         {
             String = @"Your session has been expired.";
             
             UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:String delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             alertview.tag = 1003;
             [alertview show];
         }
         else
         {
             NSLog(@"REceived String..%@", String);
             NSError *error;
             NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                  options:NSJSONReadingMutableContainers error:&error];
             NSDictionary *payLoadDic = [ json valueForKey:@"PayLoad"];
             BOOL Status = [[ payLoadDic valueForKey:@"status"] boolValue];
             if ( Status == true) {
                 NSDictionary *dataDic = [ payLoadDic valueForKey:@"data"];
                 transferHistoryArray = [dataDic valueForKey:@"bill_payments"];
                 NSLog(@" bill_payments list Data ..%@", transferHistoryArray);
                 if([transferHistoryArray count] != 0){
                     _tableView.hidden = NO;
                     [_tableView reloadData];
                 }
             }
         }
         [HUD removeFromSuperview];
     }];
}


#pragma mark #####
#pragma mark Alert method
#pragma mark #####

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

#pragma  mark ############
#pragma  mark Table view methods
#pragma mark #####

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    return [transferHistoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.layer.borderColor = [UIColor colorWithRed:(8/255.0) green:(50/255.0) blue:(70/255.0) alpha:1.0].CGColor;
    cell.layer.borderWidth = 3;
    
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(20,35,SCREEN_WIDTH-70,1)];
    newView.backgroundColor=[self colorWithHexString:@"51595c"];
    
    NSDictionary *transferReqDic = [transferHistoryArray objectAtIndex:indexPath.row];
    
    UILabel *businessNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,10,400,15)];
    businessNameLabel.textColor = [self colorWithHexString:@"51595c"];
    
    UILabel *dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,45,100,15)];
    dateTimeLabel.textColor = [self colorWithHexString:@"51595c"];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150,0,100,35)];
    statusLabel.textColor = [self colorWithHexString:@"51595c"];
    statusLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *sendingAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 35,70,35)];
    sendingAmountLabel.textColor = [self colorWithHexString:@"51595c"];
    sendingAmountLabel.textAlignment = NSTextAlignmentRight;
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32,0, 30, 30)];
    
//    if([[transferReqDic valueForKeyPath:@"status.title"] isEqualToString:@"PENDING"] )
//    {
//        imv.image=[UIImage imageNamed:@"Ques.png"];
//    }
//    
    if([[transferReqDic valueForKeyPath:@"status.title"] isEqualToString:@"FAILED"] )
    {
        imv.image=[UIImage imageNamed:@"failed.png"];
    }
//    else if([[transferReqDic valueForKeyPath:@"status.title"] isEqualToString:@"PROCESSING"] )
//    {
//        imv.image=[UIImage imageNamed:@"Ques.png"];
//    }
//    else if([[transferReqDic valueForKeyPath:@"status.title"] isEqualToString:@"AWAITING-COLLECTION"] )
//    {
//        imv.image=[UIImage imageNamed:@"Ques.png"];
//    }
    else if ([[transferReqDic valueForKeyPath:@"status.title"] isEqualToString:@"SUCCESSFUL"] )
    {
        imv.image=[UIImage imageNamed:@"sucess.png"];
    }
    else
    {
        imv.image=[UIImage imageNamed:@"Ques.png"];
    }
    
    [businessNameLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:13]];
    sendingAmountLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10];
    
    statusLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:13];
    dateTimeLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:10];
    
    NSString *myString = [transferReqDic valueForKeyPath:@"created"];
    if ([[transferReqDic valueForKeyPath:@"created"] isKindOfClass:[NSNull class]])
    {
        myString = @"null";
    }
    else
    {
        myString = [transferReqDic valueForKeyPath:@"created"];
    }

    if ([transferReqDic valueForKeyPath:@"bill_provider.title"] != nil)
    {
        businessNameLabel.text = [ NSString stringWithFormat:@"%@",[transferReqDic valueForKeyPath:@"bill_provider.title"]];
    }
    
    else if ([[transferReqDic valueForKeyPath:@"beneficiary.full_name"] isKindOfClass:[NSNull class]])
    {
        businessNameLabel.text = @"null";
    }
    else
    {
        businessNameLabel.text = [ NSString stringWithFormat:@"%@",[transferReqDic valueForKeyPath:@"beneficiary.full_name"]];
    }
    
    if ([[transferReqDic valueForKeyPath:@"sending_amount"] isKindOfClass:[NSNull class]])
    {
        sendingAmountLabel.text = @"null";
    }
    else
    {
        sendingAmountLabel.text = [NSString stringWithFormat:@"%@ %@",[transferReqDic valueForKeyPath:@"sending_currency.currency_code"],[transferReqDic valueForKeyPath:@"sending_amount"]];
    }
    if ([[transferReqDic valueForKeyPath:@"status.title"] isKindOfClass:[NSNull class]])
    {
        statusLabel.text = @"null";
    }
    else
    {
        statusLabel.text = [ NSString stringWithFormat:@"%@ %@",[transferReqDic valueForKeyPath:@"receiving_currency.currency_code"],[transferReqDic valueForKeyPath:@"receiving_amount"]];
    }

    if ([myString isKindOfClass:[NSNull class]])
            {
        dateTimeLabel.text = @"null";
            }
            else
            {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                NSDate *date = [df dateFromString:myString];
                [df setDateFormat:@"MMMM dd, HH:mm"];
                NSString *dateString = [df stringFromDate:date];
           dateTimeLabel.text = dateString;
            }
    [cell.contentView addSubview:newView];
    [cell.contentView addSubview:businessNameLabel];
    [cell.contentView addSubview:statusLabel];
    [cell.contentView addSubview:sendingAmountLabel];
    [cell.contentView addSubview:dateTimeLabel];
    [cell.contentView addSubview:imv];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    transferStatusDict = [ transferHistoryArray objectAtIndex:indexPath.row];
    if ([listTypes  isEqual: @"Transfer"]){
    [self performSegueWithIdentifier:@"TransferPending" sender:self];
    }
    else{
       [self performSegueWithIdentifier:@"PaymentPending" sender:self];  
    }
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@"segue to transfer Detail  screen");
    if([[segue identifier] isEqualToString:@"TransferPending"]){
        
        TransferPendingViewController *vc = [segue destinationViewController];
        vc.transferStatusData = [transferStatusDict mutableCopy];
    }
    if([[segue identifier] isEqualToString:@"PaymentPending"]){
        
        PaymentPendingViewController *vc = [segue destinationViewController];
        vc.transferStatusData = [transferStatusDict mutableCopy];
    }
}

#pragma mark ########
#pragma mark Color HexString methods
#pragma mark #####

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
