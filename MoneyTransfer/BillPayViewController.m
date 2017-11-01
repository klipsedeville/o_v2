//
//  BillPayViewController.m
//  MoneyTransfer
//
//  Created by apple on 23/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "BillPayViewController.h"
#import "Constants.h"
#import "Controller.h"
#import "PayBillViewController.h"
#import "AppDelegate.h"
#import "LocationViewController.h"

@interface BillPayViewController ()
{
    AppDelegate *appDel;
}
@end

@implementation BillPayViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    }

-(void)viewWillAppear:(BOOL)animated{
    // Check user Session Expired or Not
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    billArray = [[NSMutableArray alloc]init];
    billCategoryData = [[NSMutableArray alloc]init];
    
    self.addBtn.layer.cornerRadius = self.addBtn.frame.size.height/2;
    self.addBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.addBtn.layer.borderWidth= 0.01;
    
    self.billTableView.hidden = YES;
    _billTableView.bounces = NO;
    
    //    _scrollView.bounces = NO;

    // Call get Bills Category
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    [self GetBillsCategory];

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
    
    // Get receving Currency list
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    [self getReceivingCurrencyList];
    
    _currencyView.hidden = NO;
    _currencyView.frame = CGRectMake(SCREEN_WIDTH-100,27,90,25);
    
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
    
    _billTableView.bounces = NO;
    [_billTableView reloadData];
    [ [[UIApplication sharedApplication] delegate].window addSubview:_currencyView];
    
    
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
        
//        NSDictionary *dict = [[ allCurrencyArray objectAtIndex:0] valueForKey:@"CountryCurrency"];
         NSDictionary *dict = [ allCurrencyArray objectAtIndex:0];
        _currencyIDLbl.text = [ NSString stringWithFormat:@"%@  ",[dict valueForKey:@"currency_code"]];
        selectCountryCode = [dict valueForKey:@"id"];
        [ [NSUserDefaults standardUserDefaults]setValue:selectCountryCode forKey:@"selectCountryCode"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        selectedCountryName = [dict valueForKey:@"country_name"];
        
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
    if(alertView.tag ==1002)
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

- (IBAction)currencyBtnClicked:(id)sender
{
    // Currency button
    if (allCurrencyArray == NULL)
    {
        _currencyTableView.hidden = YES;
    }
    else if (_currencyTableView.hidden == YES) {

        _currencyView.frame = CGRectMake(SCREEN_WIDTH-100,27,90,25*(allCurrencyArray.count));
        _currencyTableView.frame =CGRectMake(0,0,60,25*(allCurrencyArray.count));
        _currencyTableView.hidden = NO;
        [_currencyTableView reloadData];
    }
    else{
        _currencyTableView.hidden = YES;
    }
    _currencyTableView.scrollEnabled = YES;
}

- (IBAction)backBtnClicked:(id)sender {
    
    // back button
    [ _currencyView removeFromSuperview];
    [self performSegueWithIdentifier:@"sendMoney" sender:self];
}

- (IBAction)ActionAddBiller:(id)sender {
       [ _currencyView removeFromSuperview];
     [self performSegueWithIdentifier:@"AddBillerSegue" sender:self];
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
             billsCategoryArray= [ payLoadDic valueForKeyPath:@"data.categories"];
             
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

-(IBAction)CategoryClicked:(id)sender
{
    // category Clicked
    _currencyTableView.hidden = YES;
    
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Fetching bills...", nil);
    [HUD show:YES];
    selectedCategoryID =[ NSString stringWithFormat:@"%ld",(long)[ sender tag]];
    [self GetBillsCategory];
    
}

#pragma  mark ############
#pragma mark Table View Method
#pragma  mark ############

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _currencyTableView) {
        
        return 25;
    }
    else
    {
        return 60;
    }
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
    else{
        return [billsCategoryArray count];
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
        
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.frame = CGRectMake(5,5,15, 15);
        NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[dict valueForKey:@"flag"]];
        
        NSString *imagePath = @"";
        NSString * flagName = @"";
        flagName = [logoimageURl lastPathComponent];
        imagePath = [appDel getImagePathbyflagName:flagName];
        
        if(imagePath.length > 0){
            NSData *img = nil;
            img= [NSData dataWithContentsOfFile:imagePath];
            iconImage.image =[UIImage imageWithData:img];
        }
        else
        {
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //this will start the image loading in bg
            dispatch_async(concurrentQueue, ^{
                NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:logoimageURl]];
                
                //this will set the image when loading is finished
                dispatch_async(dispatch_get_main_queue(), ^{
                    iconImage.image = [UIImage imageWithData:image];
                    
                    [appDel saveflagsImageToFolder:iconImage.image imageName:flagName];
                    
                });
            });
        }
        [cell.contentView addSubview:iconImage];
        
           }
    else
    {
        NSDictionary *categoryDic = [billsCategoryArray objectAtIndex:indexPath.row];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fwd"]];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:NO];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15,10,40,40)];
        
    NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@",BaseUrl,[categoryDic valueForKeyPath:@"icon"]];
        
    NSString *imagePath = @"";
    NSString * flagName = @"";
    flagName = [logoimageURl lastPathComponent];
    imagePath = [appDel getImagePathbyflagName:flagName];
        
    if(imagePath.length > 0){
    NSData *img = nil;
    img= [NSData dataWithContentsOfFile:imagePath];
    iv.image =[UIImage imageWithData:img];
            }
    else
        {
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                                 dispatch_async(concurrentQueue, ^{
                                     NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:logoimageURl]];
        
    dispatch_async(dispatch_get_main_queue(), ^{
                                         iv.image = [UIImage imageWithData:image];
        
    [appDel saveflagsImageToFolder:iv.image imageName:flagName];
        
                    });
                });
    }
    [cell addSubview:iv];
    UILabel *nameLbl = [[ UILabel alloc] initWithFrame:CGRectMake(60,15,200,30)];
        
    nameLbl.text = [categoryDic valueForKey:@"title"];
    [nameLbl setFont:[UIFont systemFontOfSize:12]];
    [ cell addSubview:nameLbl];
        UIView *endLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
        endLabel.backgroundColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:endLabel];

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
        [ [NSUserDefaults standardUserDefaults]setValue:selectCountryCode forKey:@"selectCountryCode"];
        [[NSUserDefaults standardUserDefaults]synchronize];
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
     
        
        [HUD removeFromSuperview];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = NSLocalizedString(@"Loading...", nil);
        [HUD show:YES];
        [self GetBillsCategory];
 
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [ _currencyView removeFromSuperview];
        selectCategoryID = [NSString stringWithFormat:@"%@", [[billsCategoryArray objectAtIndex:indexPath.row]valueForKey:@"id"]];
       [ [NSUserDefaults standardUserDefaults]setValue:selectCategoryID forKey:@"selectCategoryID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self performSegueWithIdentifier:@"locationsegue" sender:self];
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
