//
//  UserProfileViewController.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 23/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "UserProfileViewController.h"
#import "SendMoneyViewController.h"
#import "Constants.h"
#import "Controller.h"
#import "AppDelegate.h"

@interface UserProfileViewController ()
{
    AppDelegate *appDel;
}
@end

@implementation UserProfileViewController

#pragma  mark ############
#pragma  mark View Life Cycle methods
#pragma  mark ############

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    // Check user Session expire or Not
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    userDataDict = [userDataDict valueForKeyPath:@"User"] ;
    
    if (![[userDataDict valueForKeyPath:@"card.user_id"] isKindOfClass:[NSNull class]])
        //stripe_customerID
    {
        _changeBtn.hidden = NO;
    }
    else
    {
        _changeBtn.hidden = YES;
    }
    _passwordView.hidden = YES;
    [ self getUserprofile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [_scrollView setContentSize:CGSizeMake( _scrollView.frame.size.width, 545)];
    _scrollView.bounces = NO;
}

#pragma  mark ############
#pragma  mark Get userProfile methods
#pragma  mark ############

-(void)getUserprofile
{
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    userInfo = [userInfo valueForKeyPath:@"User"];
    if ([[userInfo valueForKeyPath:@"full_name"] isKindOfClass:[NSNull class]])
    {
        _userNameLbl.text = @"null";
    }
    else
    {
        _userNameLbl.text = [userInfo valueForKeyPath:@"full_name"];
    }
    
    if ([[userInfo valueForKeyPath:@"phone_number"] isKindOfClass:[NSNull class]])
    {
        _userMobileNumberLbl.text = @"null";
    }
    else
    {
        _userMobileNumberLbl.text = [userInfo valueForKeyPath:@"phone_number"];
    }
    
    if ([[userInfo valueForKeyPath:@"email_address"] isKindOfClass:[NSNull class]])
    {
        _userEmailAddressLbl.text = @"null";
    }
    else
    {
        _userEmailAddressLbl.text  = [userInfo valueForKeyPath:@"email_address"];
    }
    
    if ([ [userInfo valueForKeyPath:@"address"] isKindOfClass:[NSNull class]])
    {
        _userAddressLbl.text = @"null";
    }
    else
    {
        _userAddressLbl.text  = [userInfo valueForKeyPath:@"address"];
    }
    
    
    if ([[userInfo valueForKeyPath:@"card.title"] isKindOfClass:[NSNull class]])
    {
        _creditCardAddLbl.text = @"****null";
    }
    else
        
    {
        NSString *name = [userInfo valueForKeyPath:@"card.title"];
        NSLog(@"Card name %@",name);
        _creditCardAddLbl.text  = [ NSString stringWithFormat:@"%@",[userInfo valueForKeyPath:@"card.title"]];
    }
    
    if ([[userInfo valueForKeyPath:@"tier.title"] isKindOfClass:[NSNull class]])
    {
        _accountTierLbl.text = @"";
    }
    else
    {
        _accountTierLbl.text  = [userInfo valueForKeyPath:@"tier.title"];
    }
    
    NSString *logoimageURl=[ NSString stringWithFormat:@"%@/%@/%@",BaseUrl, URLImage,[userInfo valueForKeyPath:@"country_currency.flag"]];
    
    NSString *imagePath = @"";
    NSString * flagName = @"";
    flagName = [logoimageURl lastPathComponent];
    imagePath = [appDel getImagePathbyflagName:flagName];
    
    if(imagePath.length > 0){
        NSData *img = nil;
        img= [NSData dataWithContentsOfFile:imagePath];
        _userImageView.image =[UIImage imageWithData:img];
    }
    else
    {
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //this will start the image loading in bg
        dispatch_async(concurrentQueue, ^{
            NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:logoimageURl]];
            
            //this will set the image when loading is finished
            dispatch_async(dispatch_get_main_queue(), ^{
                _userImageView.image = [UIImage imageWithData:image];
                
                [appDel saveflagsImageToFolder:_userImageView.image imageName:flagName];
                
            });
        });
    }
}

#pragma  mark ############
#pragma  mark Alert Method
#pragma  mark ############

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
#pragma  mark Click Action methods
#pragma  mark ############

- (IBAction)changePwdBtn:(id)sender {
    
    // Change Password
    [ _passwordView removeFromSuperview];
    [self performSegueWithIdentifier:@"changePassword" sender:self];
}

- (IBAction)showPwdBtn:(id)sender {
    
    // Show password View
    _passwordView.frame = CGRectMake(SCREEN_WIDTH-145,25,140,40);
    
    [ [[UIApplication sharedApplication] delegate].window addSubview:_passwordView];
    _passwordView.hidden = NO;
    _passwordView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _passwordView.layer.borderWidth= 0.5;
    _passwordView.layer.cornerRadius = 0.0;}

- (IBAction)addNewCreditCard:(id)sender {
    
    // Add credit card
    [ _passwordView removeFromSuperview];
    [self performSegueWithIdentifier:@"AddCreditCard" sender:self];
}

- (IBAction)backBtnClicked:(id)sender {
    
    // back Button
    [ _passwordView removeFromSuperview];
    [self performSegueWithIdentifier:@"ShowMoney" sender:self];
}

- (IBAction)ActionAgentProfile:(id)sender {
    [self performSegueWithIdentifier:@"agentProfileSegue" sender:self];
}

#pragma  mark ############
#pragma  mark Touch begin method
#pragma  mark ############

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    if(touch.view ==_passwordView){
        _passwordView.hidden = NO;
    }
    else
    {
        _passwordView.hidden = YES;
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

