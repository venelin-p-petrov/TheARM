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
#import <UIImageView+AFNetworking.h>
#import "AppDelegate.h"

@implementation ResourceCell

@end

@implementation DescriptionCell
@end

@implementation UserCell
@end

@implementation FooterCell
@end

@implementation DatePickerCell

@end

@implementation DateCell
@end

@implementation PickerCell
@end

@interface EventDetailVIewController()
@property(weak, nonatomic) UIButton *actionButton;

@end

@implementation EventDetailVIewController

@synthesize currentEvent,currentResource;

-(void)viewDidLoad{
    [super viewDidLoad];
    _isDateSelected = NO;
    _isDurationSelected = NO;
    _isDatePickerLoaded = NO;
    //  self.tableView.separatorColor = [UIColor clearColor];
    if (self.eventViewState == CREATE) {
        DataManager *dataManager = [DataManager sharedDataManager];
        NSNumber *userId= [dataManager.user objectForKey:@"userId"];
        NSNumber *minUsers = [self.currentResource objectForKey:@"minUsers"];
        [self.currentEvent setValue:minUsers forKey:@"minUsers"];
        [self.currentEvent setValue:minUsers forKey:@"maxUsers"];
        [self.currentEvent setValue:userId forKey:@"ownerId"];
        [self.currentEvent setValue:@"" forKey:@"description"];
        [self.currentEvent setValue:[self.currentResource objectForKey:@"resourceId"] forKey:@"resourceId"];
        
        NSDate *startDate = [NSDate new];
        int minTime = [[self.currentResource objectForKey:@"minTime"] intValue];
        NSDate *endDate = [startDate dateByAddingTimeInterval:minTime * 60];
        [self.currentEvent setValue:[DateHelper convertStringFromDate:startDate] forKey:@"startTime"];
        [self.currentEvent setValue:[DateHelper convertStringFromDate:endDate] forKey:@"endTime"];
        
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *delagete = [[UIApplication sharedApplication] delegate];
    [delagete.rootViewController setNavigationBarHidden:YES];
    self.navigationController.navigationBar.backItem.title = @"";
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    NSArray<UINavigationItem*>  *items = bar.items;
    for (UINavigationItem *item in items){
        item.backBarButtonItem.title = @"";
        item.title = @"";
    }
}

- (IBAction)actionButtonClicked:(id)sender {
    UIButton *button = (UIButton *) sender;
    [button setEnabled:NO];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [dataManager doDelete:[self.currentEvent objectForKey:@"eventId"] andUserId:[dataManager.user objectForKey:@"userId"] onSuccess:^(NSObject *responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successfuly deleted event" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } onError:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [self.actionButton setEnabled:YES];
        }];
    });
}

- (void) leaveEvent{
    DataManager *dataManager = [DataManager sharedDataManager];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSDictionary *requestBody = [NSDictionary dictionaryWithObjectsAndKeys:[dataManager.user objectForKey:@"userId"],@"userId",[self.currentEvent objectForKey:@"eventId"],@"eventId", nil];
        [dataManager doLeaveEvent:requestBody onSuccess:^(NSObject *responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successfuly left the event" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } onError:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [self.actionButton setEnabled:YES];
        }];
    });
}

- (void) joinEvent{
    DataManager *dataManager = [DataManager sharedDataManager];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSDictionary *requestBody = [NSDictionary dictionaryWithObjectsAndKeys:[dataManager.user objectForKey:@"userId"],@"userId",[self.currentEvent objectForKey:@"eventId"],@"eventId", nil];
        [dataManager doJoinEvent:requestBody onSuccess:^(NSObject *responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successfuly joined to the event" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } onError:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [self.actionButton setEnabled:YES];
        }];
    });
}
- (void) createEvent{
    DataManager *dataManager = [DataManager sharedDataManager];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [dataManager doCreateEvent:self.currentEvent onSuccess:^(NSObject *responseObject) {
            NSDictionary *response = (NSDictionary *)responseObject;
            UIAlertView *alertView = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            if ([[response objectForKey:@"status"] isEqualToString:@"failed"]){
                alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            } else {
                alertView = [[UIAlertView alloc] initWithTitle:@"Event is created" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            [self.actionButton setEnabled:YES];
            [alertView show];
        } onError:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please, try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [self.actionButton setEnabled:YES];
        }];
    });
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int index = 0;
    if (self.eventViewState == CREATE){
        index = 1;
    }
    if (_isDateSelected || _isDurationSelected || _isParticipientsSelected){
        return 4 + index;
    } else {
        return 3 + index;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 84;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 140;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"SectionHeader";
    ResourceCell *headerView = (ResourceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    NSString *imagePath = [self.currentResource objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:imagePath];
    [headerView.resourceImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"entertaiment_image.jpg"]];
    
    if (self.eventViewState == CREATE){
        headerView.resourceLabel.text = [self.currentResource objectForKey:@"name"];
    } else {
        headerView.resourceLabel.text = [self.currentEvent objectForKey:@"description"];
    }
    return headerView;
}


