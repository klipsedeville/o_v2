//
//  IPadPayBillViewController.m
//  MoneyTransfer
//
//  Created by apple on 24/06/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "IPadPayBillViewController.h"
#import "Controller.h"
#import "IPadConfirmPaymentViewController.h"
#import "Constants.h"
#import "CCTextFieldEffects.h"
#import "iPadLoginViewController.h"

@interface IPadPayBillViewController ()

@end

@implementation IPadPayBillViewController

#pragma mark ###########
#pragma mark - View Life Cycle methods
#pragma mark ###########

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.billOptionTableView.dataSource = self;
    self.billOptionTableView.delegate = self;
    _billOptionTableView.bounces = NO;
    
    self.billOptionTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.billOptionTableView.layer.borderWidth = 2.0;
    self.billOptionTableView.layer.cornerRadius = 4.0;
    
    
    self.amountTextField.delegate = self;
    self.meterTextField.delegate = self;
    self.receiverPhnNoTextField.delegate = self;
    self.emailAddressTextField.delegate = self;
    self.fullNameTextField.delegate = self;
    self.phnNoTextField.delegate = self;
    self.fullNameProTextField.delegate = self;
    self.ageTextField.delegate = self;
    
    self.studentRegistartionnumberTextField.delegate = self;
    self.studentFullNameTextField.delegate = self;
    self.classTextField.delegate = self;
    
    self.clientTextField.delegate = self;
    self.equipmentIDTextField.delegate = self;
    
    PaymentUserData = [[NSMutableDictionary alloc]init];
    
    _scrollView.bounces = NO;
    
    UITapGestureRecognizer *gueture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handletap:)];
    gueture.delegate = self;
    [self.view addGestureRecognizer:gueture];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor =[self colorWithHexString:@"10506b"];
    
    billOptionDict = [[NSMutableDictionary alloc] init];
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];

    requiredFldArray = [[NSMutableArray alloc] init];
    
    _sexTableView.hidden = YES;
    
    amountLayer = [CALayer layer];
    amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
    amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.amountTextField.layer addSublayer:amountLayer];
    
    meterLayer = [CALayer layer];
    meterLayer.frame = CGRectMake(0.0f, self.meterTextField.frame.size.height - 1, self.meterTextField.frame.size.width, 1.0f);
    meterLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.meterTextField.layer addSublayer:meterLayer];
    
    receiverPhnNoLayer = [CALayer layer];
    receiverPhnNoLayer.frame = CGRectMake(0.0f, self.receiverPhnNoTextField.frame.size.height - 1, self.receiverPhnNoTextField.frame.size.width, 1.0f);
    receiverPhnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.receiverPhnNoTextField.layer addSublayer:receiverPhnNoLayer];
    
    emailAddressLayer = [CALayer layer];
    emailAddressLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
    emailAddressLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.emailAddressTextField.layer addSublayer:emailAddressLayer];
    fullNameLayer = [CALayer layer];
    fullNameLayer.frame = CGRectMake(0.0f, self.fullNameTextField .frame.size.height - 1, self.fullNameTextField .frame.size.width, 1.0f);
    fullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.fullNameTextField .layer addSublayer:fullNameLayer];
    
    phnNoLayer = [CALayer layer];
    phnNoLayer.frame = CGRectMake(0.0f, self.phnNoTextField .frame.size.height - 1, self.phnNoTextField .frame.size.width, 1.0f);
    phnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.phnNoTextField .layer addSublayer:phnNoLayer];
    
    fullNameProLayer = [CALayer layer];
    fullNameProLayer.frame = CGRectMake(0.0f, self.fullNameProTextField .frame.size.height - 1, self.fullNameProTextField .frame.size.width, 1.0f);
    fullNameProLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.fullNameProTextField .layer addSublayer:fullNameProLayer];
    
    ageTextLayer = [CALayer layer];
    ageTextLayer.frame = CGRectMake(0.0f, self.ageTextField .frame.size.height - 1, self.ageTextField .frame.size.width, 1.0f);
    ageTextLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.ageTextField .layer addSublayer:ageTextLayer];
    
    studentRegistrationNoLayer = [CALayer layer];
    studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
    studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
    
    studentFullNameLayer = [CALayer layer];
    studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
    studentFullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
    
    classLayer = [CALayer layer];
    classLayer.frame = CGRectMake(0.0f, self.classTextField .frame.size.height - 1, self.classTextField .frame.size.width, 1.0f);
    classLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.classTextField .layer addSublayer:classLayer];
    
    clientNameLayer = [CALayer layer];
    clientNameLayer.frame = CGRectMake(0.0f, self.clientTextField .frame.size.height - 1, self.clientTextField .frame.size.width, 1.0f);
    clientNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.clientTextField .layer addSublayer:clientNameLayer];
    
    equipmentIdLayer = [CALayer layer];
    equipmentIdLayer.frame = CGRectMake(0.0f, self.equipmentIDTextField .frame.size.height - 1, self.equipmentIDTextField .frame.size.width, 1.0f);
    equipmentIdLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
    [self.equipmentIDTextField .layer addSublayer:equipmentIdLayer];
    _amountHeadingLbl.hidden = YES;
    _meterHeadingLbl.hidden = YES;
    _receiverPhnNoHeadingLbl.hidden = YES;
    _emailAddressHeadinglbl.hidden = YES;
    _fullNameHeadingLbl.hidden = YES;
    _phnNoHeadingLbl.hidden = YES;
    _fullNameProHeadingLbl.hidden = YES;
    _ageHeadingLbl.hidden = YES;
    
    _studentRegistartionnumberHeadingLbl.hidden = YES;
    _studentFullNameHeadingLbl.hidden = YES;
    _classHeadingLbl.hidden = YES;
    
    _clientHeadingLbl.hidden = YES;
    _equipmentIDHeadingLbl.hidden = YES;
    
    UITapGestureRecognizer *tapGestureAmount = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureMeter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureReceiverPhnNo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureEmailAddress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureFullName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGesturePhnNo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureFullNamePro = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureAge = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureStudentRegNo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureStudentFullName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureClass = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureClientName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    UITapGestureRecognizer *tapGestureEquipmentID = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DidRecognizeTapGesture:)];
    
    
    _amountLbl.userInteractionEnabled = YES;
    _MeterLbl.userInteractionEnabled = YES;
    _receiverPhnNoLbl.userInteractionEnabled = YES;
    _emailAddressLbl.userInteractionEnabled = YES;
    _fullNameLbl.userInteractionEnabled = YES;
    _phnNoLbl.userInteractionEnabled = YES;
    _fullNameProLbl.userInteractionEnabled = YES;
    _ageLbl.userInteractionEnabled = YES;
    
    _studentRegistartionnumberLbl.userInteractionEnabled = YES;
    _studentFullNameLbl.userInteractionEnabled = YES;
    _classLbl.userInteractionEnabled = YES;
    
    _clientLbl.userInteractionEnabled = YES;
    _equipmentLbl.userInteractionEnabled = YES;
    
    [self.amountLbl addGestureRecognizer:tapGestureAmount];
    [self.MeterLbl addGestureRecognizer:tapGestureMeter];
    [self.receiverPhnNoLbl addGestureRecognizer:tapGestureReceiverPhnNo];
    [self.emailAddressLbl addGestureRecognizer:tapGestureEmailAddress];
    [self.fullNameLbl addGestureRecognizer:tapGestureFullName];
    [self.phnNoLbl addGestureRecognizer:tapGesturePhnNo];
    [self.fullNameProLbl addGestureRecognizer:tapGestureFullNamePro];
    [self.ageLbl addGestureRecognizer:tapGestureAge];
    
    [self.studentRegistartionnumberLbl addGestureRecognizer:tapGestureStudentRegNo];
    [self.studentFullNameLbl addGestureRecognizer:tapGestureStudentFullName];
    [self.classLbl addGestureRecognizer:tapGestureClass];
    
    [self.clientLbl addGestureRecognizer:tapGestureClientName];
    [self.equipmentLbl addGestureRecognizer:tapGestureEquipmentID];
    
    _amountLbl.tag = 1;
    _MeterLbl.tag = 2;
    _receiverPhnNoLbl.tag = 3;
    _emailAddressLbl.tag = 4;
    _fullNameLbl.tag = 5;
    _phnNoLbl.tag = 6;
    _fullNameProLbl.tag = 7;
    _ageLbl.tag = 8;
    
    _studentRegistartionnumberLbl.tag = 9;
    _studentFullNameLbl.tag = 10;
    _classLbl.tag = 11;
    
    _clientLbl.tag = 12;
    _equipmentLbl.tag = 13;
    
    billOptionArray = [[NSMutableArray alloc]init];
    DataArray = [[NSMutableArray alloc]init];
    
    billOptionArray = [_billUserData valueForKeyPath:@"bill_options.title"];
    
    _billOptionLbl.text = [billOptionArray objectAtIndex:0];
    
    NSArray *amountArr = [_billUserData valueForKeyPath:@"bill_options"];
    NSString *amountstr = [[amountArr objectAtIndex:0]valueForKey:@"amount"];
    
    if (billOptionArray.count>0) {
        float height = 70;
        height = height* billOptionArray.count;
        
        if (height> 280) {
            self.billOptionTableView.frame = CGRectMake(self.billOptionTableView.frame.origin.x, self.billOptionTableView.frame.origin.y, self.billOptionTableView.frame.size.width,280 );
        }
        else{
            self.billOptionTableView.frame = CGRectMake(self.billOptionTableView.frame.origin.x, self.billOptionTableView.frame.origin.y, self.billOptionTableView.frame.size.width,height );
        }
    }
    
    _amountLbl.hidden = YES;
    _amountHeadingLbl.hidden = NO;
    _amountTextField.text = [NSString stringWithFormat:@"%@",amountstr];
    
    billOptionID =[[amountArr objectAtIndex:0]valueForKey:@"id"];
    _descriptionLabel.text = [ NSString stringWithFormat:@"%@",[_billUserData valueForKeyPath:@"bill_provider.title"]];
    _navigationTitleTextField.text = @"Bill Details";
    _billNameLbl.text = [_billUserData valueForKeyPath:@"title"];
    _instructionLbl.text=[_billUserData valueForKeyPath:@"Bill.instructions"];
    _instructionLbl.lineBreakMode = UILineBreakModeWordWrap;
    _instructionLbl.numberOfLines = 2;
    [_instructionLbl sizeToFit];
    _providerLbl.text = [NSString stringWithFormat:@"Provider: %@",[_billUserData valueForKeyPath:@"bill_provider.title"]];
    _providerLbl.lineBreakMode = UILineBreakModeWordWrap;
    _providerLbl.numberOfLines = 2;
    [_providerLbl sizeToFit];
    
    _categoryLbl.text =[NSString stringWithFormat:@"Category: %@",[_billUserData valueForKeyPath:@"bill_category.title"]];
    
    _instructionLbl.frame = CGRectMake(_instructionLbl.frame.origin.x,_instructionLbl.frame.origin.y,_instructionLbl.frame.size.width,_instructionLbl.frame.size.height);
    _providerLbl.frame = CGRectMake(_providerLbl.frame.origin.x,_instructionLbl.frame.origin.y+_instructionLbl.frame.size.height+10,_providerLbl.frame.size.width,_providerLbl.frame.size.height);
    
    _categoryLbl.frame = CGRectMake(_categoryLbl.frame.origin.x,_providerLbl.frame.origin.y+_providerLbl.frame.size.height+10,_categoryLbl.frame.size.width,_categoryLbl.frame.size.height);
    
    // -----------------------  Dynamic view  ---------------------------
    
    
    NSArray *requiredFieldArray = [_billUserData valueForKey:@"bill_required_fields"];
    
    [requiredInfoView removeFromSuperview];
    requiredInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, _amountView.frame.origin.y+_amountView.frame.size.height +40 , SCREEN_WIDTH, (requiredFieldArray.count * 110) + 100)];
    requiredInfoView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:requiredInfoView];
    
    UILabel *requiredInfoTitleLbl = [[UILabel alloc] init];
    requiredInfoTitleLbl.frame = CGRectMake(20, 30, SCREEN_WIDTH-40, 40);
    requiredInfoTitleLbl.text = @"REQUIRED INFORMATION";
    requiredInfoTitleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:32];
    requiredInfoTitleLbl.textColor = [self colorWithHexString:@"51595c"];
    [requiredInfoView addSubview:requiredInfoTitleLbl];
    
    if (requiredFieldArray.count >0)
    {
    [requiredInfoView removeFromSuperview];
    requiredInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, _amountView.frame.origin.y+_amountView.frame.size.height +40 , SCREEN_WIDTH, (requiredFieldArray.count * 110) + 100)];
    requiredInfoView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:requiredInfoView];
    
    UILabel *requiredInfoTitleLbl = [[UILabel alloc] init];
    requiredInfoTitleLbl.frame = CGRectMake(20, 30, SCREEN_WIDTH-40, 40);
    requiredInfoTitleLbl.text = @"REQUIRED INFORMATION";
    requiredInfoTitleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:32];
    requiredInfoTitleLbl.textColor = [self colorWithHexString:@"51595c"];
    [requiredInfoView addSubview:requiredInfoTitleLbl];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20,requiredInfoTitleLbl.frame.size.height+requiredInfoTitleLbl.frame.origin.y + 8,SCREEN_WIDTH-40,2)];
    lineView.backgroundColor=[self colorWithHexString:@"51595c"];
    [requiredInfoView addSubview:lineView];
    
    for(int i=0; i<[requiredFieldArray count]; i++)
    {
        NSDictionary *tempDict = [requiredFieldArray objectAtIndex:i];
        NSString * placeholderString = [[tempDict valueForKey:@"title"] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        
        NSString *typeStr = [tempDict valueForKeyPath:@"bill_field_type.type"];
        
        if([typeStr isEqualToString:@"text"] || [typeStr isEqualToString:@"textarea"])
        {
            
            
            HoshiTextField *parameterTextField = [[HoshiTextField alloc] initWithFrame:CGRectMake(20.0f, 90+(i*110), SCREEN_WIDTH-40, 80.0f)];
            
            parameterTextField.placeholder = [placeholderString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[placeholderString substringToIndex:1] uppercaseString]];
            
            
            // The size of the placeholder label relative to the font size of the text field, default value is 0.65
            parameterTextField.placeholderFontScale = 1;
            
            // The color of the inactive border, default value is R185 G193 B202
            parameterTextField.borderInactiveColor = [self colorWithHexString:@"51595c"];
            
            // The color of the active border, default value is R106 B121 B137
            parameterTextField.borderActiveColor = [self colorWithHexString:@"3ec6f0"];
            
            // The color of the placeholder, default value is R185 G193 B202
            parameterTextField.placeholderColor = [self colorWithHexString:@"51595c"];
            
            // The color of the cursor, default value is R89 G95 B110
            parameterTextField.cursorColor = [self colorWithHexString:@"3ec6f0"];
            
            // The color of the text, default value is R89 G95 B110
            parameterTextField.textColor = [UIColor blackColor];
            
            parameterTextField.font = [UIFont fontWithName:@"MyriadPro-Regular" size:32];
            
            parameterTextField.delegate = self;
            
            
            // The block excuted when the animation for obtaining focus has completed.
            // Do not use textFieldDidBeginEditing:
            parameterTextField.didBeginEditingHandler = ^{
                
            };
            
            // The block excuted when the animation for losing focus has completed.
            // Do not use textFieldDidEndEditing:
            parameterTextField.didEndEditingHandler = ^{
                
                // ...
            };
            
            [requiredInfoView addSubview:parameterTextField];
            
            NSMutableDictionary *fieldDic = [[ NSMutableDictionary alloc] init];
            [fieldDic setObject: parameterTextField forKey:@"reqFldTextField"];
            [fieldDic setObject: [tempDict valueForKey:@"id"] forKey:@"reqFldID"];
            [fieldDic setObject: parameterTextField.placeholder forKey:@"placeHolder"];
            
            [requiredFldArray addObject:fieldDic];
            
        }
        else if([typeStr isEqualToString:@"select"])
        {
            NSString *optionsString = [tempDict valueForKey:@"select_options"];
            
            NSArray * billSelectOptionArray = [optionsString componentsSeparatedByString:@";"];
            
            requiredInfoView.frame = CGRectMake(requiredInfoView.frame.origin.x, requiredInfoView.frame.origin.y, requiredInfoView.frame.size.width, requiredInfoView.frame.size.height+60);
            
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.frame = CGRectMake(20, (i*140)+40, SCREEN_WIDTH-40, 40);
            titleLbl.text = [NSString stringWithFormat:@"Select a %@",[[tempDict valueForKey:@"title"] stringByReplacingOccurrencesOfString:@"_" withString:@" "]];
            titleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:28];
            titleLbl.textColor = [self colorWithHexString:@"51595c"];
            [requiredInfoView addSubview:titleLbl];
            
            UIButton *genderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [genderBtn addTarget:self action:@selector(genderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [genderBtn setFrame:CGRectMake(20.0f, titleLbl.frame.origin.y + titleLbl.frame.size.height + 5, SCREEN_WIDTH-40, 80.0f)];
            genderBtn.tag = 100+i;
            [requiredInfoView addSubview:genderBtn];
            
            
            UILabel *genderTitleLbl = [[UILabel alloc] init];
            genderTitleLbl.frame = CGRectMake(0, 0, genderBtn.frame.size.width, genderBtn.frame.size.height);
            genderTitleLbl.text = [billSelectOptionArray objectAtIndex:0];
            genderTitleLbl.font = [UIFont fontWithName:@"MyriadPro-Regular" size:32];
            genderTitleLbl.textColor = [self colorWithHexString:@"51595c"];
            genderTitleLbl.tag = 200+i;
            [genderBtn addSubview:genderTitleLbl];
            
            UIImageView * downArrow = [[UIImageView alloc] init];
            downArrow.frame = CGRectMake(genderBtn.frame.size.width-40, 20, 20, 20);
            downArrow.image = [UIImage imageNamed:@"downArrow.png"];
            [genderBtn addSubview:downArrow];
            
            NSMutableDictionary *fieldDic = [[ NSMutableDictionary alloc] init];
            [fieldDic setObject: genderTitleLbl forKey:@"reqFldTextField"];
            [fieldDic setObject: [tempDict valueForKey:@"id"] forKey:@"reqFldID"];
            [fieldDic setObject: placeholderString forKey:@"placeHolder"];
            
            [requiredFldArray addObject:fieldDic];
            
            
            [billOptionDict setObject:billSelectOptionArray forKey:[NSString stringWithFormat:@"%ld",(long)genderBtn.tag]];
        }
    }
    
    
    float sizeOfContent = 0;
    NSInteger wd = requiredInfoView.frame.origin.y;
    NSInteger ht = requiredInfoView.frame.size.height;
    
    sizeOfContent = wd+ht;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    }
}

