//
//  DuphluxAuth.m
//  MoneyTransfer
//
//  Created by Graycell on 12/7/17.
//  Copyright © 2017 UVE. All rights reserved.
//

#import "DuphluxAuth.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "ReachabiltyTest.h"

@implementation DuphluxAuth

+(void) callAuthMethod :(NSDictionary *)Mobile  withSuccess:(void (^)(NSString *))success andFailure:(void (^)(NSString *))failure
{
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@", @"https://duphlux.com/webservice/authe/verify.json"];
    NSURL *url = [NSURL URLWithString:ApiUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request addValue:@"0529a925f2afca8e20f770abd6378ed8805b5593" forHTTPHeaderField:@"token"];
    
    NSData *PostData = [NSJSONSerialization dataWithJSONObject:Mobile options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setHTTPBody:PostData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if communication was successful
        if (!error)
        {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200)
            {
                NSString* resultString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"result string %@", resultString);
                success(resultString);
            }
            else{
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        else{
           failure(@"Please try after some time, as the server is not responding.");
        }
    }];
    [postDataTask resume];
}

+(void) checkAuthStatusMethod :(NSDictionary *)transcationDic withSuccess:(void (^)(NSString *))success andFailure:(void (^)(NSString *))failure
{
    NSString *ApiUrl = [ NSString stringWithFormat:@"%@", @"https://duphlux.com/webservice/authe/status.json"];
    NSURL *url = [NSURL URLWithString:ApiUrl];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request addValue:@"0529a925f2afca8e20f770abd6378ed8805b5593" forHTTPHeaderField:@"token"];
    
    NSData *PostData = [NSJSONSerialization dataWithJSONObject:transcationDic options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setHTTPBody:PostData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if communication was successful
        if (!error)
        {
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            if (httpResp.statusCode == 200)
            {
                NSString* resultString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"result string %@", resultString);
                success(resultString);
            }
            else{
                failure(@"Please try after some time, as the server is not responding.");
            }
        }
        else{
            failure(@"Please try after some time, as the server is not responding.");
        }
    }];
    [postDataTask resume];
}
@end
