//
//  AddBeneFiciaryViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 19/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AddBeneFiciaryViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSMutableArray *allCurrencyArray;
    NSString *selectCountryCode, *selectedCountryName;
    NSString *peopleSelected;
    
    MBProgressHUD *HUD;
    CGRect previousRect;
    CALayer *addressTextViewLayer,*addressTextViewLayer1;
    NSMutableDictionary *benificiaryData;
    
    BOOL KeyboardShow;
    
}

//Property
@property (strong, nonatomic) UITableView *currencyTableView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *upperView;
@property (strong, nonatomic) IBOutlet UIView *lowerView;

// TextField and Textview object
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextView;
@property (strong, nonatomic) IBOutlet UITextField *countryNameTextField;

// Labals object
@property (strong, nonatomic) IBOutlet UILabel *currencyIDLbl;
@property (strong, nonatomic) IBOutlet UIImageView *countryImage;

// Click Events
- (IBAction)currencyBtnClicked:(id)sender;
- (IBAction)continueBtnClicked:(id)sender;
- (IBAction)beneficiaryBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;

@end
