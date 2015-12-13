//
//  EventDetailVIewController.m
//  TheARM
//
//  Created by Mihail Karev on 12/2/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "EventDetailVIewController.h"
#import "DateHelper.h"

@implementation ResourceCell

@end

@implementation DescriptionCell
@end

@implementation UserCell
@end

@implementation DatePickerCell

@end

@implementation DateCell
@end

@implementation EventDetailVIewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _isDateSelected = NO;
    _isStartDateSelected = NO;
    _isDatePickerLoaded = NO;
    if (self.eventViewState == CREATE) {
        [self.actionButton setTitle:@"Add"];
        [self.currentEvent setValue:[NSNumber numberWithInt:1] forKey:@"minUsers"];
        [self.currentEvent setValue:[NSNumber numberWithInt:2] forKey:@"maxUsers"];
        [self.currentEvent setValue:[NSNumber numberWithInt:1] forKey:@"ownerId"];
        [self.currentEvent setValue:[self.currentResource objectForKey:@"resourceId"] forKey:@"resourceId"];
        
    } else if (self.eventViewState == EDIT){
        [self.actionButton setTitle:@"Save"];
    } if (self.eventViewState == VIEW){
        [self.actionButton setTitle:@"Join"];
    }
   
}
- (IBAction)actionButtonClicked:(id)sender {
 NSLog(@"create event -> %@", self.currentEvent);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.currentEvent
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json string --->  %@", jsonString);
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            if (_isDateSelected){
                return 3;
            } else {
                return 2;
            }
            break;
        default:
            return 1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1){
        return 30;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2){
        return @"Participients - (1/4)";
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && _isDateSelected && ((_isStartDateSelected && indexPath.row == 1) || (!_isStartDateSelected && indexPath.row==2)) ){
        return 216;
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        return 100;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        return [self firstSectionInEvent:tableView cellForRowAtIndexPath:indexPath];
    } else if (indexPath.section == 1){
        return [self secondSectionInEvent:tableView cellForRowAtIndexPath:indexPath];
    } else {
        return [self userSectionInEvent:tableView cellForRowAtIndexPath:indexPath];
    }
}

-(UITableViewCell *)firstSectionInEvent:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        ResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResourceCell" forIndexPath:indexPath];
        cell.resourceLabel.text = [self.currentResource objectForKey:@"name"];
        return cell;
    } else {
        DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell" forIndexPath:indexPath];
        cell.descriptionTextField.delegate = self;
        NSString *description = [self.currentEvent objectForKey:@"description"];
        if (description == nil || [description isEqualToString:@""]){
            cell.descriptionTextField.text = @"Add description here";
            cell.descriptionTextField.textColor = [UIColor lightGrayColor];
        } else {
            cell.descriptionTextField.text = description;
            cell.descriptionTextField.textColor = [UIColor blackColor];
        }
        if (self.eventViewState == CREATE || self.eventViewState == EDIT){
            cell.descriptionTextField.editable = YES;
        } else {
            cell.descriptionTextField.editable = NO;
        }
        return cell;

    }
}


-(UITableViewCell *) secondSectionInEvent:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
        cell.cellInfoLabel.text = @"Start Date";
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",[self.currentEvent objectForKey:@"startTime"]];
        return cell;
    } else if (_isDateSelected && ((_isStartDateSelected && indexPath.row == 1) || (!_isStartDateSelected && indexPath.row==2)) ){
        return [self tableView:tableView generateDatePickerCellForIndexPath:indexPath];
        
    } else {
        DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
        cell.cellInfoLabel.text = @"End Date";
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",[self.currentEvent objectForKey:@"endTime"]];
        return cell;

    }
}

- (UITableViewCell *) tableView:(UITableView *) tableView generateDatePickerCellForIndexPath:(NSIndexPath *) indexPath{
    DatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell" forIndexPath:indexPath];
    if (!_isDatePickerLoaded){
        [cell.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        _isDatePickerLoaded = YES;
    }
    NSDate *date = [NSDate new];
    if (_isStartDateSelected){
        date = [DateHelper convertDateFromString: [self.currentEvent objectForKey:@"startTime"]];
    } else {
        date = [DateHelper convertDateFromString: [self.currentEvent objectForKey:@"endTime"]];
    }
    [cell.datePicker setDate:date];
    return cell;
}

-(UITableViewCell *) userSectionInEvent:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    cell.usernameLabel.text = @"User Userov";
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && (self.eventViewState == CREATE || self.eventViewState == EDIT)) {
        if (indexPath.row == 0){
            _isStartDateSelected = YES;
            _isDateSelected = YES;
        }
        else if(indexPath.row ==1 && _isDateSelected == NO) {
            _isStartDateSelected = NO;
            _isDateSelected = YES;
        }
    } else {
        _isStartDateSelected = NO;
        _isDateSelected = NO;
    }
    [tableView reloadData];
}

#pragma mark UITextViewDelgate implementation

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Add description here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add description here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    } else {
        [self.currentEvent setValue:textView.text forKey:@"description"];
    }
    [textView resignFirstResponder];
}

#pragma mark UIDatePicker
- (void)dateChanged:(id)sender{
    NSLog(@"Date changed");
    UIDatePicker *datePicker = (UIDatePicker *) sender;
    if (_isStartDateSelected) {
        [self.currentEvent setValue:[DateHelper convertStringFromDate:datePicker.date]forKey:@"startTime"];
    } else {
        [self.currentEvent setValue:[DateHelper convertStringFromDate:datePicker.date] forKey:@"endTime"];
    }
    [self.tableView reloadData];
}

@end
