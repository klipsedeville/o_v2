//
//  CustomPopUp.m
//
//  Created by  on 20/08/14.
//  Copyright (c) 2014 Ami Modi. All rights reserved.
//

#import "CustomPopUp.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "AppDelegate.h"

@interface CustomPopUp ()
{
    
}
@end

@implementation CustomPopUp
@synthesize popUpMsg,popUpTitle,tag,callFrom;
//@synthesize tag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    
    return self;
}

- (IBAction)okBtnClicked:(id)sender{
     if ([_OkBtnTitle  isEqual: @"verify"]){
         [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
         [[NSUserDefaults standardUserDefaults] setValue:@"Continue" forKey:@"callStatusValue"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShade" object:self];
     }
     else{
    NSString *phNo = [NSString stringWithFormat:@"%@",_callTo];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
       
    } else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Call facility is not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.tag = 1001;
        [alert show];
    }

    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"callStatusValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShade" object:self];
     }
}

- (IBAction)ActionCrossBtn:(id)sender
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShade" object:self];
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10.0f;
    counter = 900;
    _timelbl.text = [NSString stringWithFormat: @"%d", counter];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideManual) userInfo:nil repeats:YES];
    [self hideManual];
    self.numberLabel.text = self.callTo;
    self.callFromLbl.text = [NSString stringWithFormat:@"Call from %@", self.callFrom];
    
    UITapGestureRecognizer *tapGestureCall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    [self.view addGestureRecognizer:tapGestureCall];
    if ([_OkBtnTitle  isEqual: @"verify"]){
        [_OkBtn setTitle:@"CONTINUE" forState:UIControlStateNormal];
        _statusImage.image = [UIImage imageNamed:@"verify"];
        _verifyView.hidden = NO;
    }
    else if ([_OkBtnTitle  isEqual: @"expire"]){
        [_OkBtn setTitle:@"CONTINUE" forState:UIControlStateNormal];
        _statusImage.image = [UIImage imageNamed:@"expire"];
        _verifyView.hidden = NO;
    }
    else{
         [_OkBtn setTitle:_OkBtnTitle forState:UIControlStateNormal];
        _verifyView.hidden = YES;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
}
- (void)hideManual
{
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"timeStamp"] != nil){
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDate *d1 = [NSDate date];
    NSDate *d2 = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]valueForKey:@"timeStamp"]doubleValue]];
    NSDateComponents *components = [c components:NSSecondCalendarUnit fromDate:d1 toDate:d2 options:0];
  counter = components.second;
//        counter = [[[NSUserDefaults standardUserDefaults]valueForKey:@"timeStamp"] intValue];
        
        if(counter >= 1)
        {
            _timelbl.text = [NSString stringWithFormat: @"%d", counter];
        }
        if(counter == 0)
        {
            [timer invalidate];
            timer = nil;
            [_OkBtn setTitle:@"CONTINUE" forState:UIControlStateNormal];
            _statusImage.image = [UIImage imageNamed:@"expire"];
            _verifyView.hidden = NO;
        }
    }
    else{
    counter = counter - 1;
    if(counter >= 1)
    {
        _timelbl.text = [NSString stringWithFormat: @"%d", counter];
    }
    if(counter == 0)
    {
        [timer invalidate];
        timer = nil;
        [_OkBtn setTitle:@"CONTINUE" forState:UIControlStateNormal];
        _statusImage.image = [UIImage imageNamed:@"expire"];
        _verifyView.hidden = NO;
//        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
//        _OkBtnTitle = @"expire";
//        [self viewDidLoad];
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShade" object:self];
    }
        [[ NSUserDefaults standardUserDefaults] setInteger:counter forKey:@"timeStamp"];
    }
}

#pragma mark ######
#pragma Gesture Recognize methods
#pragma mark ######

- (void)DidRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    NSString *phNo = [NSString stringWithFormat:@"%@",_callTo];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                    [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Call facility is not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.tag = 1001;
        [alert show];
    }
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
    [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"callStatusValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShade" object:self];
}

@end
