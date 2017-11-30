//
//  iPadTransferPendingViewControllerViewController.m
//  MoneyTransfer
//
//  Created by apple on 19/09/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "iPadTransferPendingViewControllerViewController.h"
#import "Constants.h"

@interface iPadTransferPendingViewControllerViewController ()

@end

@implementation iPadTransferPendingViewControllerViewController

#pragma mark ########
#pragma mark View life Cycle
#pragma mark ########

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.bounces = NO;
    
    _navigationTitleTextField.text = [ NSString stringWithFormat:@"Transfer %@",[[_transferStatusData valueForKeyPath:@"status.title"]uppercaseString]];
    
    _referenceNumberLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"transaction_reference"]];
    
    _exchangeRateLbl.text  = [ NSString stringWithFormat:@"Ex. Rate: %@1.00 = %@%@.00 Service Fee: %@%@.00",[_transferStatusData valueForKeyPath:@"sending_currency.currency_symbol"],[_transferStatusData valueForKeyPath:@"receiving_currency.currency_symbol"],[_transferStatusData valueForKey:@"exchange_rate"],[_transferStatusData valueForKeyPath:@"sending_currency.currency_symbol"],[_transferStatusData valueForKey:@"fee"]];
    
    NSString *myString = [_transferStatusData valueForKeyPath:@"created"];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [df dateFromString:myString];
    [df setDateFormat:@"MMMM dd, HH:mm"];
    NSString *dateString = [df stringFromDate:date];
    _dateLbl.text = dateString;
    _beneficiaryUserNameLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"beneficiary.full_name"]];
    
    _sendingAmountLbl.text = [NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"sending_amount"]];
    
    [_sendingAmountLbl sizeToFit];
    _SendingCountryNameLbl.text = [NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"sending_currency.currency_code"]];
    
    _SendingCountryNameLbl.frame = CGRectMake( _sendingAmountLbl.frame.origin.x+_sendingAmountLbl.frame.size.width+3, _SendingCountryNameLbl.frame.origin.y-1, _SendingCountryNameLbl.frame.size.width, _SendingCountryNameLbl.frame.size.height);
    
    _receivingAmountLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"receiving_amount"]];
    
//    _receivingCountryNameLbl.text = [NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"receiving_currency.currency_code"]];
    
//    [_receivingAmountLbl sizeToFit];
    
    _statusLbl.text = [ NSString stringWithFormat:@"%@",[[_transferStatusData valueForKeyPath:@"status.title"]uppercaseString]];
    
    _beneficiaryUserNameLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"beneficiary.full_name"]];
    
    _settlementChannelNameLbl.text = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"beneficiary.settlement_channel.title"]];

    _receivingAmountLbl.text = [ NSString stringWithFormat:@"%@ %@",[_transferStatusData valueForKeyPath:@"receiving_amount"],[_transferStatusData valueForKeyPath:@"receiving_currency.currency_code"]];
    
//    NSString *big = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"receiving_amount"]];
//
//    NSString *small = [ NSString stringWithFormat:@"%@",[_transferStatusData valueForKeyPath:@"receiving_currency.currency_code"]];
//
//    _receivingAmountLbl.text = [ NSString stringWithFormat:@"%@ %@",big,small];
//
//    int textLength = (int)big.length;
//
//    NSMutableAttributedString* content2 =
//    [[NSMutableAttributedString alloc]
//     initWithString:_receivingAmountLbl.text
//     attributes:
//     @{
//       NSFontAttributeName:
//           [UIFont fontWithName:@"MyriadPro-Regular" size:30]
//       }];
//    [content2 setAttributes:
//     @{
//       NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Regular" size:40]
//       } range:NSMakeRange(0,textLength)];
//    [content2 addAttributes:
//     @{
//       NSKernAttributeName:@-4
//       } range:NSMakeRange(0,1)];
//
    