-(void)handletap:(UITapGestureRecognizer*)sender{
    
    [genderTableView setHidden:YES];
    
    self.scrollView.scrollEnabled = YES;
    
}

-(void)genderBtnAction : (UIButton *)sender
{
    currentTag = (int)sender.tag;
    
    [self.view endEditing:YES];
    
    NSArray * billSelectOptionArray = [billOptionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    
    [genderTableView removeFromSuperview];
    genderTableView=[[UITableView alloc]initWithFrame:CGRectMake(sender.frame.origin.x, sender.frame.origin.y + requiredInfoView.frame.origin.y + sender.frame.size.height - (billSelectOptionArray.count*70) , sender.frame.size.width-22, billSelectOptionArray.count*70 ) style:UITableViewStylePlain];
    
    if(genderTableView.frame.origin.y < 0)
    {
        float height = genderTableView.frame.origin.y;
        
        genderTableView.frame = CGRectMake(genderTableView.frame.origin.x, 5, genderTableView.frame.size.width, (genderTableView.frame.size.height + height)-5 );
    }
    
    genderTableView.delegate=self;
    genderTableView.dataSource=self;
    [genderTableView setAllowsSelection:YES];
    [genderTableView setScrollEnabled:YES];
    [_scrollView addSubview:genderTableView];
    
    genderTableView.backgroundColor=[UIColor lightGrayColor];
    genderTableView.layer.cornerRadius = 0.0;
    genderTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    genderTableView.layer.borderWidth= 1;
    genderTableView.bounces = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.billOptionTableView]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:genderTableView]) {
        return NO;
    }
    if ([touch.view isDescendantOfView:self.sexTableView]) {
        return NO;
    }
    
    _billOptionTableView.hidden = YES;
    genderTableView.hidden = YES;
    
    return YES;
}

