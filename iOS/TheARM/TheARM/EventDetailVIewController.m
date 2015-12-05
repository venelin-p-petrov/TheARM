//
//  EventDetailVIewController.m
//  TheARM
//
//  Created by Mihail Karev on 12/2/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "EventDetailVIewController.h"

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
        cell.descriptionTextField.text = @"Add description here";
        return cell;

    }
}



-(UITableViewCell *) secondSectionInEvent:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
        cell.cellInfoLabel.text = @"Start Date";
        cell.dateLabel.text = @"22 November 2015 15:30";
        return cell;
    } else if (_isDateSelected && ((_isStartDateSelected && indexPath.row == 1) || (!_isStartDateSelected && indexPath.row==2)) ){
            DatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell" forIndexPath:indexPath];
            return cell;
        
    } else {
        DateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DateCell" forIndexPath:indexPath];
        cell.cellInfoLabel.text = @"End Date";
        cell.dateLabel.text = @"22 November 2015 16:30";
        return cell;

    }
}

-(UITableViewCell *) userSectionInEvent:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    cell.usernameLabel.text = @"User Userov";
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        if (indexPath.row == 0){
            _isStartDateSelected = YES;
            _isDateSelected = YES;
        }
        else if (_isDateSelected && ((_isStartDateSelected && indexPath.row == 1) || (!_isStartDateSelected && indexPath.row==2)) ){
        
        } else {
            _isStartDateSelected = NO;
            _isDateSelected = YES;
        
        }
    } else {
        _isStartDateSelected = NO;
        _isDateSelected = NO;
    }
    [tableView reloadData];
}

@end