-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"SectionFooter";
    FooterCell *footerView = (FooterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (footerView == nil){
        [NSException raise:@"footerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    
    if (self.eventViewState == CREATE) {
        [footerView.actionButton setTitle:@"Create Event" forState:UIControlStateNormal];
    } else if (self.eventViewState == EDIT){
        [footerView.actionButton setTitle:@"Delete Event" forState:UIControlStateNormal];
    } else if (self.eventViewState == JOIN){
        [footerView.actionButton setTitle:@"Join Event" forState:UIControlStateNormal];
    } else if(self.eventViewState == LEAVE) {
        [footerView.actionButton setTitle:@"Leave Event" forState:UIControlStateNormal];
    }
    
    [footerView.actionButton  addTarget:self
                                 action:@selector(actionButtonClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
    self.actionButton = footerView.actionButton;
    return footerView;
}


//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 2){
//        NSArray *users = [self.currentEvent objectForKey:@"users"];
//       return [NSString stringWithFormat:@"Participients - (%tu/%@)",[users count], [self.currentEvent objectForKey:@"usersCount"]];
//    }
//    return @"";
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isDateSelected) {
        if ((self.eventViewState != CREATE && indexPath.row == 1) || (self.eventViewState == CREATE && indexPath.row == 2) ){
            return 216;
        }
    } else if (_isDurationSelected) {
        if ((self.eventViewState != CREATE && indexPath.row == 2) || (self.eventViewState == CREATE && indexPath.row == 3) ){
            return 216;
        }
    } else if (_isParticipientsSelected){
        if ((self.eventViewState != CREATE && indexPath.row == 3) || (self.eventViewState == CREATE && indexPath.row == 4) ){
            return 216;
        }
    } else if (self.eventViewState != CREATE && indexPath.row == 2){
        return 216;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = 0;
    if (self.eventViewState == CREATE) {
        index = 1;
    }
    
    if (indexPath.row == 0 && self.eventViewState == CREATE){
        return [self descriptionCellFor:tableView cellForRowAtIndexPath:indexPath];
    } else if (indexPath.row == 0 + index){
        return [self starDateCellFor:tableView atIndexPath:indexPath];
    } else if(indexPath.row == 1 + index && _isDateSelected) {
        return [self tableView:tableView generateDatePickerCellForIndexPath:indexPath];
    } else if((indexPath.row == 1 + index && !_isDateSelected) || (indexPath.row == 2 + index && _isDateSelected)  ) {
        return [self durationCellFor:tableView atIndexPath:indexPath];
    } else if(_isDurationSelected && indexPath.row == 2 + index) {
        return [self tableView:tableView generatePickerCellForIndexPath:indexPath];
    } else if(self.eventViewState == CREATE && ((indexPath.row == 3 + index && (_isDurationSelected || _isDateSelected)) || (indexPath.row == 2 + index && (!_isDurationSelected && !_isDateSelected)))) {
        return [self participientsCellFor:tableView atIndexPath:indexPath];
    } else if(self.eventViewState != CREATE && ((indexPath.row == 3 + index && (_isDurationSelected || _isDateSelected)) || (indexPath.row == 2 + index && (!_isDurationSelected && !_isDateSelected)))) {
        return [self userCellFor:tableView atIndexPath:indexPath];
    } else if(indexPath.row == 3 + index  && _isParticipientsSelected) {
        return [self tableView:tableView generatePickerCellForIndexPath:indexPath];
    } else {
        return [self durationCellFor:tableView atIndexPath:indexPath];
    }
    
}

-(UITableViewCell *)descriptionCellFor:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell" forIndexPath:indexPath];
    
    
    [cell.descriptionTextField addTarget:self
                                  action:@selector(textFieldDidChange:)
                        forControlEvents:UIControlEventEditingChanged];
    
    NSString *description = [self.currentEvent objectForKey:@"description"];
    cell.descriptionTextField.text = description;
    
    if (self.eventViewState == CREATE){
        cell.descriptionTextField.enabled = YES;
    } else {
        cell.descriptionTextField.enabled = NO;
    }
    return cell;
}


-(UITableViewCell *) starDateCellFor:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
    cell.cellInfoLabel.text = @"Start Date";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *startDate = [DateHelper convertDateFromString:[self.currentEvent objectForKey:@"startTime"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:startDate]];
    
    if (_isDateSelected){
        cell.dateLabel.textColor = [UIColor colorWithRed:(205/255.f) green:(32/255.f) blue:(38/255.f) alpha:1.0];
        cell.cellInfoLabel.textColor = [UIColor colorWithRed:(205/255.f) green:(32/255.f) blue:(38/255.f) alpha:1.0];
    } else {
        cell.dateLabel.textColor = [UIColor blackColor];
        cell.cellInfoLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

-(UITableViewCell *) durationCellFor :(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
    cell.cellInfoLabel.text = @"Duration";
    
    NSDate *startDate = [DateHelper convertDateFromString:[self.currentEvent objectForKey:@"startTime"]];
    NSDate *endDate = [DateHelper convertDateFromString:[self.currentEvent objectForKey:@"endTime"]];
    if (startDate && endDate){
        NSTimeInterval secondsBetween = [endDate timeIntervalSinceDate:startDate];
        cell.dateLabel.text = [NSString stringWithFormat:@"%d Minutes",(int)secondsBetween/60];
    }
    
    
    if (_isDurationSelected){
        cell.dateLabel.textColor = [UIColor colorWithRed:(205/255.f) green:(32/255.f) blue:(38/255.f) alpha:1.0];
        cell.cellInfoLabel.textColor = [UIColor colorWithRed:(205/255.f) green:(32/255.f) blue:(38/255.f) alpha:1.0];
    } else {
        cell.dateLabel.textColor = [UIColor blackColor];
        cell.cellInfoLabel.textColor = [UIColor blackColor];
    }
    return cell;
}


-(UITableViewCell *) participientsCellFor :(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
    cell.cellInfoLabel.text = @"Participants";
    
    NSNumber *minUsers = [self.currentEvent objectForKey:@"maxUsers"];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%d", [minUsers intValue]];
    
    
    if (_isParticipientsSelected){
        cell.dateLabel.textColor = [UIColor colorWithRed:(205/255.f) green:(32/255.f) blue:(38/255.f) alpha:1.0];
        cell.cellInfoLabel.textColor = [UIColor colorWithRed:(205/255.f) green:(32/255.f) blue:(38/255.f) alpha:1.0];
    } else {
        cell.dateLabel.textColor = [UIColor blackColor];
        cell.cellInfoLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

-(UITableViewCell *) userCellFor :(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    NSArray *users = [currentEvent objectForKey:@"users"];
    cell.participientsNumberLabel.text = [NSString stringWithFormat:@"%tu/%d",[users count], [[currentEvent objectForKey:@"maxUsers"] intValue]];
    NSString *displayNames = @"";
    for (NSDictionary *user in users){
        NSString *nameWithEndLine = [NSString stringWithFormat:@"%@\n",[user objectForKey:@"displayName"]];
        displayNames = [displayNames stringByAppendingString:nameWithEndLine];
    }
    cell.participientsListTextView.text = displayNames;
    cell.participientsListTextView.editable = NO;
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *) tableView generateDatePickerCellForIndexPath:(NSIndexPath *) indexPath{
    DatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell" forIndexPath:indexPath];
    if (!_isDatePickerLoaded){
        [cell.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        _isDatePickerLoaded = YES;
    }
    NSDate *date = [DateHelper convertDateFromString: [self.currentEvent objectForKey:@"startTime"]];
    [cell.datePicker setDate:date];
    return cell;
}

- (UITableViewCell *) tableView:(UITableView *) tableView generatePickerCellForIndexPath:(NSIndexPath *) indexPath{
    PickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PickerCell" forIndexPath:indexPath];
    cell.customPicker.dataSource = self;
    cell.customPicker.delegate = self;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL previousDateSelected = _isDateSelected;
    BOOL previousDurationSelected = _isDurationSelected;
    BOOL previousParticipentSelcted = _isParticipientsSelected;
    _isDateSelected = NO;
    _isDurationSelected = NO;
    _isParticipientsSelected = NO;
    
    if (self.eventViewState != CREATE){
        return;
    }
    int index = 0;
    if (self.eventViewState == CREATE) {
        index = 1;
    }
    if (indexPath.row == 0 + index ){
        _isDateSelected = !previousDateSelected;
    } else {
        if (previousDateSelected) {
            index++;
        }
        if (indexPath.row == 1 + index) {
            _isDurationSelected = !previousDurationSelected;
        } else {
            if (previousDurationSelected) {
                index++;
            }
            if (indexPath.row == 2 + index) {
                _isParticipientsSelected = !previousParticipentSelcted;
            }
        }
    }
    [tableView reloadData];
}

#pragma mark UITextViewDelgate implementation

- (void)textFieldDidChange:(id)sender {
    UITextField *descriptionTextField =  (UITextField *) sender;
    [self.currentEvent setValue:descriptionTextField.text forKey:@"description"];
    
}

#pragma mark UIDatePicker
- (void)dateChanged:(id)sender{
    NSLog(@"Date changed");
    UIDatePicker *datePicker = (UIDatePicker *) sender;
    if (_isDateSelected) {
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
    
    if (_isDurationSelected) {
        int minTime = [[self.currentResource objectForKey:@"minTime"] intValue];
        int numberOfMinutes =  minTime + ((int)(row) * 5);
        NSDate *startDate = [DateHelper convertDateFromString:[self.currentEvent objectForKey:@"startTime"]];
        NSDate *date = [startDate dateByAddingTimeInterval:numberOfMinutes * 60];
        [self.currentEvent setValue:[DateHelper convertStringFromDate:date] forKey:@"endTime"];
    } else {
        int minUsers = [[self.currentResource objectForKey:@"minUsers"] intValue];
        NSNumber *numberOfUsers = [NSNumber numberWithInteger:minUsers + (int)(row)];
        [self.currentEvent setValue:numberOfUsers forKey:@"minUsers"];
        [self.currentEvent setValue:numberOfUsers forKey:@"maxUsers"];
    }
    [self.tableView reloadData];
    
}

#pragma mark UIPickerDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_isDurationSelected) {
        NSNumber *maxTime = [self.currentResource objectForKey:@"maxTime"];
        NSNumber *minTime = [self.currentResource objectForKey:@"minTime"];
        return (([maxTime integerValue] - [minTime integerValue]))/5 +1;
    } else {
        NSNumber *maxUsers = [self.currentResource objectForKey:@"maxUsers"];
        NSNumber *minUsers = [self.currentResource objectForKey:@"minUsers"];
        return [maxUsers integerValue] - [minUsers integerValue] +1;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.bounds.size.width, 37)];
    if (component == 0) {
        label.font=[UIFont boldSystemFontOfSize:22];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font=[UIFont boldSystemFontOfSize:22];
        if (_isDurationSelected) {
            int minTime = [[self.currentResource objectForKey:@"minTime"] intValue];
            label.text = [NSString stringWithFormat:@"%d Minutes", minTime + ((int)(row) * 5)];
        } else {
            int minUsers = [[self.currentResource objectForKey:@"minUsers"] intValue];
            label.text = [NSString stringWithFormat:@"%d Participants", minUsers + (int)(row)];
        }
    }
    return label;
    
}

@end
