//
//  ViewController.h
//  Calender
//
//  Created by ECWIT on 15/04/15.
//  Copyright (c) 2015 ECWIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarDayViewController.h"

@interface DayViewController : TKCalendarDayViewController<UIGestureRecognizerDelegate>
{
    NSArray *mutArrEvents;
}

@property NSDictionary *resource;


@end

