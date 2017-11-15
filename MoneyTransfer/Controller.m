 //
//  Controller.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 10/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "Controller.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "ReachabiltyTest.h"
#import "SendMoneyViewController.h"
#import "AddCardViewController.h"

@implementation Controller

+ (BOOL) errorsFoundOnJSON:(id)JSON
{
    return NO;
}

+ (NSString *) checkUserOfflineWithSuccess
{
    ReachabiltyTest *reachabilty = [[ReachabiltyTest alloc]init];
    int i = [reachabilty updateInterfaceWithReachability];
    if (i == 0)
    {
        NSString *alertMessage =@"You appear to be offline. Please check your net connection and retry.";
        return alertMessage;
    }
    else
    {
        NSString *alertMessage =nil;
        return alertMessage;
    }
}

+ (NSString *)URLEncodeStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}


#pragma mark User Login method
+ (void) loginByUserEmail:(NSString *)email Password:(NSString *)password withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:email forKey:@"email_address"];
    [dict setValue:password forKey:@"password"];
    
    
    NSMutableURLRequest *req = [client requestWithMethod:@"POST" path:Login parameters:dict];
    NSLog(@"Dictionary %@", dict);
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        success(responseObject);
        
        NSDictionary *Profile = [[ NSDictionary alloc] initWithDictionary:[responseObject valueForKey:@"data"]];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:[NSKeyedArchiver archivedDataWithRootObject:Profile] forKey:@"Userlogindata"];
        [def setValue:@"User" forKey:@"loginSuccessed"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        if ([operation.response statusCode] == 200)
        {
            NSString *result;
           result = operation.responseString;
            
            failure(result);
        }
        else
        {
        if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
        {
            NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
            
            NSError *error;
            NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers error:&error];
            
            NSString *message = [ json valueForKey:@"message"];
            
            failure(message);
        }
        else
        {
            failure(@"Please try after some time, as the server is not responding.");
        }
    }
    }];
    [reqOp start];
}

+(void) authPhone :(NSDictionary *)Mobile  withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
{
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://duphlux.com/webservice/authe/verify.json"]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:@"34792cda48f4f90736d3faed467503568b347ee0"];
    
    
    NSMutableURLRequest *req = [client requestWithMethod:@"POST" path:@"" parameters:Mobile];
    NSLog(@"Dictionary %@", Mobile);
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
        {
            NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
            
            NSError *error;
            NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers error:&error];
            NSString *message = [ json valueForKey:@"message"];
            
            failure(message);
        }
        else
        {
            failure(@"Please try after some time, as the server is not responding.");
        }
    }];
    
    [reqOp start];
}
+(void) addBiller :(NSDictionary *)billerDic  withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
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
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSString *apiURl = [NSString stringWithFormat:@"%@",RecommendBiller];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"POST" path:apiURl parameters:billerDic];
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];
    
}

#pragma mark User Register method
+(void) createAccountWithName :(NSString *)firstName SurName:(NSString *)surname EmailAddress:(NSString *)emailAddress PhoneNumber:(NSString *)phoneNumber address:(NSString*)address CountryID:(NSString *)countryID Password:(NSString*)password ReferralCode:(NSString*)referralCode withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:firstName forKey:@"first_name"];
    [dict setValue:@"middle" forKey:@"middle_name"];
    
    [dict setValue:surname forKey:@"last_name"];
    [dict setValue:emailAddress forKey:@"email_address"];
    [dict setValue:phoneNumber forKey:@"phone_number"];
//    [dict setValue:address forKey:@"address"];
    [dict setValue:countryID forKey:@"country_currency_id"];
    [dict setValue:password forKey:@"password"];
    [dict setValue:referralCode forKey:@"referral_code"];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"POST" path:SignUp parameters:dict];
    NSLog(@"Dictionary %@", dict);
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
        {
            NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
            
            NSError *error;
            NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers error:&error];
            NSString *message = [ json valueForKey:@"message"];
            
            failure(message);
        }
        else
        {
            failure(@"Please try after some time, as the server is not responding.");
        }
    }];
    
    [reqOp start];
    
}

