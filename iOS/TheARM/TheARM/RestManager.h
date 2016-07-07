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

+ (void)doLoginWithUsername:(NSString *) username password:(NSString *) password onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;
+ (void)doRegisterUsername:(NSString *) username password:(NSString *) password andEmail:(NSString *) email
         onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;

+ (void)getResourcesWithCompanyId:(NSString *) companyId onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;
+ (void)getEventsWithCompanyId:(NSString *) companyId onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;

+ (void) setToken: (NSString *)token;

@end
