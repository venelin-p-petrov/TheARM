//
//  DataManager.m
//  TheARM
//
//  Created by Mihail Karev on 12/6/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "DataManager.h"

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


@end