+ (void) forgotPassord :(NSString *)email  withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
{
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:email forKey:@"email_address"];
    
    
    NSMutableURLRequest *req = [client requestWithMethod:@"POST" path:ForgotPassword parameters:dict];
    NSLog(@"Dictionary %@", dict);
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        success(responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
        {
            NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
            
            NSError *error;
            NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers error:&error];
            
            NSString *message = [ json valueForKey:@"message"];
            
            failure(message);
        }
        else
        {
            failure(@"Please try after some time, as the server is not responding.");
        }
    }];
    
    [reqOp start];
    
}

+ (void) addCommercialWithToken :(NSString *)commercialToken sendMoney :(NSString *)beneficiarySendmoney getMoney:(NSString *)beneficiaryGetMoney  withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
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
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:beneficiarySendmoney forKey:@"beneficiary_Sendmoney"];
    [dict setValue:beneficiaryGetMoney forKey:@"beneficiary_GetMoney"];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"POST" path:GetCommericials parameters:dict];
    NSLog(@"Dictionary %@", dict);
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];
    
}

#pragma mark Get All Receiving Currency method
+ (void) getAllReceivingCurrencyWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:ListofReceivingCurrency parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        
        if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
        {
            NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
            
            NSError *error;
            NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers error:&error];
            
            NSString *message = [ json valueForKey:@"message"];
            
            failure(message);
        }
        else
        {
            failure(@"Please try after some time, as the server is not responding.");
        }
    }];
    
    [reqOp start];
}

#pragma mark Get All Sending Currency method
+ (void) getAllSendingCurrencyWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
{
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:ListofSendingCurrency parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
        {
            NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
            
            NSError *error;
            NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers error:&error];
            
            NSString *message = [ json valueForKey:@"message"];
            
            failure(message);
        }
        else
        {
            failure(@"Please try after some time, as the server is not responding.");
        }
    }];
    
    [reqOp start];
}

#pragma mark Get Bills  Method With Country Currency ID
+ (void) getBillsWithCategoryID:(NSString *)categoryID CurrencyID:(NSString *)currencyID WithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
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

    // Encrypt the currencyID  using public data and iv data
    NSData *EncodedData1 = [FBEncryptorAES encryptData:[currencyID dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64currencyIDString = [EncodedData1 base64EncodedStringWithOptions:0];
    base64currencyIDString = [ self URLEncodeStringFromString:base64currencyIDString];
    
//     Encrypt the currencyIDKey using public data and iv data
    NSData *EncodedkeyData1 = [FBEncryptorAES encryptData:[@"currency_id" dataUsingEncoding:NSUTF8StringEncoding]
                                                     key:decodedKeyData
                                                      iv:decodedIVData];

    NSString *base64currencyIDKeyString = [EncodedkeyData1 base64EncodedStringWithOptions:0];
    base64currencyIDKeyString = [ self URLEncodeStringFromString:base64currencyIDKeyString];

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];

    NSString *apiURl = [NSString stringWithFormat:@"%@%@=%@",ListBills,@"currency_id",currencyID];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:apiURl parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];

}

#pragma mark Get Bills method
+ (void) getBillsWithCategoryID:(NSString *)categoryID WithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
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
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSString *apiURl = [NSString stringWithFormat:@"%@%@",ListBills, categoryID];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:apiURl parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];
}

#pragma mark Get BillsCategories method

+ (void) getBillsCategoriesWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
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

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];

    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:ListBillsCategories parameters:nil];

    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];

    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"Succeeded with object %@", responseObject);
    NSLog(@"Request was %@", operation);
    
    success(responseObject);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"Failed with error %@", operation.responseString);
    NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
    
    if ([operation.response statusCode] == 200)
    {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
        
        NSString * result;
        NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
        if (data1)
        {
            result= [[NSString alloc] initWithData:data1
                                          encoding:NSUTF8StringEncoding];
        } else
        {
            result = operation.responseString;
        }
        failure(result);
    }
    else
    {
        if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
        {
            NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
            
            NSError *error;
            NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers error:&error];
            
            NSString *message = [ json valueForKey:@"message"];
            
            failure(message);
        }
        else
        {
            failure(@"Please try after some time, as the server is not responding.");
        }
    }
    
}];

[reqOp start];
}


#pragma mark Get User Profile method
+ (void) GetUserProfileWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
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
    
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:UserProfile parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];

}


#pragma mark Get Billers list method

