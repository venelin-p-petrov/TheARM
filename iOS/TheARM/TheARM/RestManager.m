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



//static NSString * const apiURL = @"http://vm-hackathon2.westeurope.cloudapp.azure.com:8080";
//static NSString * const apiURL = @"http://vm-hackathon-re.westeurope.cloudapp.azure.com:8080";
//static NSString * const apiURL = @"https://thearm.azure-mobile.net";
static NSString * const apiURL = @"https://thearm2.azure-mobile.net";
//static NSString * const apiURL = @"http://10.15.20.135:7017";
static NSString *const zumoApplication = @"FlGJqyAJBDQtoGOnWDCjeoGbRqzAuB44";

+(NSString *) generateURL:(NSString *) path{
    return [NSString stringWithFormat:@"%@%@",apiURL,path];
}


+ (void)doGetRequestWithUrl:(NSString *) urlPath parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success {
    NSString *url = [NSString stringWithFormat:@"%@%@",apiURL,urlPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:zumoApplication forHTTPHeaderField:@"x-zumo-application"];
//    [manager.requestSerializer setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSError *e;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&e];
    
        success(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)doPostRequestWithUrl:(NSString *) urlPath parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock) errorBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",apiURL,urlPath];
    AFHTTPRequestOperationManager *manager = [RestManager createManager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:zumoApplication forHTTPHeaderField:@"x-zumo-application"];
//    [manager.requestSerializer setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
 
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSError *e;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:(id)responseObject options:NSJSONReadingAllowFragments error:&e];
        success(response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        errorBlock(error);
    }];
}

+ (void)doDeleteRequestWithUrl:(NSString *) urlPath parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock) errorBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",apiURL,urlPath];
    AFHTTPRequestOperationManager *manager = [RestManager createManager];
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:zumoApplication forHTTPHeaderField:@"x-zumo-application"];
//    [manager.requestSerializer setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        NSError *e;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:(id)responseObject options:NSJSONReadingAllowFragments error:&e];
        success(response);
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
     [manager.requestSerializer setValue:zumoApplication forHTTPHeaderField:@"x-zumo-application"];
//       [manager.requestSerializer setValue:@"2.0.0" forHTTPHeaderField:@"ZUMO-API-VERSION"];
    return manager;
}


@end
