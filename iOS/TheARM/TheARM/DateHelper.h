//
//  DateHellper.h
//  TheARM
//
//  Created by Mihail Karev on 11/21/15.
//  Copyright © 2015 Accedia. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+(NSDate *)convertDateFromString:(NSString *) dateString;
+(NSString *)convertStringFromDate:(NSDate *) date;

@end