+ (void) GetBillersListWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
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
    
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:BillersList parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];

    
}
#pragma mark Get Settlement Channellist method
+ (void) GetSettlementChannelListByUCountryID:(NSString *)countryID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
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
    
    // Encrypt the user token using public data and iv data
    NSData *EncodedData = [FBEncryptorAES encryptData:[countryID dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];

    NSString *base64CountryIDString = [EncodedData base64EncodedStringWithOptions:0];
    base64CountryIDString = [ self URLEncodeStringFromString:base64CountryIDString];

    NSData *EncodedkeyData = [FBEncryptorAES encryptData:[@"currency_id" dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64CountryKeyString = [EncodedkeyData base64EncodedStringWithOptions:0];
    base64CountryKeyString = [ self URLEncodeStringFromString:base64CountryKeyString];

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSString* apiURl = [ NSString stringWithFormat:@"%@%@=%@", Listsettlementchannel, base64CountryKeyString,base64CountryIDString];

    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:apiURl parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];
}

#pragma mark Get Beneficiaries List list method
+ (void) GetBeneficiariesListWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
{
    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
    
    userDataDict = [ userDataDict valueForKey:@"User"];
    
    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
    
    // Decode KeyString form base64
    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
    
    // Decode IvString form base64
    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
    
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:BeneficiaryList parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
               
                
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];
}


#pragma mark Get Recent Transfer list method
+ (void) getRecentTransactionsWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
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
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:ListofTransfers parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];
}

#pragma mark Get Recent Bill Payment list method

+ (void) getRecentBillPaymentWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
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
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:ListBillPayments parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Failed with error %@", operation.responseString);
        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
        
        if ([operation.response statusCode] == 200)
        {
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
            
            NSString * result;
            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
            if (data1)
            {
                result= [[NSString alloc] initWithData:data1
                                              encoding:NSUTF8StringEncoding];
            } else
            {
                result = operation.responseString;
            }
            failure(result);
        }
        else
        {
            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
            {
                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                
                NSError *error;
                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:NSJSONReadingMutableContainers error:&error];
                
                NSString *message = [ json valueForKey:@"message"];
                
                failure(message);
            }
            else
            {
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        
    }];
    
    [reqOp start];
}


