//
//  EventsTableViewController.m
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "EventsTableViewController.h"
#import "EventCellView.h"
#import "RestManager.h"
#import "EventViewController.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController{
    NSArray *tableData;
    NSDictionary *lastSelectedEvent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    eventsArray = [NSArray new];
    [self loadEvents];
}


-(void)loadEvents{
    [RestManager getEventsWithCompanyId:@"1" onSuccess:^(NSObject *responseObject) {
        eventsArray = (NSArray*) responseObject;
        [self.tableView reloadData];
    } onError:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [eventsArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    NSDictionary *dictionary = [eventsArray objectAtIndex:indexPath.row];
    cell.descriptionLabel.text = [dictionary objectForKey:@"description"];
        cell.dateLabel.text = [dictionary objectForKey:@"date"];
        cell.numberOfPeople.text = [dictionary objectForKey:@"numberOfPeople"];
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    lastSelectedEvent = [eventsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowEventSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([@"ShowEventSegue" isEqualToString:segue.identifier]){
        EventViewController *destinationController = (EventViewController *)segue.destinationViewController;
        [destinationController setCurrentEvent:lastSelectedEvent];
    }
}

@end
