//
//  AppDelegate.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "AppDelegate.h"
#import <Stripe/Stripe.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController, iPadViewController=_iPadViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     [NSThread sleepForTimeInterval:3.0];
    // Override point for customization after application launch.
    
    //new
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    NSLog(@"country   .   %@",language);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:language forKey:@"lang_locale"];
    if ([language  isEqual: @"fr"]) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ar"];
        NSString *l1 = [locale displayNameForKey:NSLocaleIdentifier value:@"ar"];
        NSLog(@"%@", l1);
    }
    else
    {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        NSString *l2 = [locale displayNameForKey:NSLocaleIdentifier value:@"en"];
        NSLog(@"%@", l2);
        
    }
    //
    [self loadStoryboards];
    [Stripe setDefaultPublishableKey:@"pk_test_MJD7VPvX8eEsgr7F2dapMGjl"];
    [[ NSUserDefaults standardUserDefaults]removeObjectForKey:@"timeStamp"];
    return YES;
}

- (void)loadStoryboards
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.viewController = [mainStoryboard instantiateInitialViewController];
        self.window.rootViewController =  self.viewController;
    } else {
        
        mainStoryboard = [UIStoryboard storyboardWithName:@"iPadMain" bundle:nil];
        self.iPadViewController = [mainStoryboard instantiateInitialViewController];
        self.window.rootViewController =  self.iPadViewController;
    }
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"MakeContactCall"] isEqualToString:@"YES"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"MakeContactCall"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeShade" object:self];
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if ([[ NSUserDefaults standardUserDefaults] boolForKey:@"CallDuphluxAuth"] == YES)
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DuphluxAuthStatus" object:nil userInfo:nil];
//    }
//    [[ NSUserDefaults standardUserDefaults] setBool:nil forKey:@"CallDuphluxAuth"];

}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark ----------------
#pragma mark SAVE THE USERS IAMGES IN THE DIRECTORY FOLDER

- (NSString *) getImagePathbyflagName: (NSString *) userName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirPath = [paths objectAtIndex:0];
    NSString *profileImageFolderPath = [dirPath stringByAppendingPathComponent:@"SearchResultUsers"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    NSError *error;
    NSString *filePath = @"";
    [fileM createDirectoryAtPath:profileImageFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
    NSArray *images = [fileM contentsOfDirectoryAtPath:profileImageFolderPath error:nil];
    
    for(NSString *str in images){
        if ([str isEqualToString:userName]) {
            filePath = [profileImageFolderPath stringByAppendingPathComponent:str];
        }
    }
    
    
    return filePath;
}

-(void)saveflagsImageToFolder:(UIImage *)pImg imageName:(NSString *)name{
    
    BOOL imageExists = [self checkIfImageExist:name];
    
    if(imageExists){
        ;
    }
    else{
        
        [self saveflagImage:pImg name:name];
    }
}

-(void)saveflagImage:(UIImage *)image name:(NSString *)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirPath = [paths objectAtIndex:0];
    NSString *profileImageFolderPath = [dirPath stringByAppendingPathComponent:@"SearchResultUsers"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    NSError *error;
    [fileM createDirectoryAtPath:profileImageFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *profileImagePath;
    profileImagePath = [profileImageFolderPath stringByAppendingPathComponent:imageName];
    [imageData writeToFile:profileImagePath atomically:YES];
}

- (BOOL)checkIfImageExist :(NSString *)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirPath = [paths objectAtIndex:0];
    NSString *profileImageFolderPath = [dirPath stringByAppendingPathComponent:@"SearchResultUsers"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    NSError *error;
    [fileM createDirectoryAtPath:profileImageFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
    NSArray *images = [fileM contentsOfDirectoryAtPath:profileImageFolderPath error:nil];
    
    if([images containsObject:imageName]){
        return YES;
    }
    return NO;
}

-(void)showLoader
{
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    activityIndicatorView1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    label = [[UILabel alloc]initWithFrame:CGRectMake((window.frame.size.width/2)-30 ,(window.frame.size.height/2)+30,120.0f, 50.0f)];
    label.text= @"Loading...";
    label.font = [UIFont fontWithName:@"Helvetica-Regular" size:10.0];
    label.textColor = [UIColor whiteColor];
    
    
    activityIndicatorView1.frame = CGRectMake((window.frame.size.width/2)-25 ,(window.frame.size.height/2) -10,50.0f, 50.0f);
    
    blurView = [[UIView alloc] initWithFrame:window.frame];
    
    blurView.backgroundColor = [UIColor blackColor];
    
    blurView.alpha = 0.8;
    
    activityIndicatorView1.alpha = 1.0;
    
    [window addSubview:blurView];
    
    [blurView addSubview:activityIndicatorView1];
    [blurView addSubview:label];
    [activityIndicatorView1 startAnimating];
}

-(void)HideLoader
{
    //    [hud hide:YES];
    //    [spinner stopAnimating];
    //    [SVProgressHUD dismiss];
    //    return;
    //    [self.backgroundview2 removeFromSuperview];
    //    [self.backgroundview removeFromSuperview];
    //    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [activityIndicatorView1 stopAnimating];
    activityIndicatorView1 .hidden = YES;
    blurView.hidden = YES;
    [blurView removeFromSuperview];
    [activityIndicatorView1 removeFromSuperview];
}

@end