//#pragma AddCard Method
//+(void) AddCardWithBrand :(NSString *)brandName Country:(NSString *)countryName Last4:(NSString *) last4 Stripe_token:(NSString *)stripe_token withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
//{
//    NSDictionary *userDataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUserData"]];
//    userDataDict = [userDataDict valueForKeyPath:@"User"];
//
//    NSString *userTokenString= [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"token"]];
//
//    // Decode KeyString form base64
//    NSString *base64KeyString =[ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"public_key"]];
//    NSData *decodedKeyData = [[NSData alloc] initWithBase64EncodedString:base64KeyString options:0];
//
//    // Decode IvString form base64
//    NSString *base64IVString = [ NSString stringWithFormat:@"%@",[[ userDataDict valueForKey:@"api_access_token"] valueForKey:@"iv"]];
//    NSData *decodedIVData = [[NSData alloc] initWithBase64EncodedString:base64IVString options:0];
//
//    // Encrpty the values and keys
//
//    NSString *EncryptTokenKey = [[FBEncryptorAES encryptData:[@"stripe_token" dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
//    EncryptTokenKey = [ self URLEncodeStringFromString:EncryptTokenKey];
//
//    NSString *EncryptTokenValue = [[FBEncryptorAES encryptData:[stripe_token dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
//    EncryptTokenValue = [ self URLEncodeStringFromString:EncryptTokenValue];
//
//    NSString *EncryptCardTypeKey = [[FBEncryptorAES encryptData:[@"brand" dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
//    EncryptCardTypeKey = [ self URLEncodeStringFromString:EncryptCardTypeKey];
//
//    NSString *EncryptCardTypeValue = [[FBEncryptorAES encryptData:[brandName dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
//    EncryptCardTypeValue = [ self URLEncodeStringFromString:EncryptCardTypeValue];
//
//    NSString *EncryptCountryKey = [[FBEncryptorAES encryptData:[@"payment_type" dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
//    EncryptCountryKey = [ self URLEncodeStringFromString:EncryptCountryKey];
//
//    NSString *EncryptCountryValue = [[FBEncryptorAES encryptData:[@"CARD" dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
//
//    EncryptCountryValue = [ self URLEncodeStringFromString:EncryptCountryValue];
//
//    NSString *EncryptCardLastKey = [[FBEncryptorAES encryptData:[@"alias" dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
//    EncryptCardLastKey = [ self URLEncodeStringFromString:EncryptCardLastKey];
//
//    NSString *EncryptCardLastValue = [[FBEncryptorAES encryptData:[@"My CARD" dataUsingEncoding:NSUTF8StringEncoding] key:decodedKeyData iv:decodedIVData] base64EncodedStringWithOptions:0];
//    EncryptCardLastValue = [ self URLEncodeStringFromString:EncryptCardLastValue];
//
//    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
//    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    [client setDefaultHeader:@"Accept" value:@"application/json"];
//    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
//    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
//    [client setDefaultHeader:@"token" value:userTokenString];
//
//    NSString *apiURl = [NSString stringWithFormat:@"%@%@=%@&%@=%@%@=%@%@=%@", AddCard, EncryptTokenKey, EncryptTokenValue, EncryptCardTypeKey,EncryptCardTypeValue, EncryptCountryKey, EncryptCountryValue, EncryptCardLastKey, EncryptCardLastValue];
//
//    NSMutableURLRequest *req = [client requestWithMethod:@"POST" path:apiURl parameters:nil];
//
//    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
//
//    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSLog(@"Succeeded with object %@", responseObject);
//        NSLog(@"Request was %@", operation);
//
//        success(responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        NSLog(@"Failed with error %@", operation.responseString);
//        NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
//
//        if ([operation.response statusCode] == 200)
//        {
//            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
//
//            NSString * result;
//            NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
//            if (data1)
//            {
//                result= [[NSString alloc] initWithData:data1
//                                              encoding:NSUTF8StringEncoding];
//            } else
//            {
//                result = operation.responseString;
//            }
//            failure(result);
//        }
//        else
//        {
//            if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
//            {
//                NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
//
//                NSError *error;
//                NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
//                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                                     options:NSJSONReadingMutableContainers error:&error];
//
//                NSString *message = [ json valueForKey:@"message"];
//
//                failure(message);
//            }
//            else
//            {
//                failure(@"Please try after some time, as the server is not responding.");
//            }
//        }
//
//    }];
//
//    [reqOp start];
//
//}


#pragma mark Get Bill States list method
+ (void) GetBillStatesListByCountryID:(NSString *)countryID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
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
    
    NSData *EncodedData = [FBEncryptorAES encryptData:[countryID dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64CountryIDString = [EncodedData base64EncodedStringWithOptions:0];
    base64CountryIDString = [ self URLEncodeStringFromString:base64CountryIDString];
    
    NSData *EncodedkeyData = [FBEncryptorAES encryptData:[@"currency_id" dataUsingEncoding:NSUTF8StringEncoding]
                                                     key:decodedKeyData
                                                      iv:decodedIVData];
    
    NSString *base64CountryKeyString = [EncodedkeyData base64EncodedStringWithOptions:0];
    base64CountryKeyString = [ self URLEncodeStringFromString:base64CountryKeyString];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSString* apiURl = [ NSString stringWithFormat:@"%@?%@=%@",ListBillStates, base64CountryKeyString,base64CountryIDString];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:apiURl parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failed with error %@", operation.responseString);
         NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
         
         if ([operation.response statusCode] == 200)
         {
             NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
             
             NSString * result;
             NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
             if (data1)
             {
                 result= [[NSString alloc] initWithData:data1
                                               encoding:NSUTF8StringEncoding];
             } else
             {
                 result = operation.responseString;
             }
             failure(result);
         }
         else
         {
             if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
             {
                 NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                 
                 NSError *error;
                 NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:NSJSONReadingMutableContainers error:&error];
                 
                 NSString *message = [ json valueForKey:@"message"];
                 
                 failure(message);
             }
             else
             {
                 failure(@"Please try after some time, as the server is not responding.");
             }
         }
         
     }];
    
    [reqOp start];
}




+(void) userLogoutWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
{
    
}

// POST Recommend Biller

