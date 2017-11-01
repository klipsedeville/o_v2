//
//  IPadConfirmPaymentViewController.h
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface IPadConfirmPaymentViewController : UIViewController
{
    MBProgressHUD *HUD;
    NSMutableArray *DataArray;
    NSMutableDictionary *payBillDict;
    
}

// property
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (strong, nonatomic) IBOutlet UILabel *billHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *billLbl;
@property (strong, nonatomic) IBOutlet UILabel *optionHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *optionLbl;
@property (strong, nonatomic) IBOutlet UILabel *amountHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *amountLbl;
@property (strong, nonatomic) IBOutlet UIView *meterAmountView;
@property (strong, nonatomic) IBOutlet UILabel *meterheadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *meterLbl;
@property (strong, nonatomic) IBOutlet UIView *AirtimeView;
@property (strong, nonatomic) IBOutlet UILabel *recPhnNoHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *recPhnNoLbl;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressLbl;
@property (strong, nonatomic) IBOutlet UIView *healthPurchaseView;
@property (strong, nonatomic) IBOutlet UILabel *fullNameHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *phnNoheadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *phnNoLbl;
@property (strong, nonatomic) IBOutlet UIView *heathProcedureView;
@property (strong, nonatomic) IBOutlet UILabel *fullNameProLbl;
@property (strong, nonatomic) IBOutlet UILabel *fullNameProHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *ageHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *ageLbl;
@property (strong, nonatomic) IBOutlet UIView *schoolview;
@property (strong, nonatomic) IBOutlet UILabel *studentRegNoLbl;
@property (strong, nonatomic) IBOutlet UILabel *studentRegNoHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *studentFullNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *studentFullNameHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *classLbl;
@property (strong, nonatomic) IBOutlet UILabel *classHeadingLbl;
@property (strong, nonatomic) IBOutlet UIView *equipmentview;
@property (strong, nonatomic) IBOutlet UILabel *clientNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *clientNameHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *equipmentIDLbl;
@property (strong, nonatomic) IBOutlet UILabel *equipmentIDheadingLbl;
@property (strong, nonatomic) NSMutableDictionary *paymentData;
@property (strong, nonatomic) NSMutableArray *paymentUserData;
@property (strong, nonatomic) NSMutableArray *DataArray;
@property (strong, nonatomic) IBOutlet UIView *fieldView;
@property (strong, nonatomic) NSString *descriptionBillLbl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *billCategoryId;

// Click Action Events
- (IBAction)paymentBtn:(id)sender;
- (IBAction)backBtnClicked:(id)sender;

@end
