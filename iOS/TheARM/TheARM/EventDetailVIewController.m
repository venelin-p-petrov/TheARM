//
//  EventDetailVIewController.m
//  TheARM
//
//  Created by Mihail Karev on 12/2/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "EventDetailVIewController.h"
#import "DateHelper.h"
#import "DataManager.h"

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

@implementation PickerCell
@end

@implementation EventDetailVIewController

@synthesize currentEvent,currentResource;

-(void)viewDidLoad{
    [super viewDidLoad];
    _isDateSelected = NO;
    _isStartDateSelected = NO;
    _isDatePickerLoaded = NO;
    if (self.eventViewState == CREATE) {
        [self.actionButton setTitle:@"Add"];
        DataManager *dataManager = [DataManager sharedDataManager];
        NSNumber *userId= [dataManager.user objectForKey:@"userId"];
        [self.currentEvent setValue:[NSNumber numberWithInt:1] forKey:@"minUsers"];
        [self.currentEvent setValue:[NSNumber numberWithInt:2] forKey:@"maxUsers"];
        [self.currentEvent setValue:userId forKey:@"ownerId"];
        [self.currentEvent setValue:[self.currentResource objectForKey:@"resourceId"] forKey:@"resourceId"];
        
    } else if (self.eventViewState == EDIT){
        [self.actionButton setTitle:@"Delete"];
    } else if (self.eventViewState == JOIN){
        [self.actionButton setTitle:@"Join"];
    } else if(self.eventViewState == LEAVE) {
        [self.actionButton setTitle:@"Leave"];
    }
   
}
- (IBAction)actionButtonClicked:(id)sender {
    [self.actionButton setEnabled:NO];
    if (self.eventViewState == CREATE){
        [self createEvent];
    } else if(self.eventViewState == LEAVE){
        [self leaveEvent];
    } else if (self.eventViewState == JOIN){
        [self joinEvent];
    } else if (self.eventViewState == EDIT){
        [self deleteEvent];
    }
 
}

- (void) deleteEvent{
    DataManager *dataManager = [DataManager sharedDataManager];
    
    [dataManager doDelete:[self.currentEvent objectForKey:@"eventId"] andUserId:[dataManager.user objectForKey:@"userId"] onSuccess:^(NSObject *responseObject) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successfuly deleted event" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView setDelegate:self];
        [alertView show];
    } onError:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) leaveEvent{
    DataManager *dataManager = [DataManager sharedDataManager];
    NSDictionary *requestBody = [NSDictionary dictionaryWithObjectsAndKeys:[dataManager.user objectForKey:@"userId"],@"userId",[self.currentEvent objectForKey:@"eventId"],@"eventId", nil];
    [dataManager doLeaveEvent:requestBody onSuccess:^(NSObject *responseObject) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successfuly left the event" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } onError:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void) joinEvent{
    DataManager *dataManager = [DataManager sharedDataManager];
    NSDictionary *requestBody = [NSDictionary dictionaryWithObjectsAndKeys:[dataManager.user objectForKey:@"userId"],@"userId",[self.currentEvent objectForKey:@"eventId"],@"eventId", nil];
    [dataManager doJoinEvent:requestBody onSuccess:^(NSObject *responseObject) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successfuly joined to the event" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } onError:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}
- (void) createEvent{
    DataManager *dataManager = [DataManager sharedDataManager];
    [dataManager doCreateEvent:self.currentEvent onSuccess:^(NSObject *responseObject) {
        NSDictionary *response = (NSDictionary *)responseObject;
        [self.actionButton setEnabled:YES];
        UIAlertView *alertView = nil;
        if ([[response objectForKey:@"status"] isEqualToString:@"failed"]){
            alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        } else {
           alertView = [[UIAlertView alloc] initWithTitle:@"Event is created" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        [alertView show];
    } onError:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *users = [self.currentEvent objectForKey:@"users"];
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
        case 2:
            return [users count];
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
        NSArray *users = [self.currentEvent objectForKey:@"users"];
       return [NSString stringWithFormat:@"Participients - (%tu/%@)",[users count], [self.currentEvent objectForKey:@"usersCount"]];
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
        if (self.eventViewState == CREATE){
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
    } else if (_isDateSelected && (_isStartDateSelected && indexPath.row == 1) ){
        return [self tableView:tableView generateDatePickerCellForIndexPath:indexPath];
        
    } else if  (_isDateSelected &&!_isStartDateSelected && indexPath.row==2){
      return [self tableView:tableView generatePickerCellForIndexPath:indexPath];
    } else {
        DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
        cell.cellInfoLabel.text = @"Duration";
        
        NSDate *startDate = [DateHelper convertDateFromString:[self.currentEvent objectForKey:@"startTime"]];
        NSDate *endDate = [DateHelper convertDateFromString:[self.currentEvent objectForKey:@"endTime"]];
        if (startDate && endDate){
            NSTimeInterval secondsBetween = [endDate timeIntervalSinceDate:startDate];
            cell.dateLabel.text = [NSString stringWithFormat:@"%d Minutes",(int)secondsBetween/60];
        }
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

- (UITableViewCell *) tableView:(UITableView *) tableView generatePickerCellForIndexPath:(NSIndexPath *) indexPath{
    PickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickerCell" forIndexPath:indexPath];
    cell.customPicker.dataSource = self;
    cell.customPicker.delegate = self;
    return cell;
}


-(UITableViewCell *) userSectionInEvent:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    NSArray *users = [self.currentEvent objectForKey:@"users"];
    NSDictionary *user = [users objectAtIndex:[indexPath row]];
    cell.usernameLabel.text = [user objectForKey:@"displayName"];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && self.eventViewState == CREATE) {
        if (indexPath.row == 0){
            _isStartDateSelected = YES;
            _isDateSelected = YES;
        }
        else if(indexPath.row ==1 && _isDateSelected == NO) {
            _isStartDateSelected = NO;
            _isDateSelected = YES;
        } else if (indexPath.row == 2 && _isDateSelected && _isStartDateSelected){
            _isStartDateSelected = NO;
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
        NSDate *endDate = [DateHelper convertDateFromString: [self.currentEvent objectForKey:@"endTime"]];
        if ([endDate compare:datePicker.date] == NSOrderedAscending){
            [self.currentEvent setValue:[self.currentEvent objectForKey:@"startTime"] forKey:@"endTime"];
        }
    } else {
        [self.currentEvent setValue:[DateHelper convertStringFromDate:datePicker.date] forKey:@"endTime"];
    }
    [self.tableView reloadData];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIPickerDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"row - %d",(int)row);
    int numberOfMinutes = (int)(row +1) *5;
    NSDate *startDate = [DateHelper convertDateFromString:[self.currentEvent objectForKey:@"startTime"]];
    NSDate *date = [startDate dateByAddingTimeInterval:numberOfMinutes * 60];
    [self.currentEvent setValue:[DateHelper convertStringFromDate:date] forKey:@"endTime"];
    [self.tableView reloadData];
}

#pragma mark UIPickerDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSNumber *maxTime = [self.currentResource objectForKey:@"maxTime"];
    NSNumber *minTime = [self.currentResource objectForKey:@"minTime"];
    return (([maxTime integerValue] - [minTime integerValue]))/5 +1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.bounds.size.width, 37)];
    if (component == 0) {
        label.font=[UIFont boldSystemFontOfSize:22];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        int minTime = [[self.currentResource objectForKey:@"minTime"] intValue];
        label.text = [NSString stringWithFormat:@"%d Minutes", minTime + ((int)(row) * 5)];
        label.font=[UIFont boldSystemFontOfSize:22];
    }
    return label;

}

@end
