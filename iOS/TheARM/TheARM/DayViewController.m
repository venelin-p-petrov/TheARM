//
//  ViewController.m
//  Calender
//
//  Created by ECWIT on 15/04/15.
//  Copyright (c) 2015 ECWIT. All rights reserved.
//

#import "DayViewController.h"

#import "NSDate+TKCategory.h"
#import "TKCalendarDayEventView.h"
#import "TKCalendarDayView.h"
#import "TKCalendarDayViewController.h"
#import "DataManager.h"
#import "DateHelper.h"
#import "EventDetailVIewController.h"

@interface DayViewController ()

@end

@implementation DayViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
//    mutArrEvents = [NSMutableArray arrayWithObjects:
//                    @[@"Meeting with CEO, MD and COO", @"Paresh Navadiya Paresh Navadiya", @2, @0, @2, @15],
//                    @[@"Call with HCA Client, Call with HCA Client, Call with HCA Client", @"Paresh Navadiya", @7, @0, @7, @45],
//                    @[@"Break for 1 hour", @"Paresh Navadiya", @15, @0, @16, @00],
//                    @[@"Break for 1 hour and 30 minutes", @"Paresh Navadiya", @15, @0, @16, @30],
//                    @[@"Reports for product managment", @"Paresh Navadiya", @5, @30, @6, @0],
//                    @[@"QC Task needed to be done", @"Paresh Navadiya", @19, @30, @24, @0], nil];
    [self loadEvents];
    
    CGRect frame = self.view.bounds;
    mutArrEvents = [NSArray new];
    self.dayView.frame = frame;
    
    //paresh
    NSDateComponents *compNow = [NSDate componentsOfCurrentDate];
    [self performSelector:@selector(updateToCurrentTime) withObject:self afterDelay:60.0f-compNow.second];
    
    //Add Long Press Gesture Reconizer
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
//                                               initWithTarget:self action:@selector(handleLongPress:)];
//    longPress.minimumPressDuration = 2; //seconds
//    longPress.delegate = self;
//    [self.dayView addGestureRecognizer:longPress];
}
- (IBAction)addEvent:(id)sender {
}



- (void) loadEvents{
    DataManager *dataManager = [DataManager sharedDataManager];
    [dataManager getEventsWithCompanyId:@"1" onSuccess:^(NSObject *responseObject){
        mutArrEvents = (NSArray *) responseObject;
        [self.dayView reloadData];
    }onError:^(NSError *error){
        
    }];
}

-(void)updateToCurrentTime
{
    if (self.dayView) {
        [self.dayView.nowLineView updateTime];
    }
    [self performSelector:@selector(updateToCurrentTime) withObject:self afterDelay:60.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TKCalendarDayViewDelegate
- (NSArray *) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventsForDate:(NSDate *)eventDate{
    
    NSLog(@"eventDate : %@",eventDate);
    
    if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:-24*60*60]] == NSOrderedAscending)
        return @[];
    
    if([eventDate compare:[NSDate dateWithTimeIntervalSinceNow:24*60*60]] == NSOrderedDescending)
        return @[];
    
    NSMutableArray *ret = [NSMutableArray array];
    
    for(NSDictionary *eventDictionary in mutArrEvents){
        
        TKCalendarDayEventView *event = [self generateEvenetFromDict:eventDictionary forCalendat:calendarDayTimeline];
        [ret addObject:event];
        
    }
    return ret;
    
    
}


-(TKCalendarDayEventView *) generateEvenetFromDict:(NSDictionary *) eventDictionary forCalendat:(TKCalendarDayView*)calendarDayTimeline {
    TKCalendarDayEventView *event = [calendarDayTimeline dequeueReusableEventView];
    if(event == nil) event = [TKCalendarDayEventView eventView];
    
    NSInteger col = arc4random_uniform(3);
    [event setColorType:col];
    event.identifier = nil;
    event.titleLabel.text = [eventDictionary objectForKey:@"description"];
    event.locationLabel.text = [eventDictionary objectForKey:@"name"];
    
    NSString *startDateString = [eventDictionary objectForKey:@"startTime"];
    event.startDate = [DateHelper convertDateFromString:startDateString];

    NSString *endDateString = [eventDictionary objectForKey:@"endTime"];
    event.endDate = [DateHelper convertDateFromString:endDateString];
    return event;
}

- (void) calendarDayTimelineView:(TKCalendarDayView*)calendarDayTimeline eventViewWasSelected:(TKCalendarDayEventView *)eventView{
    NSLog(@"%@",eventView.titleLabel.text);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"CreateEvent" isEqualToString:segue.identifier]){
        EventDetailVIewController *viewController = (EventDetailVIewController *) segue.destinationViewController;
        [viewController setCurrentResource:self.resource];
        [viewController setCurrentEvent:[NSMutableDictionary dictionaryWithObjectsAndKeys:[DateHelper convertStringFromDate:[NSDate new]],@"startTime",[DateHelper convertStringFromDate:[NSDate new]], @"endTime", nil]];
        [viewController setEventViewState:CREATE];
    }
}

@end
