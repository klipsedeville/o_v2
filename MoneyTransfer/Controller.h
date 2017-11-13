//
//  Controller.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 10/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "FBEncryptorAES.h"
#import "NSData+Base64.h"

@interface Controller : NSObject

+ (NSString *)URLEncodeStringFromString:(NSString *)string;
//Login Method
+ (void) loginByUserEmail:(NSString *)email Password:(NSString *)password withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// SignUp Method
+(void) createAccountWithName :(NSString *)firstName SurName:(NSString *)surname EmailAddress:(NSString *)emailAddress PhoneNumber:(NSString *)phoneNumber address:(NSString*)address CountryID:(NSString *)countryID Password:(NSString*)password ReferralCode:(NSString*)referralCode withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// SignUp Method
+(void) authPhone :(NSDictionary *)Mobile  withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

//Get Sending Currency  Method
+ (void) getAllSendingCurrencyWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

//Get Receiving Currency  Method
+ (void) getAllReceivingCurrencyWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;


//Get Bills  Method With Country Currency ID
+ (void) getBillsWithCategoryID:(NSString *)categoryID CurrencyID:(NSString *)currencyID WithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

//Get Bills  Method
+ (void) getBillsCategoriesWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;


//Get User Logout  Method
+(void) userLogoutWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// get Recent Transactions Method
+ (void) getRecentTransactionsWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

//Get Recent Bill Payment list method

+ (void) getRecentBillPaymentWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// get Recent Beneficiaries List Method
+ (void) GetBeneficiariesListWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// get List Settlement Channel  Method
+ (void) GetSettlementChannelListByUCountryID:(NSString *)countryID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// get Billers list  Method
+ (void) GetBillersListWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// get User Profile  Method
+ (void) GetUserProfileWithSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// Forgot Password Method
+ (void) forgotPassord :(NSString *)email  withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// Add Card Method
+(void) AddCardWithBrand :(NSString *)brandName Country:(NSString *)countryName Last4:(NSString *) last4 Stripe_token:(NSString *)stripe_token withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

// get Bill States  Method
+(void) GetBillStatesListByCountryID:(NSString *)countryID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

//get Billers list with country Method
+ (void) GetBillerListByCountryID:(NSString *)countryID categoryID: (NSString *)categoryID stateID: (NSString *)stateID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

//get Bill list  Method
+ (void) GetBillListByBillerID:(NSString *)billerID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

//get Banks list  Method
+(void) GetListBanksByCountryID:(NSString *)countryID withSuccess:(void (^)(id))success andFailure:(void (^)(NSString *))failure;

@end
