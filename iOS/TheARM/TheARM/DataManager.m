//
//  DataManager.m
//  TheARM
//
//  Created by Mihail Karev on 12/6/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "DataManager.h"
#import "RestManager.h"
#import "DateHelper.h"
#import <AFNetworking/AFNetworking.h>

@implementation DataManager

+ (id)sharedDataManager {
    static DataManager *sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[self alloc] init];
    });
    return sharedDataManager;
}

- (id)init {
    if (self = [super init]) {
       
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


- (void)doCreateEvent:(NSDictionary *) parameters
            onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error {
  
    NSString *url = [NSString stringWithFormat:@"/api/events/create"];
    
    [RestManager doPostRequestWithUrl:url parameters:parameters onSuccess:^(NSObject *responseObject) {
        NSDictionary *response = (NSDictionary*) responseObject;
        if (![[response objectForKey:@"status"] isEqualToString:@"failed"]) {
            NSString *startTimeString = [response objectForKey:@"startTime"];
            NSDate *startDate = [DateHelper convertDateFromString:startTimeString];
            NSDate *remainderDate = [NSDate dateWithTimeInterval:-(60 * 5) sinceDate:startDate];
            if ([remainderDate compare:[NSDate date]] == NSOrderedDescending){
                UILocalNotification *startNotification = [[UILocalNotification alloc] init];

                startNotification.fireDate = remainderDate;
                startNotification.applicationIconBadgeNumber = 1;
                startNotification.soundName = UILocalNotificationDefaultSoundName;
                startNotification.alertBody = [NSString stringWithFormat:@"It is time for %@", [response objectForKey:@"description"]];
             
                [[UIApplication sharedApplication] scheduleLocalNotification: startNotification];
            }
        }
        success(responseObject);
    } onError:error];
}

- (void)doLoginWithUsername:(NSString *) username password:(NSString *) password onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error{
    NSDictionary *parameters = @{@"username": username, @"password": password, @"token":self.token};
    NSString *url = [NSString stringWithFormat:@"/api/login"];
    
    [RestManager doPostRequestWithUrl:url parameters:parameters onSuccess:^(NSObject *responseObject) {
       
        self.user = (NSDictionary *)responseObject;
        if ([@"success" isEqualToString:[self.user objectForKey:@"status"]]){
            [self getEventsWithCompanyId:@"1" onSuccess:^(NSObject *responseObject) {
              
            } onError:^(NSError *error) {
                
            }];
            [self getResourcesWithCompanyId:@"1" onSuccess:^(NSObject *responseObject) {
                
            } onError:^(NSError *error) {
                
            }];
            
        }
        
        success(responseObject);
        
    } onError:error];
}

- (void)doRegisterUsername:(NSString *) username password:(NSString *) password andEmail:(NSString *) email
                 onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error{
    NSString *osVersion = [NSString stringWithFormat: @"iOS-%f", [[[UIDevice currentDevice] systemVersion] floatValue]] ;
    NSDictionary *parameters = @{@"username": username, @"password": password, @"token": _token, @"email": email,@"displayName":@"iOS", @"os": osVersion};
    NSString *url = [NSString stringWithFormat:@"/api/register"];
    
    [RestManager doPostRequestWithUrl:url parameters:parameters onSuccess:success onError:error];
}


- (void)getResourcesWithCompanyId:(NSString *) companyId onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error{
    NSString *url = [NSString stringWithFormat:@"/api/%@/resources",companyId];
    [RestManager doGetRequestWithUrl:url parameters:nil onSuccess:^(NSObject *responseObject) {
        self.resources = (NSArray *)responseObject;
        success(responseObject);
    }];
    
}

- (void)getEventsWithCompanyId:(NSString *) companyId onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error{
    NSString *url = [NSString stringWithFormat:@"/api/%@/events",companyId];
    [RestManager doGetRequestWithUrl:url parameters:nil onSuccess:^(NSObject *responseObject) {
        self.events = (NSArray *)responseObject;
        success(responseObject);
    }];
}


- (void)doJoinEvent:(NSDictionary *) parameters
            onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error {
    
    NSString *url = [NSString stringWithFormat:@"/api/events/join"];
    
    [RestManager doPostRequestWithUrl:url parameters:parameters onSuccess:success onError:error];
}

- (void)doLeaveEvent:(NSDictionary *) parameters
            onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error {
    
    NSString *url = [NSString stringWithFormat:@"/api/events/leave"];
    
   
    [RestManager doPostRequestWithUrl:url parameters:parameters onSuccess:success onError:error];
}

- (void)doDelete:(NSString *) eventId andUserId:(NSString *) userId
           onSuccess:(ARMResponsBlock)success onError:(ARMErrorBlock)error {
    
    NSString *url = [NSString stringWithFormat:@"/api/events/delete"];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:eventId,@"eventId",userId,@"userId", nil];
    [RestManager doDeleteRequestWithUrl:url parameters:parameters onSuccess:success onError:error];
}

@end
