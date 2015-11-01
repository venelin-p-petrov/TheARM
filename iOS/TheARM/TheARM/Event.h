//
//  Resource.h
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *eventName;
@property (strong, nonatomic) NSString *description;
@property int totalSeats;
@property int currentlyTakenSeats;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

+(Event*) deserialiseFromJson: (NSJSONSerialization*) json;

@end