#pragma mark ########
#pragma mark Click Action Events
#pragma mark ########

- (IBAction)backBtnClicked:(id)sender {
    
    [ self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)billOptionBtn:(id)sender {
    
    if ([billOptionArray count] == 0 )
    {
        _billOptionTableView.hidden = YES;
    }
    else if (_billOptionTableView.hidden == YES) {
        _billOptionTableView.hidden = NO;
        [_billOptionTableView reloadData];
        
        [ _amountTextField resignFirstResponder];
        [ _meterTextField resignFirstResponder];
        [ self.receiverPhnNoTextField resignFirstResponder];
        [  self.emailAddressTextField resignFirstResponder];
        [ self.fullNameTextField resignFirstResponder];
        [  self.phnNoTextField resignFirstResponder];
        [ self.fullNameProTextField resignFirstResponder];
        [  self.fullNameProTextField resignFirstResponder];
        [ self.ageTextField resignFirstResponder];
        
    }
    else{
        _billOptionTableView.hidden = NO;
    }
    
    [_scrollView sendSubviewToBack: requiredInfoView];
}

- (IBAction)payBillBtn:(id)sender {
    
    
    if(_amountTextField.text.length==0 || [_amountTextField.text isEqualToString:@"0.00"])
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:@"Enter an amount" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
        return;
    }
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    
   NSString *billID =[ NSString stringWithFormat:@"%@", [_billUserData valueForKeyPath:@"bill_provider.bill_category_id"]];
    
    for ( NSDictionary *fieldDic in requiredFldArray) {
        NSString *textString;
        
        if([[ fieldDic objectForKey:@"reqFldTextField"] isKindOfClass:[HoshiTextField class]])
        {
            HoshiTextField *fldText = [ fieldDic objectForKey:@"reqFldTextField"];
            textString = [fldText.text stringByTrimmingCharactersInSet:whitespace];
        }
        else
        {
            UILabel *fldText = [ fieldDic objectForKey:@"reqFldTextField"];
            textString = [fldText.text stringByTrimmingCharactersInSet:whitespace];
        }
        if(textString.length==0)
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:[NSString stringWithFormat:@"%@ is required",[ fieldDic objectForKey:@"placeHolder"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertview show];
            
            return;
        }
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
        [ dict1 setObject:billID forKey:@"bill_id"];
        [ dict1 setObject:[fieldDic valueForKey:@"reqFldID"] forKey:@"bill_required_field_id"];
        [ dict1 setObject:textString forKey:@"collected_data"];
        [DataArray addObject:dict1];
    }
    
//    [PaymentUserData setValue:_titleLbl.text forKey:@"bill"];
//    [PaymentUserData setValue:_billOptionLbl.text forKey:@"optionName"];
//    [PaymentUserData setValue:_amountTextField.text forKey:@"amount"];
//    [PaymentUserData setValue:_meterTextField.text forKey:@"meter"];
//    [PaymentUserData setValue:_receiverPhnNoTextField.text forKey:@"receiverPhnNo"];
//    [PaymentUserData setValue:_emailAddressTextField.text forKey:@"emailAddress"];
//    [PaymentUserData setValue:_fullNameTextField.text forKey:@"fullName"];
//    [PaymentUserData setValue:_phnNoTextField.text forKey:@"phnNo"];
//    [PaymentUserData setValue:_fullNameProTextField.text forKey:@"_fullNamePro"];
//    [PaymentUserData setValue:_ageTextField.text forKey:@"age"];
//    [PaymentUserData setValue:_studentRegistartionnumberTextField.text forKey:@"studentRegNo"];
//    [PaymentUserData setValue:_studentFullNameTextField.text forKey:@"studentFullName"];
//    [PaymentUserData setValue:_classTextField.text forKey:@"class"];
//    [PaymentUserData setValue:_clientTextField.text forKey:@"client"];
//    [PaymentUserData setValue:_equipmentIDTextField.text forKey:@"equipmentID"];
//    [PaymentUserData setValue:billOptionID forKey:@"billOptionID"];
    
    
    [PaymentUserData setValue:_billOptionLbl.text forKey:@"option_name"];
    [PaymentUserData setValue:_amountTextField.text forKey:@"amount"];
    [PaymentUserData setValue:billOptionID forKey:@"bill_optionID"];
    [self performSegueWithIdentifier:@"confirmpayment" sender:self];
    
    
//     // call pay bill
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = NSLocalizedString(@"Loading...", nil);
//    [HUD show:YES];
//
//    [self callPayBill];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue to Beneficiary screen");
    if([[segue identifier] isEqualToString:@"confirmpayment"])
    {
        
        IPadConfirmPaymentViewController *vc = [segue destinationViewController];
        vc.paymentData = PaymentUserData;
        vc.paymentUserData = requiredFldArray;
        vc.DataArray = DataArray;
        vc.descriptionBillLbl = _billNameLbl.text;
        vc.billCategoryId = [_billUserData valueForKeyPath:@"bill_category_id"];
    }
}

#pragma mark ########
#pragma mark Call Pay bill
#pragma mark ########

