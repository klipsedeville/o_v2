//
//  AppDelegate.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))

//#define BaseUrl @"http://63.118.42.42/m4/api"
//#define BaseUrl @"http://192.168.100.15/moneyTransfer/wwwroot/"
//#define BaseUrl @"http://staging.orobo.com/"
#define BaseUrl @"https://staging.orobo.com/"
#define Login @"webservice/users/login.json"
#define SignUp @"webservice/users/add.json"
#define ForgotPassword @"webservice/users/forgot_password.json"

#define ChangePassword @"webservice/users/change_password.json"
#define BeneficiaryList @"webservice/beneficiaries.json"
#define CreateBeneficiary @"webservice/beneficiaries/create.json"

#define DeletBeneficary @"webservice/beneficiaries/delete.json"
#define Listsettlementchannel @"webservice/currencies/settlement_channels.json?"

#define AddCard @"webservice/users/save_stripe_card_customer.json"

#define ListofReceivingCurrency @"webservice/currencies/list_currencies/receiving.json"
#define ListofSendingCurrency @"webservice/currencies/list_currencies/sending.json"
#define GetCommericials @"webservice/currencies/calculate_fee.json"
#define TransferRequest @"webservice/transfer_requests/create.json"
#define ListofTransfers @"webservice/transfer_requests.json"
//#define ListBills @"webservice/bills/list_bills.json?bill_category_id="
//#define ListBills @"webservice/bills/list_bills.json?"
//#define ListBills @"/webservice/bills/list_categories.json?"
#define ListBillsCategories @"webservice/bills/list_categories.json"

#define PayBill @"webservice/bills/pay.json"





#define BillersList @"webservice/beneficiaries/list_merchants.json"
#define UserProfile @"webservice/users/profile.json"
#define URLImage @"img/flags/"


#define ResetPassword @"webservice/users/reset_password.json"
#define RecommendBiller @"webservice/bills/recommend_biller.json"
#define ListFundingChannels @"webservice/currencies/funding_channels.json?currency_id=154"
#define ListAllCurrencies @"webservice/currencies.json"
#define ListBillStates @"webservice/bills/list_states.json"
#define ListActiveBillers @"webservice/bills/list_billers.json?"
#define ListBills @"webservice/bills/list_bills_by_biller.json?"
#define ListBillPayments @"webservice/bills/list_bill_payments.json"

#define ListBanks @"webservice/currencies/list_banks.json"
