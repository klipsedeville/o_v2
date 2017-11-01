//
//  ReachabiltyTest.h
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabiltyTest : NSObject
{
    Reachability *internetReach;
}
-(int)updateInterfaceWithReachability;
-(void)CheckInternetConnection;
@end