-(void)callPayBill
{
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
  
    userDataDict = [userDataDict valueForKeyPath:@"User"];
   
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    // Create dictionary of data for beneficiary
    NSMutableDictionary *dictA = [[NSMutableDictionary alloc]init];
    [dictA setValue:[NSString stringWithFormat:@"%@",[_billUserData valueForKeyPath:@"BillCategory.id"]] forKey:@"bill_id"];
    [dictA setValue:billOptionID forKey:@"bill_option_id"];
    [dictA setValue:_amountTextField.text forKey:@"amount"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObjectsAndKeys:dictA, @"BillPayment", DataArray, @"BillCollectedField", nil] options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
    // Encrypt the user token using public data and iv data
    NSData *EncodedData = [FBEncryptorAES encryptData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64TokenString = [EncodedData base64EncodedStringWithOptions:0];
    
    NSMutableData *PostData =[[NSMutableData alloc] initWithData:[base64TokenString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@/%@", BaseUrl, PayBill];
    NSURL *url = [NSURL URLWithString:ApiUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request addValue: userTokenString forHTTPHeaderField:@"token"];
    
    [request setHTTPBody:PostData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if communication was successful
        if (!error) {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200)
            {
                
                NSString* resultString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"result string %@", resultString);
                
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:resultString options:0];
                
                NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
                if (data1)
                {[HUD removeFromSuperview];
                    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data1  options:NSJSONReadingMutableContainers error:&error];
                    
                    NSInteger status = [[responseDic valueForKeyPath:@"PayLoad.status"] integerValue];
                    
                    if (status == 0)
                    {
                        NSArray *errorArray =[ responseDic valueForKeyPath:@"PayLoad.error"];
                        NSLog(@"error ..%@", errorArray);
                        
                        NSString * errorString =[ NSString stringWithFormat:@"%@",[errorArray objectAtIndex:0]];
                        
                        if(!errorString || [errorString isEqualToString:@"(null)"])
                        {
                            errorString = @"Your session has been expired.";
                            
                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            alertview.tag = 1003;
                            
                            [alertview show];
                        }
                        else
                        {
                            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle: @"Alert!" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            alertview.tag = 1002;
                            
                            [alertview show];
                        }
                    }
                    else
                    {
                        [HUD removeFromSuperview];
                        
                        [PaymentUserData setValue:_titleLbl.text forKey:@"bill"];
                        [PaymentUserData setValue:_billOptionLbl.text forKey:@"optionName"];
                        [PaymentUserData setValue:_amountTextField.text forKey:@"amount"];
                        [PaymentUserData setValue:_meterTextField.text forKey:@"meter"];
                        [PaymentUserData setValue:_receiverPhnNoTextField.text forKey:@"receiverPhnNo"];
                        [PaymentUserData setValue:_emailAddressTextField.text forKey:@"emailAddress"];
                        [PaymentUserData setValue:_fullNameTextField.text forKey:@"fullName"];
                        [PaymentUserData setValue:_phnNoTextField.text forKey:@"phnNo"];
                        [PaymentUserData setValue:_fullNameProTextField.text forKey:@"_fullNamePro"];
                        [PaymentUserData setValue:_ageTextField.text forKey:@"age"];
                        [PaymentUserData setValue:_studentRegistartionnumberTextField.text forKey:@"studentRegNo"];
                        [PaymentUserData setValue:_studentFullNameTextField.text forKey:@"studentFullName"];
                        [PaymentUserData setValue:_classTextField.text forKey:@"class"];
                        [PaymentUserData setValue:_clientTextField.text forKey:@"client"];
                        [PaymentUserData setValue:_equipmentIDTextField.text forKey:@"equipmentID"];
                        [PaymentUserData setValue:billOptionID forKey:@"billOptionID"];
                        
                        NSLog(@"Transfer request...%@",responseDic );
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self performSegueWithIdentifier:@"confirmpayment" sender:self];
                        });
                    }
                }
            }
        }
    }];
    [postDataTask resume];
}

#pragma mark ########
#pragma mark Alert view Delegate
#pragma mark ########

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==1002)
    {
        if (buttonIndex==0)
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                
                if ([controller isKindOfClass:[iPadLoginViewController class]]) {
                    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    [self.navigationController setNavigationBarHidden:NO];
                    
                    break;
                }
            }
        }
        
    }
    else if(alertView.tag ==1003)
    {
        if (buttonIndex==0)
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                
                if ([controller isKindOfClass:[iPadLoginViewController class]]) {
                    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    [self.navigationController setNavigationBarHidden:NO];
                    
                    break;
                }
            }
        }
        
    }
}

#pragma mark ###########
#pragma mark - Table View Method
#pragma mark ###########

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _billOptionTableView) {
        return [billOptionArray count];
    }
    
    else
    {
        NSArray * billSelectOptionArray = [billOptionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)currentTag]];
        
        return [billSelectOptionArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(tableView == _billOptionTableView)
    {
        cell.textLabel.text = [billOptionArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:25];
    }
    else
    {
        NSArray * billSelectOptionArray = [billOptionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)currentTag]];
        
        cell.textLabel.text = [billSelectOptionArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:25];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _billOptionTableView)
    {
        _billOptionLbl.text = [NSString stringWithFormat:@"%@",[billOptionArray objectAtIndex:indexPath.row]];
        
        NSArray *BilloptionArray = [_billUserData valueForKey:@"BillOption"];
        _amountHeadingLbl.hidden = NO;
        _amountLbl.hidden = YES;
        
        _amountTextField.text = [[BilloptionArray objectAtIndex:indexPath.row]valueForKey:@"amount"];
        
        billOptionID =[[BilloptionArray objectAtIndex:indexPath.row]valueForKey:@"id"];
        
        _billOptionTableView.hidden = YES;
        
        
        if (![ _amountTextField.text isEqualToString:@"0.00"]) {
            _amountTextField.userInteractionEnabled = false;
        }
        else{
            _amountTextField.userInteractionEnabled = true;
        }
    }
    else if(tableView == genderTableView)
    {
        UILabel *label = (UILabel *)[self.view viewWithTag:currentTag+100];
        
        NSArray * billSelectOptionArray = [billOptionDict valueForKey:[NSString stringWithFormat:@"%ld",(long)currentTag]];
        
        label.text = [NSString stringWithFormat:@"%@",[billSelectOptionArray objectAtIndex:indexPath.row]];
        
        genderTableView.hidden = YES;
    }
}

