//
//  AgentProfileViewController.m
//  MoneyTransfer
//
//  Created by 050 on 26/09/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "AgentProfileViewController.h"

@interface AgentProfileViewController ()

@end

@implementation AgentProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
}

- (void)viewDidLayoutSubviews
{
    [_scrollView setContentSize:CGSizeMake( _scrollView.frame.size.width, 570)];
    _scrollView.bounces = NO;
}


- (IBAction)backBtnClicked:(id)sender {
    
    // back Button
    [self performSegueWithIdentifier:@"ProfileSegue" sender:self];
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
