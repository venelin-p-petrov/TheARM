//
//  RestManager.h
//  TheARM
//
//  Created by Mihail Karev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ARMResponsBlock)(NSObject *responseObject);
typedef void (^ARMErrorBlock)(NSError *error);

@interface RestManager : NSObject


+ (void)doPostRequestWithUrl:(NSString *) urlPath parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock) errorBlock;

+ (void)doGetRequestWithUrl:(NSString *) url parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success;

+ (void)doDeleteRequestWithUrl:(NSString *) urlPath parameters:(NSDictionary *) parameters onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock) errorBlock;
+(NSString *) generateURL:(NSString *) path;

@end