#pragma mark ###########
#pragma mark - Guesture Recogniser Method
#pragma mark ###########

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)DidRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    
    UILabel *label = (UILabel*)[gesture view];
    if ( label.tag == 1)
    {
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        amountLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        
    }
    
    if ( label.tag == 2)
    {
        [self.view endEditing: YES];
        _MeterLbl.hidden = YES;
        _meterHeadingLbl.hidden= NO;
        
        meterLayer.frame = CGRectMake(0.0f, self.meterTextField.frame.size.height - 1, self.meterTextField.frame.size.width, 1.0f);
        meterLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.meterTextField.layer addSublayer:meterLayer];
        
        [_meterTextField becomeFirstResponder];
        
        if ([ _amountTextField.text isEqual:@""]) {
            _amountLbl.hidden = NO;
            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
    }
    if ( label.tag == 3)
    {
        [self.view endEditing: YES];
        _receiverPhnNoLbl.hidden = YES;
        _receiverPhnNoHeadingLbl.hidden= NO;
        
        receiverPhnNoLayer.frame = CGRectMake(0.0f, self.receiverPhnNoTextField.frame.size.height - 1, self.receiverPhnNoTextField.frame.size.width, 1.0f);
        receiverPhnNoLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.receiverPhnNoTextField.layer addSublayer:receiverPhnNoLayer];
        [_receiverPhnNoTextField becomeFirstResponder];
        
        if ([ _emailAddressTextField.text isEqual:@""]) {
            _emailAddressLbl.hidden = NO;
            _emailAddressHeadinglbl.hidden= YES;
            
            emailAddressLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            emailAddressLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.emailAddressTextField.layer addSublayer:emailAddressLayer];
            [_emailAddressTextField resignFirstResponder];
        }
        else
        {
            emailAddressLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            emailAddressLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.emailAddressTextField.layer addSublayer:emailAddressLayer];
            
            _emailAddressHeadinglbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            _amountLbl.hidden = NO;
            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
    }
    if ( label.tag == 4)
    {
        [self.view endEditing: YES];
        _emailAddressLbl.hidden = YES;
        _emailAddressHeadinglbl.hidden= NO;
        
        emailAddressLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
        emailAddressLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.emailAddressTextField.layer addSublayer:emailAddressLayer];
        
        [_emailAddressTextField becomeFirstResponder];
        
        if ([ _receiverPhnNoTextField.text isEqual:@""]) {
            _receiverPhnNoLbl.hidden = NO;
            _receiverPhnNoHeadingLbl.hidden= YES;
            
            
            receiverPhnNoLayer.frame = CGRectMake(0.0f, self.receiverPhnNoTextField.frame.size.height - 1, self.receiverPhnNoTextField.frame.size.width, 1.0f);
            receiverPhnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.receiverPhnNoTextField.layer addSublayer:receiverPhnNoLayer];
            [_receiverPhnNoTextField resignFirstResponder];
        }
        else
        {
            receiverPhnNoLayer.frame = CGRectMake(0.0f, self.receiverPhnNoTextField.frame.size.height - 1, self.receiverPhnNoTextField.frame.size.width, 1.0f);
            receiverPhnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.receiverPhnNoTextField.layer addSublayer:receiverPhnNoLayer];
            
            _receiverPhnNoHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            _amountLbl.hidden = NO;
            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
    }
    
    if ( label.tag == 5)
    {
        [self.view endEditing: YES];
        _fullNameLbl.hidden = YES;
        _fullNameHeadingLbl.hidden= NO;
        
        fullNameLayer.frame = CGRectMake(0.0f, self.fullNameTextField.frame.size.height - 1, self.fullNameTextField.frame.size.width, 1.0f);
        fullNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.fullNameTextField.layer addSublayer:fullNameLayer];
        
        [_fullNameTextField becomeFirstResponder];
        
        if ([ _phnNoTextField.text isEqual:@""]) {
            _phnNoLbl.hidden = NO;
            _phnNoHeadingLbl.hidden= YES;
            phnNoLayer.frame = CGRectMake(0.0f, self.phnNoTextField.frame.size.height - 1, self.phnNoTextField.frame.size.width, 1.0f);
            phnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.phnNoTextField.layer addSublayer:phnNoLayer];
            [_phnNoTextField resignFirstResponder];
        }
        else
        {
            phnNoLayer.frame = CGRectMake(0.0f, self.phnNoTextField.frame.size.height - 1, self.phnNoTextField.frame.size.width, 1.0f);
            phnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.phnNoTextField.layer addSublayer:phnNoLayer];
            
            _phnNoHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
        if ([ _amountTextField.text isEqual:@""]) {
            _amountLbl.hidden = NO;
            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    if ( label.tag == 6)
    {
        [self.view endEditing: YES];
        _phnNoLbl.hidden = YES;
        _phnNoHeadingLbl.hidden= NO;
        phnNoLayer.frame = CGRectMake(0.0f, self.phnNoTextField.frame.size.height - 1, self.phnNoTextField.frame.size.width, 1.0f);
        phnNoLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.phnNoTextField.layer addSublayer:phnNoLayer];
        [_phnNoTextField becomeFirstResponder];
        
        if ([ _fullNameTextField.text isEqual:@""]) {
            _fullNameLbl.hidden = NO;
            _fullNameHeadingLbl.hidden= YES;
            
            fullNameLayer.frame = CGRectMake(0.0f, self.fullNameTextField.frame.size.height - 1, self.fullNameTextField.frame.size.width, 1.0f);
            fullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameTextField.layer addSublayer:fullNameLayer];
            [_fullNameTextField resignFirstResponder];
        }
        else
        {
            fullNameLayer.frame = CGRectMake(0.0f, self.fullNameTextField.frame.size.height - 1, self.fullNameTextField.frame.size.width, 1.0f);
            fullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameTextField.layer addSublayer:fullNameLayer];
            
            _fullNameHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
        if ([ _amountTextField.text isEqual:@""]) {
            _amountLbl.hidden = NO;
            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
    }
    if ( label.tag == 7)
    {
        [self.view endEditing: YES];
        _fullNameProLbl.hidden = YES;
        _fullNameProHeadingLbl.hidden= NO;
        
        fullNameProLayer.frame = CGRectMake(0.0f, self.fullNameProTextField.frame.size.height - 1, self.fullNameProTextField.frame.size.width, 1.0f);
        fullNameProLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.fullNameProTextField.layer addSublayer:fullNameProLayer];
        
        [_fullNameProTextField becomeFirstResponder];
        
        if ([ _ageTextField.text isEqual:@""]) {
            _ageLbl.hidden = NO;
            _ageHeadingLbl.hidden= YES;
            
            ageTextLayer.frame = CGRectMake(0.0f, self.ageTextField.frame.size.height - 1, self.ageTextField.frame.size.width, 1.0f);
            ageTextLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.ageTextField.layer addSublayer:ageTextLayer];
            [_ageTextField resignFirstResponder];
        }
        else
        {
            ageTextLayer.frame = CGRectMake(0.0f, self.ageTextField.frame.size.height - 1, self.ageTextField.frame.size.width, 1.0f);
            ageTextLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.ageTextField.layer addSublayer:ageTextLayer];
            
            _ageHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            _amountLbl.hidden = NO;
            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if ( label.tag == 8)
    {
        [self.view endEditing: YES];
        _ageLbl.hidden = YES;
        _ageHeadingLbl.hidden= NO;
        
        ageTextLayer.frame = CGRectMake(0.0f, self.ageTextField.frame.size.height - 1, self.ageTextField.frame.size.width, 1.0f);
        ageTextLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.ageTextField.layer addSublayer:ageTextLayer];
        
        [_ageTextField becomeFirstResponder];
        
        
        if ([ _fullNameProTextField.text isEqual:@""]) {
            _fullNameProLbl.hidden = NO;
            _fullNameProHeadingLbl.hidden= YES;
            
            fullNameProLayer.frame = CGRectMake(0.0f, self.fullNameProTextField.frame.size.height - 1, self.fullNameProTextField.frame.size.width, 1.0f);
            fullNameProLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameProTextField.layer addSublayer:fullNameProLayer];
            [_fullNameProTextField resignFirstResponder];
        }
        else
        {
            fullNameProLayer.frame = CGRectMake(0.0f, self.fullNameProTextField.frame.size.height - 1, self.fullNameProTextField.frame.size.width, 1.0f);
            fullNameProLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameProTextField.layer addSublayer:fullNameProLayer];
            
            _fullNameProLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        if ([ _amountTextField.text isEqual:@""]) {
            _amountLbl.hidden = NO;
            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if ( label.tag == 9)
    {
        [self.view endEditing: YES];
        _studentRegistartionnumberLbl.hidden = YES;
        _studentRegistartionnumberHeadingLbl.hidden= NO;
        
        studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
        studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
        
        [_studentRegistartionnumberTextField becomeFirstResponder];
        
        
        if ([ _studentFullNameTextField.text isEqual:@""]) {
            _studentFullNameLbl.hidden = NO;
            _studentFullNameHeadingLbl.hidden= YES;
            
            studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
            studentFullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
        }
        else
        {
            studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
            studentFullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
            
            _studentRegistartionnumberHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _classTextField.text isEqual:@""]) {
            _classLbl.hidden = NO;
            _classHeadingLbl.hidden= YES;
            
            classLayer = [CALayer layer];
            classLayer.frame = CGRectMake(0.0f, self.classTextField .frame.size.height - 1, self.classTextField .frame.size.width, 1.0f);
            classLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.classTextField .layer addSublayer:classLayer];
        }
        else
        {
            classLayer = [CALayer layer];
            classLayer.frame = CGRectMake(0.0f, self.classTextField .frame.size.height - 1, self.classTextField .frame.size.width, 1.0f);
            classLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.classTextField .layer addSublayer:classLayer];
            _classHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if ( label.tag == 10 )
    {
        [self.view endEditing: YES];
        _studentFullNameLbl.hidden = YES;
        _studentFullNameHeadingLbl.hidden= NO;
        
        studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
        studentFullNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
        
        [_studentFullNameTextField becomeFirstResponder];
        
        
        if ([ _studentRegistartionnumberTextField.text isEqual:@""]) {
            _studentRegistartionnumberLbl.hidden = NO;
            _studentRegistartionnumberHeadingLbl.hidden= YES;
            
            studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
            studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
            
        }
        else
        {
            studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
            studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
            
            _studentRegistartionnumberHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _classTextField.text isEqual:@""]) {
            _classLbl.hidden = NO;
            _classHeadingLbl.hidden= YES;
            
            classLayer = [CALayer layer];
            classLayer.frame = CGRectMake(0.0f, self.classTextField .frame.size.height - 1, self.classTextField .frame.size.width, 1.0f);
            classLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.classTextField .layer addSublayer:classLayer];
        }
        else
        {
            classLayer = [CALayer layer];
            classLayer.frame = CGRectMake(0.0f, self.classTextField .frame.size.height - 1, self.classTextField .frame.size.width, 1.0f);
            classLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.classTextField .layer addSublayer:classLayer];
            
            _classHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if ( label.tag == 11 )
    {
        
        [self.view endEditing: YES];
        _classLbl.hidden = YES;
        _classHeadingLbl.hidden= NO;
        
        classLayer.frame = CGRectMake(0.0f, self.classTextField .frame.size.height - 1, self.classTextField .frame.size.width, 1.0f);
        classLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.classTextField .layer addSublayer:classLayer];
        
        [_classTextField becomeFirstResponder];
        
        if ([ _studentRegistartionnumberTextField.text isEqual:@""]) {
            _studentRegistartionnumberLbl.hidden = NO;
            _studentRegistartionnumberHeadingLbl.hidden= YES;
            
            studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
            studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
            
        }
        else
        {
            studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
            studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
            
            _studentRegistartionnumberHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _studentFullNameTextField.text isEqual:@""]) {
            _studentFullNameLbl.hidden = NO;
            _studentFullNameHeadingLbl.hidden= YES;
            
            studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
            studentFullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
        }
        else
        {
            studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
            studentFullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
            
            _studentFullNameHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        if ([ _amountTextField.text isEqual:@""]) {
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    if ( label.tag == 12 )
    {
        
        _clientLbl.hidden = YES;
        _clientHeadingLbl.hidden= NO;
        
        clientNameLayer.frame = CGRectMake(0.0f, self.clientTextField .frame.size.height - 1, self.clientTextField .frame.size.width, 1.0f);
        clientNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.clientTextField .layer addSublayer:clientNameLayer];
        
        [_clientTextField becomeFirstResponder];
        
        if ([ _equipmentIDTextField.text isEqual:@""]) {
            _equipmentLbl.hidden = NO;
            _equipmentIDHeadingLbl.hidden= YES;
            
            equipmentIdLayer = [CALayer layer];
            equipmentIdLayer.frame = CGRectMake(0.0f, self.equipmentIDTextField .frame.size.height - 1, self.equipmentIDTextField .frame.size.width, 1.0f);
            equipmentIdLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.equipmentIDTextField .layer addSublayer:equipmentIdLayer];
            
        }
        else
        {
            equipmentIdLayer = [CALayer layer];
            equipmentIdLayer.frame = CGRectMake(0.0f, self.equipmentIDTextField .frame.size.height - 1, self.equipmentIDTextField .frame.size.width, 1.0f);
            equipmentIdLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.equipmentIDTextField .layer addSublayer:equipmentIdLayer];
            
            _equipmentIDHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    if ( label.tag == 13 )
    {
        [self.view endEditing:YES];
        _equipmentLbl.hidden = YES;
        _equipmentIDHeadingLbl.hidden= NO;
        
        equipmentIdLayer = [CALayer layer];
        equipmentIdLayer.frame = CGRectMake(0.0f, self.equipmentIDTextField .frame.size.height - 1, self.equipmentIDTextField .frame.size.width, 1.0f);
        equipmentIdLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.equipmentIDTextField .layer addSublayer:equipmentIdLayer];
        
        [_equipmentIDTextField becomeFirstResponder];
        
        if ([ _clientTextField.text isEqual:@""]) {
            _clientLbl.hidden = NO;
            _clientHeadingLbl.hidden= YES;
            
            clientNameLayer.frame = CGRectMake(0.0f, self.clientTextField .frame.size.height - 1, self.clientTextField .frame.size.width, 1.0f);
            clientNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.clientTextField .layer addSublayer:clientNameLayer];
            
        }
        else
        {
            clientNameLayer.frame = CGRectMake(0.0f, self.clientTextField .frame.size.height - 1, self.clientTextField .frame.size.width, 1.0f);
            clientNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.clientTextField .layer addSublayer:clientNameLayer];
            
            _clientHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
}

