//
//  EventViewController.m
//  TheARM
//
//  Created by Mihail Karev on 11/15/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "EventViewController.h"
#import "DateHelper.h"

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
    for (NSDictionary *user in[self.currentEvent objectForKey:@"users"]){
        NSString *name = [user objectForKey:@"displayName"];
        self.participientsTextView.text = [NSString stringWithFormat:@"%@\n%@,", self.participientsTextView.text, name];
    }
    self.datePicker.backgroundColor = [UIColor lightGrayColor];
//    [self.datePicker set	]
    [self.participientsTextView setEditable:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate *date = [DateHelper convertDateFromString:[self.currentEvent objectForKey:@"startTime"]];
    NSString *stratTime = [formatter stringFromDate:date];
    
    [self.fromButton setTitle:stratTime forState:UIControlStateNormal];
    date = [DateHelper convertDateFromString:[self.currentEvent objectForKey:@"endTime"]];
    NSString *endTime = [formatter stringFromDate:date];
    [self.toButton setTitle:endTime forState:UIControlStateNormal];
}

-(void)dealloc{
    self.currentEvent = nil;
}

@end