+ (void) postRecommendBillerWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;
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

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSString* apiURl = [ NSString stringWithFormat:@"%@", RecommendBiller];

    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:apiURl parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failed with error %@", operation.responseString);
         NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
         
         if ([operation.response statusCode] == 200)
         {
             NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
             
             NSString * result;
             NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
             if (data1)
             {
                 result= [[NSString alloc] initWithData:data1
                                               encoding:NSUTF8StringEncoding];
             } else
             {
                 result = operation.responseString;
             }
             failure(result);
         }
         else
         {
             if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
             {
                 NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                 
                 NSError *error;
                 NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:NSJSONReadingMutableContainers error:&error];
                 
                 NSString *message = [ json valueForKey:@"message"];
                 
                 failure(message);
             }
             else
             {
                 failure(@"Please try after some time, as the server is not responding.");
             }
         }
         
     }];
    
    [reqOp start];
}

#pragma mark Get Biller list method
+ (void) GetBillerListByCountryID:(NSString *)countryID categoryID: (NSString *)categoryID stateID: (NSString *)stateID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
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
    
    NSData *EncodedData = [FBEncryptorAES encryptData:[countryID dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64CountryIDString = [EncodedData base64EncodedStringWithOptions:0];
    base64CountryIDString = [ self URLEncodeStringFromString:base64CountryIDString];
    
    NSData *EncodedkeyData = [FBEncryptorAES encryptData:[@"currency_id" dataUsingEncoding:NSUTF8StringEncoding]
                                                     key:decodedKeyData
                                                      iv:decodedIVData];
    
    NSString *base64CountryKeyString = [EncodedkeyData base64EncodedStringWithOptions:0];
    base64CountryKeyString = [ self URLEncodeStringFromString:base64CountryKeyString];
    
    NSData *EncodedData2 = [FBEncryptorAES encryptData:[stateID dataUsingEncoding:NSUTF8StringEncoding]
                                                   key:decodedKeyData
                                                    iv:decodedIVData];
    
    NSString *base64CountryIDString2 = [EncodedData2 base64EncodedStringWithOptions:0];
    base64CountryIDString2 = [ self URLEncodeStringFromString:base64CountryIDString2];
    
    NSData *EncodedkeyData2 = [FBEncryptorAES encryptData:[@"state_id" dataUsingEncoding:NSUTF8StringEncoding]
                                                      key:decodedKeyData
                                                       iv:decodedIVData];
    
    NSString *base64CountryKeyString2 = [EncodedkeyData2 base64EncodedStringWithOptions:0];
    base64CountryKeyString2 = [ self URLEncodeStringFromString:base64CountryKeyString2];
    
    NSData *EncodedData3 = [FBEncryptorAES encryptData:[categoryID dataUsingEncoding:NSUTF8StringEncoding]
                                                   key:decodedKeyData
                                                    iv:decodedIVData];
    
    NSString *base64CountryIDString3 = [EncodedData3 base64EncodedStringWithOptions:0];
    base64CountryIDString3 = [ self URLEncodeStringFromString:base64CountryIDString3];
    
    NSData *EncodedkeyData3 = [FBEncryptorAES encryptData:[@"bill_category_id" dataUsingEncoding:NSUTF8StringEncoding]
                                                      key:decodedKeyData
                                                       iv:decodedIVData];
    
    NSString *base64CountryKeyString3 = [EncodedkeyData3 base64EncodedStringWithOptions:0];
    base64CountryKeyString3 = [ self URLEncodeStringFromString:base64CountryKeyString3];

    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSString* apiURl = [ NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@",ListActiveBillers, base64CountryKeyString,base64CountryIDString, base64CountryKeyString2,base64CountryIDString2 , base64CountryKeyString3,base64CountryIDString3];
    
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:apiURl parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failed with error %@", operation.responseString);
         NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
         
         if ([operation.response statusCode] == 200)
         {
             NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
             
             NSString * result;
             NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
             if (data1)
             {
                 result= [[NSString alloc] initWithData:data1
                                               encoding:NSUTF8StringEncoding];
             } else
             {
                 result = operation.responseString;
             }
             failure(result);
         }
         else
         {
             if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
             {
                 NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                 
                 NSError *error;
                 NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:NSJSONReadingMutableContainers error:&error];
                 
                 NSString *message = [ json valueForKey:@"message"];
                 
                 failure(message);
             }
             else
             {
                 failure(@"Please try after some time, as the server is not responding.");
             }
         }
         
     }];
    
    [reqOp start];
}