#pragma mark ###########
#pragma mark - Text Fields Deletgate methods
#pragma mark ###########

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if ([ _amountTextField.text isEqual:@""]) {
        
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        [_amountTextField resignFirstResponder];
        
    }
    else
    {
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        
        _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
    }
    
    
    genderTableView.hidden = YES;
    
    NSLog(@"textfield y %f",textField.frame.origin.y + requiredInfoView.frame.origin.y);
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width,_scrollView.contentSize.height + 250)];
    
    if([textField.superview isEqual:requiredInfoView] )
    {
        if(textField.frame.origin.y + requiredInfoView.frame.origin.y > 600)
        {
            UIView *tempVW = [[ UIView alloc] init];
            
            tempVW.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y+600, textField.frame.size.width, textField.frame.size.height );
            [self scrollViewToCenterOfScreen:tempVW];
        }
        
    }
    
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    
    NSString *amountno = [self.amountTextField.text stringByTrimmingCharactersInSet:whitespace];
    NSString *meterName = [self.meterTextField.text stringByTrimmingCharactersInSet:whitespace];
    
    if (textField == _amountTextField)
    {
        UIView *tempVW = [[ UIView alloc] init];
        
        tempVW.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y+50, textField.frame.size.width, textField.frame.size.height );
        
        [self scrollViewToCenterOfScreen:tempVW];
        if ( !([ amountno isEqualToString:@"0.00"]|| [amountno isEqualToString:@""])) {
            
        }
        else
        {
            _amountTextField.userInteractionEnabled = true;
            _amountTextField.text = @"";
            
        }
        
        _amountHeadingLbl.textColor= [self colorWithHexString:@"51595c"];
        UIColor *color = [self colorWithHexString:@"51595c"];
        
        _amountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0.00" attributes:@{NSForegroundColorAttributeName: color}];
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        
        amountLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        if ([meterName length] != 0 ) {
            _meterHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            meterLayer.frame = CGRectMake(0.0f, self.meterTextField.frame.size.height - 1, self.meterTextField.frame.size.width, 1.0f);
            meterLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.meterTextField.layer addSublayer:meterLayer];
        }
        else
        {
            _meterHeadingLbl.hidden = YES;
            _MeterLbl.hidden = NO;
            meterLayer.frame = CGRectMake(0.0f, self.meterTextField.frame.size.height - 1, self.meterTextField.frame.size.width, 1.0f);
            meterLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.meterTextField.layer addSublayer:meterLayer];
        }
        if ([ _receiverPhnNoTextField.text isEqual:@""]) {
            _receiverPhnNoLbl.hidden = NO;
            _receiverPhnNoHeadingLbl.hidden= YES;
            
            receiverPhnNoLayer.frame = CGRectMake(0.0f, self.receiverPhnNoTextField.frame.size.height - 1, self.receiverPhnNoTextField.frame.size.width, 1.0f);
            receiverPhnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.receiverPhnNoTextField.layer addSublayer:receiverPhnNoLayer];
            
        }
        else
        {
            receiverPhnNoLayer.frame = CGRectMake(0.0f, self.receiverPhnNoTextField.frame.size.height - 1, self.receiverPhnNoTextField.frame.size.width, 1.0f);
            receiverPhnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.receiverPhnNoTextField.layer addSublayer:receiverPhnNoLayer];
            
            _receiverPhnNoHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _emailAddressTextField.text isEqual:@""]) {
            _emailAddressLbl.hidden = NO;
            _emailAddressHeadinglbl.hidden= YES;
            
            emailAddressLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            emailAddressLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.emailAddressTextField.layer addSublayer:emailAddressLayer];
            
        }
        else
        {
            emailAddressLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            emailAddressLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.emailAddressTextField.layer addSublayer:emailAddressLayer];
            
            _emailAddressHeadinglbl.textColor = [self colorWithHexString:@"51595c"];
        }
        if ([ _fullNameTextField.text isEqual:@""]) {
            _fullNameLbl.hidden = NO;
            _fullNameHeadingLbl.hidden= YES;
            
            fullNameLayer.frame = CGRectMake(0.0f, self.fullNameTextField.frame.size.height - 1, self.fullNameTextField.frame.size.width, 1.0f);
            fullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameTextField.layer addSublayer:fullNameLayer];
            [_fullNameTextField resignFirstResponder];
        }
        else
        {
            fullNameLayer.frame = CGRectMake(0.0f, self.fullNameTextField.frame.size.height - 1, self.fullNameTextField.frame.size.width, 1.0f);
            fullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameTextField.layer addSublayer:fullNameLayer];
            
            _fullNameHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
        
        if ([ _phnNoTextField.text isEqual:@""]) {
            _phnNoLbl.hidden = NO;
            _phnNoHeadingLbl.hidden= YES;
            phnNoLayer.frame = CGRectMake(0.0f, self.phnNoTextField.frame.size.height - 1, self.phnNoTextField.frame.size.width, 1.0f);
            phnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.phnNoTextField.layer addSublayer:phnNoLayer];
            [_phnNoTextField resignFirstResponder];
        }
        else
        {
            phnNoLayer.frame = CGRectMake(0.0f, self.phnNoTextField.frame.size.height - 1, self.phnNoTextField.frame.size.width, 1.0f);
            phnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.phnNoTextField.layer addSublayer:phnNoLayer];
            
            _phnNoHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
        if ([ _fullNameProTextField.text isEqual:@""]) {
            _fullNameProLbl.hidden = NO;
            _fullNameProHeadingLbl.hidden= YES;
            
            fullNameProLayer.frame = CGRectMake(0.0f, self.fullNameProTextField.frame.size.height - 1, self.fullNameProTextField.frame.size.width, 1.0f);
            fullNameProLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameProTextField.layer addSublayer:fullNameProLayer];
            [_fullNameProTextField resignFirstResponder];
        }
        else
        {
            fullNameProLayer.frame = CGRectMake(0.0f, self.fullNameProTextField.frame.size.height - 1, self.fullNameProTextField.frame.size.width, 1.0f);
            fullNameProLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameProTextField.layer addSublayer:fullNameProLayer];
            
            _fullNameProHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        if ([ _ageTextField.text isEqual:@""]) {
            _ageLbl.hidden = NO;
            _ageHeadingLbl.hidden= YES;
            
            ageTextLayer.frame = CGRectMake(0.0f, self.ageTextField.frame.size.height - 1, self.ageTextField.frame.size.width, 1.0f);
            ageTextLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.ageTextField.layer addSublayer:ageTextLayer];
            [_ageTextField resignFirstResponder];
        }
        else
        {
            ageTextLayer.frame = CGRectMake(0.0f, self.ageTextField.frame.size.height - 1, self.ageTextField.frame.size.width, 1.0f);
            ageTextLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.ageTextField.layer addSublayer:ageTextLayer];
            
            _ageHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    if (textField == _meterTextField)
    {
        _receiverPhnNoHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        meterLayer.frame = CGRectMake(0.0f, self.meterTextField.frame.size.height - 1, self.meterTextField.frame.size.width, 1.0f);
        meterLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.meterTextField.layer addSublayer:meterLayer];
        
        [_meterTextField becomeFirstResponder];
        
        if ([amountno length] != 0 ) {
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
        }
        if ([meterName length] != 0 ) {
            _meterHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if (textField == _receiverPhnNoTextField)
    {
        _receiverPhnNoHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        receiverPhnNoLayer.frame = CGRectMake(0.0f, self.receiverPhnNoTextField.frame.size.height - 1, self.receiverPhnNoTextField.frame.size.width, 1.0f);
        receiverPhnNoLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.receiverPhnNoTextField.layer addSublayer:receiverPhnNoLayer];
        [_receiverPhnNoTextField becomeFirstResponder];
        
        if ([amountno length] != 0 ) {
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
        }
        if ([meterName length] != 0 ) {
            _meterHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        if ([ _emailAddressTextField.text isEqual:@""]) {
            _emailAddressLbl.hidden = NO;
            _emailAddressHeadinglbl.hidden= YES;
            
            emailAddressLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            emailAddressLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.emailAddressTextField.layer addSublayer:emailAddressLayer];
            [_emailAddressTextField resignFirstResponder];
        }
        else
        {
            emailAddressLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
            emailAddressLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.emailAddressTextField.layer addSublayer:emailAddressLayer];
            
            _emailAddressHeadinglbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
    }
    
    if (textField == _emailAddressTextField)
    {
        _emailAddressHeadinglbl.textColor= [self colorWithHexString:@"158db6"];
        emailAddressLayer.frame = CGRectMake(0.0f, self.emailAddressTextField.frame.size.height - 1, self.emailAddressTextField.frame.size.width, 1.0f);
        emailAddressLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.emailAddressTextField.layer addSublayer:emailAddressLayer];
        
        if ([amountno length] != 0 ) {
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
        }
        if ([ _receiverPhnNoTextField.text isEqual:@""]) {
            _receiverPhnNoLbl.hidden = NO;
            _receiverPhnNoHeadingLbl.hidden= YES;
            receiverPhnNoLayer.frame = CGRectMake(0.0f, self.receiverPhnNoTextField.frame.size.height - 1, self.receiverPhnNoTextField.frame.size.width, 1.0f);
            receiverPhnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.receiverPhnNoTextField.layer addSublayer:receiverPhnNoLayer];
            [_receiverPhnNoTextField resignFirstResponder];
        }
        else
        {
            receiverPhnNoLayer.frame = CGRectMake(0.0f, self.receiverPhnNoTextField.frame.size.height - 1, self.receiverPhnNoTextField.frame.size.width, 1.0f);
            receiverPhnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.receiverPhnNoTextField.layer addSublayer:receiverPhnNoLayer];
            
            _receiverPhnNoHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if (textField == _fullNameTextField)
    {
        _fullNameHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        fullNameLayer.frame = CGRectMake(0.0f, self.fullNameTextField.frame.size.height - 1, self.fullNameTextField.frame.size.width, 1.0f);
        fullNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.fullNameTextField.layer addSublayer:fullNameLayer];
        
        [_fullNameTextField becomeFirstResponder];
        
        if ([amountno length] != 0 ) {
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
        }
        
        if ([ _phnNoTextField.text isEqual:@""]) {
            _phnNoLbl.hidden = NO;
            _phnNoHeadingLbl.hidden= YES;
            phnNoLayer.frame = CGRectMake(0.0f, self.phnNoTextField.frame.size.height - 1, self.phnNoTextField.frame.size.width, 1.0f);
            phnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.phnNoTextField.layer addSublayer:phnNoLayer];
            [_phnNoTextField resignFirstResponder];
        }
        else
        {
            phnNoLayer.frame = CGRectMake(0.0f, self.phnNoTextField.frame.size.height - 1, self.phnNoTextField.frame.size.width, 1.0f);
            phnNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.phnNoTextField.layer addSublayer:phnNoLayer];
            
            _phnNoHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
    }
    
    if (textField == _phnNoTextField)
    {
        _phnNoHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        phnNoLayer.frame = CGRectMake(0.0f, self.phnNoTextField.frame.size.height - 1, self.phnNoTextField.frame.size.width, 1.0f);
        phnNoLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.phnNoTextField.layer addSublayer:phnNoLayer];
        [_phnNoTextField becomeFirstResponder];
        
        
        if ([amountno length] != 0 ) {
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
        }
        if ([ _fullNameTextField.text isEqual:@""]) {
            _fullNameLbl.hidden = NO;
            _fullNameHeadingLbl.hidden= YES;
            
            fullNameLayer.frame = CGRectMake(0.0f, self.fullNameTextField.frame.size.height - 1, self.fullNameTextField.frame.size.width, 1.0f);
            fullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameTextField.layer addSublayer:fullNameLayer];
            [_fullNameTextField resignFirstResponder];
        }
        else
        {
            fullNameLayer.frame = CGRectMake(0.0f, self.fullNameTextField.frame.size.height - 1, self.fullNameTextField.frame.size.width, 1.0f);
            fullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameTextField.layer addSublayer:fullNameLayer];
            
            _fullNameHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
            
        }
        
    }
    
    if (textField == _fullNameProTextField)
    {
        _fullNameProHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        fullNameProLayer.frame = CGRectMake(0.0f, self.fullNameProTextField.frame.size.height - 1, self.fullNameProTextField.frame.size.width, 1.0f);
        fullNameProLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.fullNameProTextField.layer addSublayer:fullNameProLayer];
        
        if ([ _ageTextField.text isEqual:@""]) {
            _ageLbl.hidden = NO;
            _ageHeadingLbl.hidden= YES;
            
            ageTextLayer.frame = CGRectMake(0.0f, self.ageTextField.frame.size.height - 1, self.ageTextField.frame.size.width, 1.0f);
            ageTextLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.ageTextField.layer addSublayer:ageTextLayer];
            [_ageTextField resignFirstResponder];
        }
        else
        {
            ageTextLayer.frame = CGRectMake(0.0f, self.ageTextField.frame.size.height - 1, self.ageTextField.frame.size.width, 1.0f);
            ageTextLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.ageTextField.layer addSublayer:ageTextLayer];
            
            _ageHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            _amountLbl.hidden = NO;
            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
    }
    
    if (textField == _ageTextField)
    {
        _ageHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        ageTextLayer.frame = CGRectMake(0.0f, self.ageTextField.frame.size.height - 1, self.ageTextField.frame.size.width, 1.0f);
        ageTextLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.ageTextField.layer addSublayer:ageTextLayer];
        
        if ([ _fullNameProTextField.text isEqual:@""]) {
            _fullNameProLbl.hidden = NO;
            _fullNameProHeadingLbl.hidden= YES;
            
            fullNameProLayer.frame = CGRectMake(0.0f, self.fullNameProTextField.frame.size.height - 1, self.fullNameProTextField.frame.size.width, 1.0f);
            fullNameProLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameProTextField.layer addSublayer:fullNameProLayer];
            [_fullNameProTextField resignFirstResponder];
        }
        else
        {
            fullNameProLayer.frame = CGRectMake(0.0f, self.fullNameProTextField.frame.size.height - 1, self.fullNameProTextField.frame.size.width, 1.0f);
            fullNameProLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.fullNameProTextField.layer addSublayer:fullNameProLayer];
            
            _fullNameProHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        if ([ _amountTextField.text isEqual:@""]) {
            _amountLbl.hidden = NO;
            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if (textField == _studentRegistartionnumberTextField)
    {
        _studentRegistartionnumberHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
        studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
        
        [_studentRegistartionnumberTextField becomeFirstResponder];
        
        
        if ([ _studentFullNameTextField.text isEqual:@""]) {
            _studentFullNameLbl.hidden = NO;
            _studentFullNameHeadingLbl.hidden= YES;
            
            studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
            studentFullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
        }
        else
        {
            studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
            studentFullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
            
            _studentRegistartionnumberHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _classTextField.text isEqual:@""]) {
            _classLbl.hidden = NO;
            _classHeadingLbl.hidden= YES;
            
            classLayer.frame = CGRectMake(0.0f, self.classTextField.frame.size.height - 1, self.classTextField.frame.size.width, 1.0f);
            classLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:classLayer];
            
        }
        else
        {
            classLayer.frame = CGRectMake(0.0f, self.classTextField.frame.size.height - 1, self.classTextField.frame.size.width, 1.0f);
            classLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:classLayer];
            
            _classHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if (textField == _studentFullNameTextField)
    {
        _studentFullNameHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        
        studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
        studentFullNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
        
        [_studentFullNameTextField becomeFirstResponder];
        
        
        if ([ _studentRegistartionnumberTextField.text isEqual:@""]) {
            _studentRegistartionnumberLbl.hidden = NO;
            _studentRegistartionnumberHeadingLbl.hidden= YES;
            
            studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
            studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
            
        }
        else
        {
            studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
            studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
            
            _studentRegistartionnumberHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _classTextField.text isEqual:@""]) {
            _classLbl.hidden = NO;
            _classHeadingLbl.hidden= YES;
            
            classLayer.frame = CGRectMake(0.0f, self.classTextField.frame.size.height - 1, self.classTextField.frame.size.width, 1.0f);
            classLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:classLayer];
            
        }
        else
        {
            classLayer.frame = CGRectMake(0.0f, self.classTextField.frame.size.height - 1, self.classTextField.frame.size.width, 1.0f);
            classLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:classLayer];
            
            _classHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if (textField == _classTextField)
    {
        _classHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        
        classLayer.frame = CGRectMake(0.0f, self.classTextField .frame.size.height - 1, self.classTextField .frame.size.width, 1.0f);
        classLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.classTextField .layer addSublayer:classLayer];
        
        [_classTextField becomeFirstResponder];
        
        if ([ _studentRegistartionnumberTextField.text isEqual:@""]) {
            _studentRegistartionnumberLbl.hidden = NO;
            _studentRegistartionnumberHeadingLbl.hidden= YES;
            
            studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
            studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
            
        }
        else
        {
            studentRegistrationNoLayer.frame = CGRectMake(0.0f, self.studentRegistartionnumberTextField .frame.size.height - 1, self.studentRegistartionnumberTextField .frame.size.width, 1.0f);
            studentRegistrationNoLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentRegistartionnumberTextField .layer addSublayer:studentRegistrationNoLayer];
            
            _studentRegistartionnumberHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _studentFullNameTextField.text isEqual:@""]) {
            _studentFullNameLbl.hidden = NO;
            _studentFullNameHeadingLbl.hidden= YES;
            
            studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
            studentFullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
        }
        else
        {
            studentFullNameLayer.frame = CGRectMake(0.0f, self.studentFullNameTextField .frame.size.height - 1, self.studentFullNameTextField .frame.size.width, 1.0f);
            studentFullNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.studentFullNameTextField .layer addSublayer:studentFullNameLayer];
            
            _studentFullNameHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        if ([ _amountTextField.text isEqual:@""]) {
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    
    if (textField == _clientTextField)
    {
        _clientHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        
        clientNameLayer.frame = CGRectMake(0.0f, self.clientTextField .frame.size.height - 1, self.clientTextField .frame.size.width, 1.0f);
        clientNameLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.clientTextField .layer addSublayer:clientNameLayer];
        
        [_clientTextField becomeFirstResponder];
        
        if ([ _equipmentIDTextField.text isEqual:@""]) {
            _equipmentLbl.hidden = NO;
            _equipmentIDHeadingLbl.hidden= YES;
            
            equipmentIdLayer = [CALayer layer];
            equipmentIdLayer.frame = CGRectMake(0.0f, self.equipmentIDTextField .frame.size.height - 1, self.equipmentIDTextField .frame.size.width, 1.0f);
            equipmentIdLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.equipmentIDTextField .layer addSublayer:equipmentIdLayer];
            
        }
        else
        {
            equipmentIdLayer = [CALayer layer];
            equipmentIdLayer.frame = CGRectMake(0.0f, self.equipmentIDTextField .frame.size.height - 1, self.equipmentIDTextField .frame.size.width, 1.0f);
            equipmentIdLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.equipmentIDTextField .layer addSublayer:equipmentIdLayer];
            
            _equipmentIDHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            //            _amountLbl.hidden = NO;
            //            _amountHeadingLbl.hidden= YES;
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    if (textField == _equipmentIDTextField)
    {
        _equipmentIDHeadingLbl.textColor= [self colorWithHexString:@"158db6"];
        
        equipmentIdLayer = [CALayer layer];
        equipmentIdLayer.frame = CGRectMake(0.0f, self.equipmentIDTextField .frame.size.height - 1, self.equipmentIDTextField .frame.size.width, 1.0f);
        equipmentIdLayer.backgroundColor = [self colorWithHexString:@"3ec6f0"].CGColor;
        [self.equipmentIDTextField .layer addSublayer:equipmentIdLayer];
        
        [_equipmentIDTextField becomeFirstResponder];
        
        if ([ _clientTextField.text isEqual:@""]) {
            _clientLbl.hidden = NO;
            _clientHeadingLbl.hidden= YES;
            
            clientNameLayer.frame = CGRectMake(0.0f, self.clientTextField .frame.size.height - 1, self.clientTextField .frame.size.width, 1.0f);
            clientNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.clientTextField .layer addSublayer:clientNameLayer];
            
        }
        else
        {
            clientNameLayer.frame = CGRectMake(0.0f, self.clientTextField .frame.size.height - 1, self.clientTextField .frame.size.width, 1.0f);
            clientNameLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.clientTextField .layer addSublayer:clientNameLayer];
            
            _clientHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
        
        if ([ _amountTextField.text isEqual:@""]) {
            
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            [_amountTextField resignFirstResponder];
            
        }
        else
        {
            amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
            amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
            [self.amountTextField.layer addSublayer:amountLayer];
            
            _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
        }
    }
    if (textField == _amountTextField)
    {
        [self scrollViewToCenterOfScreen:_amountTextField];
    }
    else if (textField == _meterTextField)
    {
        [self scrollViewToCenterOfScreen:_meterTextField];
    }
    else if (textField == _receiverPhnNoTextField)
    {
        [self scrollViewToCenterOfScreen:_receiverPhnNoTextField];
    }
    else if (textField == _emailAddressTextField)
    {
        [self scrollViewToCenterOfScreen:_emailAddressTextField];
    }
    else if (textField == _fullNameTextField)
    {
        [self scrollViewToCenterOfScreen:_fullNameTextField];
    }
    else if (textField == _phnNoTextField)
    {
        [self scrollViewToCenterOfScreen:_phnNoTextField];
    }
    else if (textField == _fullNameProTextField)
    {
        [self scrollViewToCenterOfScreen:_fullNameProTextField];
    }
    else if (textField == _ageTextField )
    {
        [self scrollViewToCenterOfScreen:_ageTextField];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if ([ _amountTextField.text isEqual:@""]) {
        
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        [_amountTextField resignFirstResponder];
        
    }
    else
    {
        amountLayer.frame = CGRectMake(0.0f, self.amountTextField.frame.size.height - 1, self.amountTextField.frame.size.width, 1.0f);
        amountLayer.backgroundColor = [self colorWithHexString:@"51595c"].CGColor;
        [self.amountTextField.layer addSublayer:amountLayer];
        
        _amountHeadingLbl.textColor = [self colorWithHexString:@"51595c"];
    }
    
    
    float sizeOfContent = 0;
    NSInteger wd = requiredInfoView.frame.origin.y;
    NSInteger ht = requiredInfoView.frame.size.height;
    
    sizeOfContent = wd+ht;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, sizeOfContent);
    
    if (textField == _amountTextField) {
        
        if ([_amountTextField.text isEqualToString:@""]) {
            _amountTextField.text = @"0.00";
        }
    }
    return YES;
}

