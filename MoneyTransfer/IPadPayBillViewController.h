//
//  IPadPayBillViewController.h
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface IPadPayBillViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>

{
    MBProgressHUD *HUD;
    NSMutableArray *billOptionArray,*DataArray;
    CALayer *amountLayer,*meterLayer,*receiverPhnNoLayer,*emailAddressLayer,*fullNameLayer,*phnNoLayer,*fullNameProLayer,*ageTextLayer,*studentRegistrationNoLayer,*studentFullNameLayer,*classLayer,*clientNameLayer,*equipmentIdLayer;
    
    NSMutableDictionary *PaymentUserData;
    NSString *billOptionID;
    NSString *amount;
    
    UIView *requiredInfoView;
    UITableView *genderTableView;
    NSMutableArray *requiredFldArray;
    int currentTag;
    NSMutableDictionary * billOptionDict;
}

// Property
@property (strong, nonatomic) IBOutlet UITextField *navigationTitleTextField;
@property (strong, nonatomic) NSMutableDictionary *billUserData;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *billOptionTableView;
@property (strong, nonatomic) IBOutlet UITableView *sexTableView;
@property (strong, nonatomic) IBOutlet UILabel *sexLbl;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *instructionLbl;
@property (strong, nonatomic) IBOutlet UILabel *providerLbl;
@property (strong, nonatomic) IBOutlet UILabel *categoryLbl;
@property (strong, nonatomic) IBOutlet UILabel *billOptionLbl;
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (strong, nonatomic) IBOutlet UILabel *amountHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *amountLbl;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UILabel *meterHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *MeterLbl;
@property (strong, nonatomic) IBOutlet UITextField *meterTextField;
@property (strong, nonatomic) IBOutlet UIView *electricityView;
@property (strong, nonatomic) IBOutlet UIView *airtimeView;
@property (strong, nonatomic) IBOutlet UILabel *receiverPhnNoHeadingLbl;
@property (strong, nonatomic) IBOutlet UITextField *receiverPhnNoTextField;
@property (strong, nonatomic) IBOutlet UILabel *receiverPhnNoLbl;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressLbl;
@property (strong, nonatomic) IBOutlet UILabel *emailAddressHeadinglbl;
@property (strong, nonatomic) IBOutlet UIView *healthPurchaseView;
@property (strong, nonatomic) IBOutlet UILabel *fullNameHeadingLbl;
@property (strong, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (strong, nonatomic) IBOutlet UIView *paybillView;
@property (strong, nonatomic) IBOutlet UILabel *phnNoHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *phnNoLbl;
@property (strong, nonatomic) IBOutlet UITextField *phnNoTextField;
@property (strong, nonatomic) IBOutlet UIView *healthProcedureView;
@property (strong, nonatomic) IBOutlet UILabel *fullNameProHeadingLbl;
@property (strong, nonatomic) IBOutlet UITextField *fullNameProTextField;
@property (strong, nonatomic) IBOutlet UILabel *fullNameProLbl;
@property (strong, nonatomic) IBOutlet UITextField *ageTextField;
@property (strong, nonatomic) IBOutlet UILabel *ageLbl;
@property (strong, nonatomic) IBOutlet UILabel *ageHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *genderLbl;
@property (strong, nonatomic) IBOutlet UILabel *billNameLbl;
@property (strong, nonatomic) IBOutlet UIView *schoolView;
@property (strong, nonatomic) IBOutlet UILabel *studentRegistartionnumberHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *studentRegistartionnumberLbl;
@property (strong, nonatomic) IBOutlet UITextField *studentRegistartionnumberTextField;
@property (strong, nonatomic) IBOutlet UILabel *studentFullNameHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *studentFullNameLbl;
@property (strong, nonatomic) IBOutlet UITextField *studentFullNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *classHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *classLbl;
@property (strong, nonatomic) IBOutlet UITextField *classTextField;
@property (strong, nonatomic) IBOutlet UIView *equipmentView;
@property (strong, nonatomic) IBOutlet UILabel *clientHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *clientLbl;
@property (strong, nonatomic) IBOutlet UITextField *clientTextField;
@property (strong, nonatomic) IBOutlet UILabel *equipmentIDHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *equipmentLbl;
@property (strong, nonatomic) IBOutlet UITextField *equipmentIDTextField;

// Click Action Events
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)billOptionBtn:(id)sender;
- (IBAction)payBillBtn:(id)sender;



@end


