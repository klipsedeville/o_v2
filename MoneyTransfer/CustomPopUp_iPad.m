//
//  CustomPopUp_iPad.m
//  MoneyTransfer
//
//  Created by Isha Goel on 25/10/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "CustomPopUp_iPad.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "AppDelegate.h"

@interface CustomPopUp_iPad ()

@end

@implementation CustomPopUp_iPad

@synthesize popUpMsg,popUpTitle,tag,callFrom;
//@synthesize tag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cancel"];
    self.view.layer.cornerRadius = 10.0f;
    counter = 900;
    _timelbl.text = [NSString stringWithFormat: @"%d", counter];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideManual) userInfo:nil repeats:YES];
    [self hideManual];
    self.numberLabel.text = self.callTo;
    self.callFromLbl.text = [NSString stringWithFormat:@"Call from %@", self.callFrom];
    
    UITapGestureRecognizer *tapGestureCall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    [_touchView addGestureRecognizer:tapGestureCall];
    
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
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stop"];
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(statusValue) userInfo:nil repeats:YES];
    
}

- (IBAction)okBtnClicked:(id)sender{
    if ([_OkBtnTitle  isEqual: @"verify"])
    {
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
        [[NSUserDefaults standardUserDefaults] setValue:@"Continue" forKey:@"callStatusValue"];
    }
    else{
        NSString *phNo = [NSString stringWithFormat:@"%@",_callTo];
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"MakeContactCall"];

            
        } else
        {
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"MakeContactCall"];

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Call facility is not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            alert.tag = 1001;
            [alert show];
        }
        
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"callStatusValue"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShade" object:self];
}

- (IBAction)ActionCrossBtn:(id)sender
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShadeiPad" object:self];
    
}
-(void)statusValue{
    NSString *value = [[NSUserDefaults standardUserDefaults] valueForKey:@"verifying"];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"verifying"]  isEqual: @"Yes"]){
        [timer2 invalidate];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"stop"]  isEqual: @"Yes"]){
        [timer2 invalidate];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"timerActive"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"statusTimer" object:self];
        
    }
}

- (void)hideManual
{
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"timeStamp"] != nil){
        NSCalendar *c = [NSCalendar currentCalendar];
        NSDate *d1 = [NSDate date];
        NSDate *d2 = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]valueForKey:@"timeStamp"]doubleValue]];
        NSDateComponents *components = [c components:NSSecondCalendarUnit fromDate:d1 toDate:d2 options:0];
        counter = components.second;
        
        if(counter >= 1)
        {
            _timelbl.text = [NSString stringWithFormat: @"%d", counter];
        }
        if(counter == 0)
        {
            [timer2 invalidate];
            [timer invalidate];
            timer = nil;
            [[NSUserDefaults standardUserDefaults] setValue:@"fail" forKey:@"status"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _touchView.frame = CGRectMake(11, 230, self.touchView.frame.size.width, 40);
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
            [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"cancel"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [timer2 invalidate];
            [timer invalidate];
            timer = nil;
            [[NSUserDefaults standardUserDefaults] setValue:@"fail" forKey:@"status"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _touchView.frame = CGRectMake(11, 230, self.touchView.frame.size.width, 40);
            [_OkBtn setTitle:@"CONTINUE" forState:UIControlStateNormal];
            _statusImage.image = [UIImage imageNamed:@"expire"];
            
            _verifyView.hidden = NO;
        }
        [[ NSUserDefaults standardUserDefaults] setInteger:counter forKey:@"timeStamp"];
    }
    
    //    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"timeStamp"] != nil){
    //        NSCalendar *c = [NSCalendar currentCalendar];
    //        NSDate *d1 = [NSDate date];
    //        NSDate *d2 = [NSDate dateWithTimeIntervalSince1970:[[[NSUserDefaults standardUserDefaults]valueForKey:@"timeStamp"]doubleValue]];
    //        NSDateComponents *components = [c components:NSSecondCalendarUnit fromDate:d1 toDate:d2 options:0];
    //        counter = components.second;
    //        if(counter >= 1)
    //        {
    //            _timelbl.text = [NSString stringWithFormat: @"%d", counter];
    //        }
    //        if(counter == 0)
    //        {
    //            [timer2 invalidate];
    //            [timer invalidate];
    //            timer = nil;
    //            [_OkBtn setTitle:@"CONTINUE" forState:UIControlStateNormal];
    //            _statusImage.image = [UIImage imageNamed:@"expire"];
    //            _verifyView.hidden = NO;
    //        }
    //    }
    //    else{
    //        counter = counter - 1;
    //        if(counter >= 1)
    //        {
    //            _timelbl.text = [NSString stringWithFormat: @"%d", counter];
    //        }
    //        if(counter == 0)
    //        {
    //            [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"cancel"];
    //            [[NSUserDefaults standardUserDefaults] synchronize];
    //            [timer2 invalidate];
    //            [timer invalidate];
    //            timer = nil;
    //            [_OkBtn setTitle:@"CONTINUE" forState:UIControlStateNormal];
    //            _statusImage.image = [UIImage imageNamed:@"expire"];
    //
    //            _verifyView.hidden = NO;
    //        }
    //        [[ NSUserDefaults standardUserDefaults] setInteger:counter forKey:@"timeStamp"];
    //    }
}

#pragma mark ######
#pragma Gesture Recognize methods
#pragma mark ######

- (void)DidRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"status"]  isEqual: @"fail"]){
        
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShade" object:self];
    }
    else{
        
        NSString *phNo = [NSString stringWithFormat:@"%@",_callTo];
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"MakeContactCall"];

        } else
        {
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"MakeContactCall"];

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
@end

