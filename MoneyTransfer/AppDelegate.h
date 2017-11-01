//
//  AppDelegate.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "iPadLoginViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIView * blurView;
    UILabel *label;
    UIActivityIndicatorView * activityIndicatorView1;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *viewController;
@property (strong, nonatomic) iPadLoginViewController *iPadViewController;

- (NSString *) getImagePathbyflagName: (NSString *) userName;
-(void)saveflagsImageToFolder:(UIImage *)pImg imageName:(NSString *)name;

-(void)saveflagImage:(UIImage *)image name:(NSString *)imageName;

- (BOOL)checkIfImageExist :(NSString *)imageName;
-(void)showLoader;
-(void)HideLoader;
@end