//    _receivingAmountLbl.attributedText = content2;
    
     // ---------------------Dynamic View----------------------------
    
    NSLog(@"Transfer Status Data is :- %@",_transferStatusData);
    
    NSArray *requiredFieldArray = [_transferStatusData valueForKeyPath:@"beneficiary.beneficiary_settlement_channel_data"];
    
    if ([requiredFieldArray count] > 0)
    {
        for(int i=0; i<[requiredFieldArray count]; i++)
        {
            _statusView.frame = CGRectMake(_statusView.frame.origin.x, _statusView.frame.origin.y, _statusView.frame.size.width, _statusView.frame.size.height+35);
            
            NSDictionary *tempDict = [requiredFieldArray objectAtIndex:i];
            NSLog(@"tempdict is : %@",tempDict);
            
            UILabel *requiredInfoTitleLbl = [[UILabel alloc] init];
            requiredInfoTitleLbl.frame = CGRectMake(20,_settlementChannelNameLbl.frame.origin.y+_settlementChannelNameLbl.frame.size.height+(i*35),SCREEN_WIDTH-20,35);
            
            NSArray *parameterOptionsArray ;
            
            if([ tempDict valueForKeyPath:@"settlement_channel_parameter.has_options"] != [NSNull null]  && [ tempDict valueForKeyPath:@"settlement_channel_parameter.options_model"] != [NSNull null])
            {
                parameterOptionsArray = [tempDict valueForKeyPath:@"settlement_channel_parameter.options_data"];
            }
            else{
                parameterOptionsArray = [tempDict valueForKeyPath:@"settlement_channel_parameter.settlement_channel_parameter_options"];
            }
            
            NSString *txt;
            if(parameterOptionsArray.count > 0)
            {
                BOOL valueFound = false;
                
                for (int j = 0; j<parameterOptionsArray.count; j++)
                {
                    NSDictionary * dict = [parameterOptionsArray objectAtIndex:j];
                    if([[dict valueForKey:@"id"] integerValue] == [[tempDict valueForKey:@"collected_data"] integerValue])
                    {
                        valueFound = YES;
                        if([ tempDict valueForKeyPath:@"settlement_channel_parameter.has_options"] != [NSNull null]  && [ tempDict valueForKeyPath:@"settlement_channel_parameter.options_model"] != [NSNull null])
                        {
                            txt = [ NSString stringWithFormat:@"%@: %@ (%@)",[tempDict valueForKeyPath:@"settlement_channel_parameter.parameter"], [dict valueForKey:@"sort_code"], [dict valueForKey:@"title"]];
                            txt =  [txt stringByReplacingOccurrencesOfString:@"_id"
                                                                  withString:@""];
                        }
                        else{
                            
                            txt = [ NSString stringWithFormat:@"%@: %@",[[tempDict valueForKeyPath:@"settlement_channel_parameter.parameter"]capitalizedString],[dict valueForKey:@"title"]];
                            txt =  [txt stringByReplacingOccurrencesOfString:@"_id"
                                                                  withString:@""];
                        }
                        
                        break;
                    }
                }
                
                if (valueFound == NO) {
                    txt = [ NSString stringWithFormat:@"%@:",[[tempDict valueForKeyPath:@"settlement_channel_parameter.parameter"]capitalizedString]];
                    txt =  [txt stringByReplacingOccurrencesOfString:@"_id"
                                                          withString:@""];
                }
            }
            else
            {
                if(![[tempDict valueForKeyPath:@"collected_data"] isEqualToString:@""])
                {
                    txt = [ NSString stringWithFormat:@"%@: %@",[[tempDict valueForKeyPath:@"settlement_channel_parameter.parameter"]capitalizedString],[tempDict valueForKeyPath:@"collected_data"]];
                }
                else
                {
                    _statusView.frame = CGRectMake(_statusView.frame.origin.x, _statusView.frame.origin.y, _statusView.frame.size.width, _statusView.frame.size.height-20);
                }
            }
            
            txt = [txt stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[txt substringToIndex:1] uppercaseString]];
            txt =  [txt stringByReplacingOccurrencesOfString:@"_"
                                                  withString:@" "];
            requiredInfoTitleLbl.text = txt;
            requiredInfoTitleLbl.font = [UIFont fontWithName:@"MyriadPro-Semibold" size:20];
            requiredInfoTitleLbl.textColor = [self colorWithHexString:@"51595c"];
            [_statusView addSubview:requiredInfoTitleLbl];
            
            _lastView.frame = CGRectMake(10,requiredInfoTitleLbl.frame.origin.y+requiredInfoTitleLbl.frame.size.height+5,SCREEN_WIDTH-20,1);
        }
    }
    
    UITapGestureRecognizer * single = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnreferenceNumberLbl:)];
    [self.referenceNumberLbl addGestureRecognizer:single];
    single.numberOfTapsRequired = 1;
    self.referenceNumberLbl.userInteractionEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ########
#pragma mark Click button action
#pragma mark ########

- (void)tapOnreferenceNumberLbl:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.referenceNumberLbl.text;
        // toast with a specific duration and position
        [self.view makeToast:[NSString stringWithFormat:@"%@",@"Reference copied to clipboard."]
                    duration:2.0
                    position:CSToastPositionBottom];
    }
}

-(IBAction)backBtnClicked:(id)sender{
    // back button
    [ self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)contactCustomerSupportBtnClicked:(id)sender{
    // Contact Customer Support
    // Email Subject
    NSString *emailTitle = @"Transaction Enquiries";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"care@orobo.com"];
 
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    
    [self.navigationController presentViewController:mc animated:YES completion:NULL];
    }
 
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
