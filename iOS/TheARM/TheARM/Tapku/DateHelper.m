//
//  DateHellper.m
//  TheARM
//
//  Created by Mihail Karev on 11/21/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateHelper.h"

@implementation DateHelper

static NSString * const DATE_FORMAT = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

+(NSDate *)convertDateFromString:(NSString *) dateString{
    
    NSDateFormatter *stringToDateFormater = [[NSDateFormatter alloc] init];
    [stringToDateFormater setDateFormat:DATE_FORMAT];
    NSDate *date = [stringToDateFormater dateFromString:dateString];
    return date;
}

@end