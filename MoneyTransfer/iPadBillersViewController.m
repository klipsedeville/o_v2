//
//  iPadBillersViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 24/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "iPadBillersViewController.h"
#import "iPadSendMoneyViewController.h"
#import "Controller.h"
#import "iPadUserProfileViewController.h"

@interface iPadBillersViewController ()

@end

@implementation iPadBillersViewController

#pragma mark #######
#pragma View Life Cycle method
#pragma mark ######

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    [self.searchBar setPlaceholder:@"Search..."];
    self.searchBar.delegate = self;
    
    billerArray = [[NSMutableArray alloc]init];
    searchBillersArray = [[NSMutableArray alloc]init];
    _searchBar.barTintColor = [UIColor clearColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = NSLocalizedString(@"Loading...", nil);
    [HUD show:YES];
    
    [ self GetBillersList];
    
    NSLog(@"billers Array ...%@",billerArray);
}

#pragma mark #######
#pragma mark Get Billers List method
#pragma mark ######

-(void)GetBillersList
{
    [ Controller GetBillersListWithSuccess:^(id responseObject){
        [HUD removeFromSuperview];
        
    }andFailure:^(NSString *String)
     {
         
         NSLog(@"Received String..%@", String);
         
         NSError *error;
         NSData *jsonData = [String dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers error:&error];
         
         NSDictionary *payLoadDic = [ json valueForKey:@"PayLoad"];
         BOOL Status = [[ payLoadDic valueForKey:@"status"] boolValue];
         if ( Status == true)
         {
             CGFloat currentHieght = self.tableView.frame.size.height;
             NSLog(@"Current Hieght..%f", currentHieght);
             
             billerArray = [ [payLoadDic valueForKey:@"data"] valueForKey:@"merchants"];
             
             CGFloat tableHeight = 0.0f;
             tableHeight = 100*billerArray.count;
             
             NSLog(@"Current Hieght..%f", tableHeight);
             
             if (tableHeight > currentHieght)
             {
                 self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, currentHieght);
             }
             else{
                 self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, tableHeight);
             }
             
             
             [_tableView reloadData];
             
             
         }
         else
         {
         }
         
         [HUD removeFromSuperview];
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ######
#pragma Click Action Method
#pragma mark ######

- (IBAction)backBtnClicked:(id)sender {
    
    [ self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ######
#pragma Search Bar delegate Method
#pragma mark ######

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

#pragma mark #############
#pragma mark UITableView delegate methods
#pragma mark #############

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag==YES)
    {
        return searchBillersArray.count;
    }
    else
    {
        return billerArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *billerDic = [ billerArray objectAtIndex:indexPath.row];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20,20, SCREEN_WIDTH-20, 30)];
    
    UILabel *typeLbl = [[UILabel alloc] initWithFrame:CGRectMake(20,70, SCREEN_WIDTH-50,15)];
    
    
    [typeLbl setFont: [typeLbl.font fontWithSize: 20]];
    [nameLbl setFont: [typeLbl.font fontWithSize: 30]];
    typeLbl.textColor = [UIColor lightGrayColor];
    nameLbl.textColor = [self colorWithHexString:@"51595c"];
    
    nameLbl.text = [ NSString stringWithFormat:@"%@",[billerDic valueForKeyPath:@"business_name"]];
    typeLbl.text = [ NSString stringWithFormat:@"%@",[billerDic valueForKeyPath:@"business_type.name"]];
    
    [cell.contentView addSubview:nameLbl];
    [cell.contentView addSubview:typeLbl];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.frame = CGRectMake(600,20,40,40);
    NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[billerDic valueForKeyPath:@"country_currency.flag"]];
    
    dispatch_queue_t concurrentQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue1, ^{
        
        UIImage *image = nil;
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoimageURl]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *img=[[UIImageView alloc]init];
            img.image=image;
            [iconImage setImage:image];
            
        });
    });
    [cell.contentView addSubview:iconImage];
    
    if (flag==YES)
    {
        nameLbl.text = [searchBillersArray objectAtIndex:indexPath.row];;
        return cell;
    }
    
    else
    {
        nameLbl.text = [ NSString stringWithFormat:@"%@",[billerDic valueForKeyPath:@"business_name"]];
        return cell;
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"The value search is %@",searchText);
    if (searchText.length==0)
    {
        flag=NO;
        [self.tableView reloadData];
    }
    else
    {
        searchBillersArray = [[NSMutableArray alloc]init];
        flag=YES;
        for (NSDictionary *dict in billerArray)
        {
            NSString *temp = [dict valueForKeyPath:@"business_name"];
            NSRange myRange=[temp rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (myRange.location!=NSNotFound)
            {
                NSLog(@"We found value ");
                [searchBillersArray addObject:temp];
                [self.tableView reloadData];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"ShowMerchantProfile"]){
        
        iPadUserProfileViewController *vc = [[iPadUserProfileViewController alloc]init];
        
        vc.merchantProfileData = billerArray;
    }
    
}
#pragma mark ########
#pragma mark Color HexString methods
#pragma mark #######

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
