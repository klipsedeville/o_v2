//
//  BillViewController.m
//  MoneyTransfer
//
//  Created by 050 on 15/09/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "BillViewController.h"
#import "Constants.h"
#import "Controller.h"
#import "AppDelegate.h"
#import "BillerViewController.h"

@interface BillViewController ()

@end

@implementation BillViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    _selectedBillerValue = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedBiller"];
    billsCategoryArray = [[NSMutableArray alloc]init];
    
    //     Call get States list
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading products...", nil);
    [HUD show:YES];
    [self GetStatesList];
    
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
        [_billTableView reloadData];
}

#pragma  mark ############
#pragma mark Alert method
#pragma  mark ############

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

- (IBAction)backBtnClicked:(id)sender {
    
    // back button
    [self performSegueWithIdentifier:@"billerSegue" sender:self];
}

- (IBAction)ActionAddBiller:(id)sender {
    [self performSegueWithIdentifier:@"AddBillerSegue" sender:self];
}



#pragma mark ##########
#pragma mark Get Bills List With Currency ID
#pragma mark ##########
-(void)GetStatesList
{
    // Get bill states list
    [Controller GetBillListByBillerID:_selectedBillerValue withSuccess:^(id responseObject)

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
             billsCategoryArray= [ payLoadDic valueForKeyPath:@"data.bills"];
             
             _billTableView.hidden = NO;
             [_billTableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [billsCategoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    NSDictionary *categoryDic = [billsCategoryArray objectAtIndex:indexPath.row];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fwd"]];
    UILabel *nameLbl = [[ UILabel alloc] initWithFrame:CGRectMake(15,10,200,20)];
    
    nameLbl.text = [categoryDic valueForKey:@"title"];
    [nameLbl setFont:[UIFont systemFontOfSize:12]];
    [ cell addSubview:nameLbl];
    
    UIView *endLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    endLabel.backgroundColor = [UIColor darkGrayColor];
    [cell addSubview:endLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *selectedBillValue = [billsCategoryArray objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:selectedBillValue] forKey:@"PayBillDetail"];
    [self performSegueWithIdentifier:@"payBillSegue" sender:self];
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