#pragma mark ########
#pragma mark Scroll View Delegate
#pragma mark ########

-(void)scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 350; // Remove area covered by keyboard
    
    CGFloat y = viewCenterY - availableHeight ;
    if (y < 0) {
        y = 0;
    }
    [_scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

#pragma mark ########
#pragma mark Segue Delegate
#pragma mark ########

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSLog(@"segue to Beneficiary screen");
//    if([[segue identifier] isEqualToString:@"confirmpayment"]){
//
//        IPadConfirmPaymentViewController*vc = [segue destinationViewController];
//        vc.paymentData = PaymentUserData;
//        vc.paymentUserData = requiredFldArray;
//        vc.DataArray = DataArray;
//        vc.descriptionBillLbl = _billNameLbl.text;
//        vc.billCategoryId = [_billUserData valueForKeyPath:@"BillCategory.id"];
//    }
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    
    if(touch.view ==_billOptionTableView){
        _billOptionTableView.hidden = NO;
    }
    else
    {
        _billOptionTableView.hidden = YES;
    }
    
    if(touch.view ==genderTableView){
        genderTableView.hidden = NO;
    }
    else
    {
        genderTableView.hidden = YES;
    }
}
#pragma mark ########
#pragma mark Color HexString methods
#pragma mark ########

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
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
