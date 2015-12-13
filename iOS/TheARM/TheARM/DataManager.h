//
//  DataManager.h
//  TheARM
//
//  Created by Mihail Karev on 12/6/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (atomic, strong) NSArray *events;
@property (atomic, strong) NSArray *resources;
@property (atomic, strong) NSDictionary *user;

+ (id)sharedDataManager;

@end
