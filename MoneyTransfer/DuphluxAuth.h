//
//  DuphluxAuth.h
//  MoneyTransfer
//
//  Created by Graycell on 12/7/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DuphluxAuth : NSObject

// Authentication Method
+(void) callAuthMethod :(NSDictionary *)Mobile  withSuccess:(void (^)(NSString *))success andFailure:(void (^)(NSString *))failure;

// Authentication Status Method
+(void) checkAuthStatusMethod :(NSDictionary *)transcationDic  withSuccess:(void (^)(NSString *))success andFailure:(void (^)(NSString *))failure;
@end
