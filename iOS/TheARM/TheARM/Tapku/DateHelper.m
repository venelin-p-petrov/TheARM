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

static NSString * const HOURS_FORMAT = @"HH:mm";
static NSString * const DATE_FORMAT = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
static NSString * const STRING_FORMAT = @"yyyy-MM-dd HH:mm:ss";

+(NSDate *)convertDateFromString:(NSString *) dateString{
    
    NSDateFormatter *stringToDateFormater = [[NSDateFormatter alloc] init];
    [stringToDateFormater setDateFormat:DATE_FORMAT];
    NSDate *date = [stringToDateFormater dateFromString:dateString];
    return date;
}

+(NSString *)convertStringFromDate:(NSDate *) date {
    NSDateFormatter *stringToDateFormater = [[NSDateFormatter alloc] init];
    [stringToDateFormater setDateFormat:DATE_FORMAT];
    return  [stringToDateFormater stringFromDate:date];
}


+(NSString *)convertStringHoursMinutesFromDate:(NSDate *) date {
    NSDateFormatter *stringToDateFormater = [[NSDateFormatter alloc] init];
    [stringToDateFormater setDateFormat:HOURS_FORMAT];
    return  [stringToDateFormater stringFromDate:date];
}

@end