#pragma mark Get Bill list method
+ (void) GetBillListByBillerID:(NSString *)billerID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

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
    
    NSData *EncodedData = [FBEncryptorAES encryptData:[billerID dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64CountryIDString = [EncodedData base64EncodedStringWithOptions:0];
    base64CountryIDString = [ self URLEncodeStringFromString:base64CountryIDString];
    
    NSData *EncodedkeyData = [FBEncryptorAES encryptData:[@"biller_id" dataUsingEncoding:NSUTF8StringEncoding]
                                                     key:decodedKeyData
                                                      iv:decodedIVData];
    
    NSString *base64CountryKeyString = [EncodedkeyData base64EncodedStringWithOptions:0];
    base64CountryKeyString = [ self URLEncodeStringFromString:base64CountryKeyString];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSString* apiURl = [ NSString stringWithFormat:@"%@?%@=%@",ListBills, base64CountryKeyString,base64CountryIDString];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:apiURl parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failed with error %@", operation.responseString);
         NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
         
         if ([operation.response statusCode] == 200)
         {
             NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
             
             NSString * result;
             NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
             if (data1)
             {
                 result= [[NSString alloc] initWithData:data1
                                               encoding:NSUTF8StringEncoding];
             } else
             {
                 result = operation.responseString;
             }
             failure(result);
         }
         else
         {
             if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
             {
                 NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                 
                 NSError *error;
                 NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:NSJSONReadingMutableContainers error:&error];
                 
                 NSString *message = [ json valueForKey:@"message"];
                 
                 failure(message);
             }
             else
             {
                 failure(@"Please try after some time, as the server is not responding.");
             }
         }
         
     }];
    
    [reqOp start];
}

#pragma mark Get ListBanks method

+ (void) GetListBanksByCountryID:(NSString *)countryID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure
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
    
    NSData *EncodedData = [FBEncryptorAES encryptData:[countryID dataUsingEncoding:NSUTF8StringEncoding]
                                                  key:decodedKeyData
                                                   iv:decodedIVData];
    
    NSString *base64CountryIDString = [EncodedData base64EncodedStringWithOptions:0];
    base64CountryIDString = [ self URLEncodeStringFromString:base64CountryIDString];
    
    NSData *EncodedkeyData = [FBEncryptorAES encryptData:[@"currency_id" dataUsingEncoding:NSUTF8StringEncoding]
                                                     key:decodedKeyData
                                                      iv:decodedIVData];
    
    NSString *base64CountryKeyString = [EncodedkeyData base64EncodedStringWithOptions:0];
    base64CountryKeyString = [ self URLEncodeStringFromString:base64CountryKeyString];
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    [client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    [client setDefaultHeader:@"token" value:userTokenString];
    
    NSString* apiURl = [ NSString stringWithFormat:@"%@?%@=%@",ListBanks, base64CountryKeyString,base64CountryIDString];
    NSMutableURLRequest *req = [client requestWithMethod:@"GET" path:apiURl parameters:nil];
    
    AFJSONRequestOperation *reqOp = [[AFJSONRequestOperation alloc] initWithRequest:req];
    
    [reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Succeeded with object %@", responseObject);
        NSLog(@"Request was %@", operation);
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failed with error %@", operation.responseString);
         NSLog(@"Failed with error %li", (long)[operation.response statusCode]);
         
         if ([operation.response statusCode] == 200)
         {
             NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:operation.responseString options:0];
             
             NSString * result;
             NSData* data1 = [FBEncryptorAES decryptData:decodedData key:decodedKeyData iv:decodedIVData];
             if (data1)
             {
                 result= [[NSString alloc] initWithData:data1
                                               encoding:NSUTF8StringEncoding];
             } else
             {
                 result = operation.responseString;
             }
             failure(result);
         }
         else
         {
             if ([error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"])
             {
                 NSString * errorMessage = [ error.userInfo objectForKey:@"NSLocalizedRecoverySuggestion"];
                 
                 NSError *error;
                 NSData *jsonData = [errorMessage dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:NSJSONReadingMutableContainers error:&error];
                 
                 NSString *message = [ json valueForKey:@"message"];
                 
                 failure(message);
             }
             else
             {
                 failure(@"Please try after some time, as the server is not responding.");
             }
         }
         
     }];
    
    [reqOp start];
}


@end
