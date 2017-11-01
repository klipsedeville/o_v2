//
//  ReachabiltyTest.m
//  MoneyTransfer
//
//  Created by Sohan Rajpal on 09/05/16.
//  Copyright © 2016 UVE. All rights reserved.
//

#import "ReachabiltyTest.h"

@implementation ReachabiltyTest

-(void)CheckInternetConnection
{
	internetReach = [Reachability reachabilityForInternetConnection];
	//[internetReach startNotifer];
}

- (int) updateInterfaceWithReachability
{


//    [self CheckInternetConnection];
//    
//    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
//    switch (netStatus)
//    {
//        case NotReachable:
//        {
//            internetWorking = 0;
//            NSLog(@"Internet NOT WORKING");
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            internetWorking = 1;
//            break;
//        }
//        case ReachableViaWWAN:
//        {
//            internetWorking = 1;
//            break;
//        }
//    }
//    return internetWorking;
        __block int internetWorking = 1;
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    [reachability startNotifier];
    reachability.reachableBlock = ^(Reachability *reachability) {
        internetWorking = 1;
    };
    reachability.unreachableBlock = ^(Reachability *reachability) {
        internetWorking = 0;
    };
    [reachability stopNotifier];
    return internetWorking;
}

@end
