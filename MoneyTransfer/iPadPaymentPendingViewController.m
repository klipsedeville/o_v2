//
//  iPadPaymentPendingViewController.m
//  MoneyTransfer
//
//  Created by 050 on 10/10/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "iPadPaymentPendingViewController.h"
#import "Constants.h"

@interface iPadPaymentPendingViewController ()

@end

@implementation iPadPaymentPendingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView.bounces = NO;
    _navigationTitleTextField.text = [ NSString stringWithFormat:@"Bill Payment Status"];
    _referenceNumberLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"transaction_reference"]];
    
    NSString *myString = [_transferStatusData valueForKeyPath:@"created"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [df dateFromString:myString];
    [df setDateFormat:@"MMMM dd, HH:MM"];
    NSString *dateString = [df stringFromDate:date];
    _dateLbl.text = dateString;
    
    _bankAccNameLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"bill_provider.title"]];
    _bankAccDescLabl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"bill_provider.contact_person_address"]];
    _billTitleLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"bill.title"]];
    _billOptionTitleLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"bill_option.title"]];
    
    NSString *sendingAmount = [ NSString stringWithFormat:@"%@", [_transferStatusData valueForKeyPath:@"sending_amount"]];
    
    if( ![sendingAmount containsString:@"."]){
        sendingAmount = [ NSString stringWithFormat:@"%@.00", sendingAmount];
    }
    _AmountLbl.text = [ NSString stringWithFormat:@"₦%@.00 ($%@)",[_transferStatusData valueForKeyPath:@"receiving_amount"], sendingAmount];
    _ExRateLbl.text = [ NSString stringWithFormat:@"Ex. Rate: %@1.00 = %@%@.00 Service Fee: %@%@.00",[_transferStatusData valueForKeyPath:@"sending_currency.currency_symbol"],[_transferStatusData valueForKeyPath:@"receiving_currency.currency_symbol"],[_transferStatusData valueForKey:@"exchange_rate"],[_transferStatusData valueForKeyPath:@"sending_currency.currency_symbol"],[_transferStatusData valueForKey:@"fee"]];
    
    _statusLbl.text = [ NSString stringWithFormat:@"%@",[[_transferStatusData valueForKeyPath:@"status.title"]uppercaseString]];
    
    
    
    float sizeOfContent = 0;
    NSInteger wd = _statusView.frame.origin.y;
    NSInteger ht = _statusView.frame.size.height+45;
    sizeOfContent = wd+ht;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
}

#pragma mark ########
#pragma mark Click Action methods
#pragma mark ########

-(IBAction)backBtnClicked:(id)sender{
    
    // back button
    [ self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)contactCustomerSupportBtnClicked:(id)sender{
    
    // Contact Customer Support
    // Email Subject
    NSString *emailTitle = @"Bill Payment Enquiry";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"care@orobo.com"];
 
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    
    [self.navigationController presentViewController:mc animated:YES completion:NULL];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
