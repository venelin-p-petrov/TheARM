//
//  RestManager.m
//  TheARM
//
//  Created by Mihail Karev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "RestManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation RestManager



static NSString * const apiURL = @"http://vm-hackathon2.westeurope.cloudapp.azure.com:8080";

static NSString *_token = @"1";

+ (void)doLoginWithUsername:(NSString *) username password:(NSString *) password onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error{
    NSDictionary *parameters = @{@"username": username, @"password": password, @"token":_token};
    NSString *url = [NSString stringWithFormat:@"%@/api/login", apiURL];
    
    [RestManager doPostRequestWithUrl:url parameters:parameters onSuccess:success onError:error];
}

+ (void)doRegisterUsername:(NSString *) username password:(NSString *) password andEmail:(NSString *) email
         onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error{
    NSString *osVersion = [NSString stringWithFormat: @"iOS-%f", [[[UIDevice currentDevice] systemVersion] floatValue]] ;
    NSDictionary *parameters = @{@"username": username, @"password": password, @"token": _token, @"email": email, @"os": osVersion};
    NSString *url = [NSString stringWithFormat:@"%@/api/register", apiURL];
    
    [RestManager doPostRequestWithUrl:url parameters:parameters onSuccess:success onError:error];
}

+ (void)getResourcesWithUrl:(NSString *) companyId onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error{
    NSString *url = [NSString stringWithFormat:@"%@/api/%@/resources", apiURL,companyId];
    [RestManager doGetRequestWithUrl:url parameters:nil onSuccess:success];
}

+ (void)getEventsWithUrl:(NSString *) companyId onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error{
    NSString *url = [NSString stringWithFormat:@"%@/api/%@/events", apiURL,companyId];
    [RestManager doGetRequestWithUrl:url parameters:nil onSuccess:success];
}



+ (void)doGetRequestWithUrl:(NSString *) url parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSError *e;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&e];
    
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)doPostRequestWithUrl:(NSString *) url parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock) errorBlock{
    AFHTTPRequestOperationManager *manager = [RestManager createManager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
       manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
 
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success(responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
    }];
}

+ (AFHTTPRequestOperationManager *)createManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return manager;
}

+ (void) setToken:(NSString *)token{
    _token = token;
}

@end
