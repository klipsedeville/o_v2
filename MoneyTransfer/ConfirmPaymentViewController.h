//
//  ConfirmPaymentViewController.h
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ConfirmPaymentViewController : UIViewController<UITextFieldDelegate>
{
    MBProgressHUD *HUD;
    NSMutableDictionary *payBillDict;
    NSMutableDictionary *billUserData;
    NSDictionary *rateDic;
}

// Property
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (strong, nonatomic) IBOutlet UILabel *billHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *billLbl;
@property (strong, nonatomic) IBOutlet UILabel *optionHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *optionLbl;
@property (strong, nonatomic) IBOutlet UILabel *amountHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *amountLbl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *descriptionBillLbl;
@property (strong, nonatomic) NSString *billCategoryId;

@property (strong, nonatomic) NSMutableDictionary *paymentData;
@property (strong, nonatomic) NSMutableArray *paymentUserData;
@property (strong, nonatomic) NSMutableArray *DataArray;
@property (strong, nonatomic) IBOutlet UIView *fieldView;
@property (weak, nonatomic) IBOutlet UILabel *billerCategoryLbl;
@property (weak, nonatomic) IBOutlet UILabel *billerDetailsLbl;
@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLbl;
@property (weak, nonatomic) IBOutlet UIView *lastView;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextFielf;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;




// Click Event Method
- (IBAction)paymentBtn:(id)sender;
- (IBAction)backBtnClicked:(id)sender;


@end
