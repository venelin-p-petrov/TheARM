//
//  EventViewController.m
//  TheARM
//
//  Created by Mihail Karev on 11/15/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTexrView;
@property (weak, nonatomic) IBOutlet UIButton *fromButton;
@property (weak, nonatomic) IBOutlet UIButton *toButton;
@property (weak, nonatomic) IBOutlet UITextView *participientsTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end


@implementation EventViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.titleLabel.text = [self.currentEvent objectForKey:@"name"];
    self.descriptionTexrView.text = [self.currentEvent objectForKey:@"description"];
    NSDateFormatter *formatter       =   [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDateFormatter *stringToDateFormater = [[NSDateFormatter alloc] init];
    NSString *startDateString = [self.currentEvent objectForKey:@"startTime"];
    NSDate *date = [stringToDateFormater dateFromString:startDateString];
    NSString *stratTime = [formatter stringFromDate:date];
    self.fromButton.titleLabel.text = stratTime;
    
    
    date = [stringToDateFormater dateFromString:[self.currentEvent objectForKey:@"endTime"]];
    NSString *endTime = [formatter stringFromDate:date];
    self.toButton.titleLabel.text = endTime;
}

-(void)dealloc{
    self.currentEvent = nil;
}

@end
