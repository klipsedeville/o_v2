//
//  IPadBillPayViewController.m
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "IPadBillPayViewController.h"
#import "Constants.h"
#import "Controller.h"
#import "IPadPayBillViewController.h"
#import "AppDelegate.h"

@interface IPadBillPayViewController ()
{
    AppDelegate * appDel;
}
@end

@implementation IPadBillPayViewController

#pragma mark ######
#pragma mark View life cycle methods
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    
    billArray = [[NSMutableArray alloc]init];
    billCategoryData = [[NSMutableArray alloc]init];
    
    self.addBtn.layer.cornerRadius = self.addBtn.frame.size.height/2;
    self.addBtn.layer.borderColor = [UIColor clearColor].CGColor;
    self.addBtn.layer.borderWidth= 0.01;
    
//    _scrollView.bounces = NO;
    _billTableView.bounces = NO;
    self.billTableView.hidden = YES;
    
    // Call get Bills Category
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    [self GetBillsCategory];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
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
    
    _currencyView.hidden = NO;
    _currencyView.frame = CGRectMake(SCREEN_WIDTH-170,15,152,40);
    
    allCurrencyArray = [[NSMutableArray alloc]init];
    
    _currencyTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 110, 40) style:UITableViewStylePlain];
    
    _currencyTableView.delegate=self;
    _currencyTableView.dataSource=self;
    
    [_currencyTableView setAllowsSelection:YES];
    [_currencyTableView setScrollEnabled:YES];
    [self.currencyView addSubview:_currencyTableView];
    _currencyTableView.backgroundColor=[UIColor grayColor];
    _currencyTableView.layer.cornerRadius = 0.0;
    _currencyTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _currencyTableView.layer.borderWidth= 1;
    _currencyTableView.hidden = YES;
    _currencyTableView.bounces = NO;
    
    [ [[UIApplication sharedApplication] delegate].window addSubview:_currencyView];
    // Call Receiving Currency List
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    [self getReceivingCurrencyList];
    
}
#pragma mark ######
#pragma mark Get Receiving Curreny List
#pragma mark ######

-(void) getReceivingCurrencyList
{
    [Controller getAllReceivingCurrencyWithSuccess:^(id responseObject){
        
        NSDictionary *Data = [responseObject valueForKey:@"PayLoad"];
        NSDictionary *currencyData = [ Data valueForKey:@"data"];
        allCurrencyArray = [ currencyData valueForKey:@"currencies"];
        
        NSDictionary *dict = [ allCurrencyArray objectAtIndex:0];
        
        _currencyIDLbl.text = [dict valueForKey:@"currency_code"];
        selectCountryCode = [dict valueForKey:@"id"];
        [ [NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%@", selectCountryCode] forKey:@"selectCountryCode"];
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
            
            [alertview show];
        }
        
        [HUD removeFromSuperview];
        
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
       [ _currencyView removeFromSuperview];
}
#pragma mark ######
#pragma mark Click Action method
#pragma mark ######

- (IBAction)currencyBtnClicked:(id)sender
{
    
    if (allCurrencyArray == NULL)
    {
        _currencyTableView.hidden = YES;
    }
    else if (_currencyTableView.hidden == YES) {
        _currencyTableView.hidden = NO;
        _currencyView.frame = CGRectMake(SCREEN_WIDTH-170,15,152,40*(allCurrencyArray.count));
        _currencyTableView.frame=CGRectMake(0, 0, 110, 40*(allCurrencyArray.count));
        
        [_currencyTableView reloadData];
    }
    else{
        _currencyTableView.hidden = YES;
    }
     _currencyTableView.scrollEnabled = YES;
}

- (IBAction)backBtnClicked:(id)sender {
    
    [ _currencyView removeFromSuperview];
    [self performSegueWithIdentifier:@"showmoney" sender:self];
}

- (IBAction)ActionAddBiller:(id)sender {
    [ _currencyView removeFromSuperview];
    [self performSegueWithIdentifier:@"AddBillerSegue" sender:self];
}

#pragma mark ######
#pragma mark Get Bills Categories
#pragma mark ######

-(void)GetBillsCategory
{
    [Controller getBillsCategoriesWithSuccess:^(id responseObject)
     {
         [HUD removeFromSuperview];
     }andFailure:^(NSString *String)
     {
         NSLog(@"Bills String..%@", String);
         NSError *error;
         NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers error:&error];
         
         NSDictionary *payLoadDic = [ json valueForKey:@"PayLoad"];
         BOOL Status = [[ payLoadDic valueForKey:@"status"] boolValue];
         if ( Status == true)
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
    _currencyTableView.hidden = YES;
    
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Fetching bills...", nil);
    [HUD show:YES];
    
    selectedCategoryID =[ NSString stringWithFormat:@"%ld",(long)[ sender tag]];
    [self GetBillsCategory];
}

#pragma mark ######
#pragma mark Table View Method
#pragma mark ######
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _currencyTableView) {
        
        return 40;
    }
    else
    {
        return 110;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _currencyTableView) {
        
        cell.backgroundColor = [self colorWithHexString:@"073245"];
    }
    else{
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(tableView == _currencyTableView)
    {
        
        [_currencyTableView setSeparatorColor:[UIColor clearColor]];
        
        NSDictionary *dict;
        dict = [[ allCurrencyArray objectAtIndex:indexPath.row] valueForKey:@"country_currency"];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,1,70, 40)];
        
        titleLabel.textColor = [UIColor whiteColor];
        [titleLabel setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:30]];
        titleLabel.text = [dict valueForKey:@"currency_code"];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.frame = CGRectMake(10,7,25,25);
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
        
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(30,20, 70, 70)];
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
        UILabel *nameLbl = [[ UILabel alloc] initWithFrame:CGRectMake(130,30,SCREEN_WIDTH-140,50)];
        
        nameLbl.text = [categoryDic valueForKey:@"title"];
        [nameLbl setFont:[UIFont systemFontOfSize:20]];
        [ cell addSubview:nameLbl];
        UIView *endLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 109, SCREEN_WIDTH, 1)];
        endLabel.backgroundColor = [UIColor darkGrayColor];
        [cell.contentView addSubview:endLabel];
        
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _currencyTableView)
    {
        
        NSDictionary *dict = [[ allCurrencyArray objectAtIndex:indexPath.row] valueForKey:@"country_currency"];
        _currencyIDLbl.text = [dict valueForKey:@"currency_code"];
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
        
        [HUD removeFromSuperview];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = NSLocalizedString(@"Fetching bills...", nil);
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
    
     [HUD removeFromSuperview];
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

#pragma mark ########
#pragma mark Alert View Delegate
#pragma mark ########

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==1002)
    {
        if (buttonIndex==0)
        {
            [_currencyView removeFromSuperview];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                
                if ([controller isKindOfClass:[iPadLoginViewController class]]) {
                    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    [self.navigationController setNavigationBarHidden:NO];
                    
                    break;
                }
            }
        }
        
    }
    if(alertView.tag ==1003)
    {
        if (buttonIndex==0)
        {
            [_currencyView removeFromSuperview];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                
                if ([controller isKindOfClass:[iPadLoginViewController class]]) {
                    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    [self.navigationController setNavigationBarHidden:NO];
                    
                    break;
                }
            }
        }
        
    }
    
}

@end
