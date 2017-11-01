//
//  ChannelViewController.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 23/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ChannelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSMutableArray * channelArray,*userBeneficiaryData;
    MBProgressHUD * HUD;
    NSString *countryID;
    NSString * selectedSettlementChannelID;
    NSString *settlement_channel_id,*Settlement_Channel_Parameter_id;
    NSMutableDictionary *selectedSettlementDic;
    NSMutableArray *DataArray;
    NSString *selectedBankName;
    BOOL channelFound;
    UIView *parameterView;
    UITableView *bankslistTableView;
    NSMutableDictionary *optionDict;
    int fieldCount;
    NSMutableArray *parameterValueArray;
    int currentTag;
    NSMutableArray *title_array;
}

// Property
@property (strong, nonatomic) IBOutlet UIView *blankView;
@property (strong, nonatomic) IBOutlet UIView *bankView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *lowerView;
@property (strong, nonatomic) IBOutlet UILabel *selectMethodLbl;
@property (strong, nonatomic) IBOutlet UITextField *mobileNumberTextfield;
@property (strong, nonatomic) IBOutlet UITableView *ChannelsTableView;
@property (strong, nonatomic) IBOutlet UILabel *channelNameLbl;
@property (strong, nonatomic) IBOutlet UIView *channelView;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) NSMutableDictionary *userData;

@property (strong, nonatomic) IBOutlet UILabel *bankTypeLbl;
@property (strong, nonatomic) IBOutlet UITextField *accNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *accNumberTextfield;

@property (strong, nonatomic) IBOutlet UITableView *selectedBankTable;

@property (strong, nonatomic) IBOutlet UITableView *titletableView;


// Click Events
- (IBAction)methodsListShowClick:(id)sender;
- (IBAction)channelsListShowClick:(id)sender;
- (IBAction)banksListShowClick:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)saveBeneficiaryBtn:(id)sender;

@end
