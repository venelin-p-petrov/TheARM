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

+ (void)doLogin:(NSString *) username password:(NSString *) password andToken:(NSString *) token onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error{
    NSDictionary *parameters = @{@"username": username, @"password": password, @"token":token};
    NSString *url = [NSString stringWithFormat:@"%@/api/login", apiURL];
    
    [RestManager doPostRequest:url parameters:parameters onSuccess:success onError:error];
}

+ (void)doGetRequest:(NSString *) url parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)doPostRequest:(NSString *) url parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock) errorBlock{
    AFHTTPRequestOperationManager *manager = [RestManager createManager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        success(responseObject);
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

@end
