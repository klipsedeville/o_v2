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
//    NSURL *phoneUrl = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:@"+16507639534"]];
//    NSURL *phoneFallbackUrl = [NSURL URLWithString:[@"tel://" stringByAppendingString:@"+16507639534"]];
//    
//    if ([UIApplication.sharedApplication canOpenURL:phoneUrl]) {
//        
//        [UIApplication.sharedApplication openURL:phoneUrl];
//        
//        AppDelegate *app = [[AppDelegate alloc]init];
//        app.callStatusValue = @"YES";
    [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"callStatusValue"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade1];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShade" object:self];
//    }
//    else if ([UIApplication.sharedApplication canOpenURL:phoneFallbackUrl]) {
//        [UIApplication.sharedApplication openURL:phoneFallbackUrl];
//    }
//    else {
//        // Show an error message: Your device can not do phone calls.
//        AppDelegate *app = [[AppDelegate alloc]init];
//        app.callStatusValue = @"YES";
//    }

//    if (self.delegate && [self.delegate conformsToProtocol:@protocol(CustomPopUpDelegate)])
//    {
//    [self.delegate popUpDelegateOkBtnClicked:self];
//    }
}

- (IBAction)ActionCrossBtn:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
//   [self performSegueWithIdentifier:@"CreateAccount" sender:self];
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
//    self.popUpMsgLbl.text = self.popUpMsg;
    self.callFromLbl.text = self.callFrom;

//    NSString *language = [ [ NSUserDefaults standardUserDefaults] valueForKey:@"lang_locale"];
//    
//    if ([language  isEqual: @"ar"])
//    {
//        [self.OkBtn setTitle:@"تم!" forState:UIControlStateNormal];
//    }
//    else
//    {
//        
//    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)hideManual
{
    counter = counter - 1;
    if(counter >= 1)
    {
        _timelbl.text = [NSString stringWithFormat: @"%d", counter];
        //show its Value
    }
    
    if(counter == 0)
    {
        [timer invalidate];
        timer = nil;
        
        //Do other stuff
    }
}

@end
