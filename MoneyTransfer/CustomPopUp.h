//
//  CustomPopUp.
//  Created by on 20/08/14.
//  Copyright (c) 2014 Ami Modi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPopUpDelegate;

@interface CustomPopUp : UIViewController
{
    NSTimer *timer, *timer2;
    int counter;
//    IBOutlet UIImageView *bgImage;
}

@property(nonatomic) int tag;
@property (assign, nonatomic) IBOutlet UIButton *OkBtn;
@property (assign, nonatomic) IBOutlet NSString *OkBtnTitle;
@property (assign, nonatomic) IBOutlet UILabel *popUpMsgLbl;
@property (assign, nonatomic) NSString *popUpMsg;
@property (assign, nonatomic) NSString *callFrom;
@property (assign, nonatomic) NSString *callTo;
@property (assign, nonatomic) NSString *popUpTitle;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UIView *touchView;
@property (strong, nonatomic) IBOutlet UILabel *callFromLbl;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *timelbl;
@property (weak, nonatomic) IBOutlet UIView *verifyView;

@property (assign, nonatomic) id <CustomPopUpDelegate>delegate;

- (IBAction)okBtnClicked:(id)sender;
- (IBAction)ActionCrossBtn:(id)sender;

@end

@protocol CustomPopUpDelegate<NSObject>

@optional

- (void)popUpDelegateOkBtnClicked:(CustomPopUp *)obj;

@end
