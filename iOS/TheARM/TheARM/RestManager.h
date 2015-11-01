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

+ (void)doLogin:(NSString *) username password:(NSString *) password andToken:(NSString *) token onSuccess:(ARMResponsBlock)success;

@end
