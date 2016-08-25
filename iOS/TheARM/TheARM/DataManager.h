//
//  DataManager.h
//  TheARM
//
//  Created by Mihail Karev on 12/6/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestManager.h"

@interface DataManager : NSObject

@property (atomic, strong) NSArray *events;
@property (atomic, strong) NSArray *resources;
@property (atomic, strong) NSDictionary *user;
@property (atomic, strong) NSString *token;

+ (id)sharedDataManager;

- (void) setUserFromLocalStore;
- (void)doLoginWithUsername:(NSString *) username password:(NSString *) password onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;
- (void)doRegisterUsername:(NSString *) username password:(NSString *) password email:(NSString *) email andDisplayName:(NSString *)displayName
                 onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;
- (void)doCreateEvent:(NSDictionary *) parameters
                 onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;
- (void)doJoinEvent:(NSDictionary *) parameters
            onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;
- (void)doLeaveEvent:(NSDictionary *) parameters
          onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;
- (void)getResourcesWithCompanyId:(NSString *) companyId onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;
- (void)getEventsWithCompanyId:(NSString *) companyId onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;
- (void)doDelete:(NSString *) eventId andUserId:(NSString *) userId
       onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error;

@end
