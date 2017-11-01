//
//  PayBillViewController.h
//  MoneyTransfer
//
//  Created by apple on 23/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PayBillViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

{
    MBProgressHUD *HUD;
    NSMutableArray *billOptionArray,*DataArray ;
    CALayer *amountLayer,*meterLayer,*receiverPhnNoLayer,*emailAddressLayer,*fullNameLayer,*phnNoLayer,*fullNameProLayer,*ageTextLayer,*studentRegistrationNoLayer,*studentFullNameLayer,*classLayer,*clientNameLayer,*equipmentIdLayer;
    
    NSMutableDictionary *PaymentUserData;
    NSString *billOptionID;
    NSString *amount;
    UIView *requiredInfoView;
    UITableView *genderTableView;
    NSMutableArray *requiredFldArray;
    BOOL isNumberKeypad;
    int currentTag;
    NSMutableDictionary * billOptionDict;
}

//property
@property (strong, nonatomic) IBOutlet UITextField *navigationTitleTextField;
@property (strong, nonatomic) NSMutableDictionary *billUserData;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *billOptionTableView;
@property (strong, nonatomic) IBOutlet UILabel *billOptionLbl;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *amountView;
@property (strong, nonatomic) IBOutlet UILabel *amountHeadingLbl;
@property (strong, nonatomic) IBOutlet UILabel *amountLbl;
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) IBOutlet UIView *paybillView;
@property (strong, nonatomic) IBOutlet UILabel *billNameLbl;

// Click Events
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)billOptionBtn:(id)sender;
- (IBAction)payBillBtn:(id)sender;

@end
