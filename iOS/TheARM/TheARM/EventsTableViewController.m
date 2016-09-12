//
//  EventsTableViewController.m
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "EventsTableViewController.h"
#import "EventCellView.h"
#import "EventDetailVIewController.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "ResourcesTableViewController.h"
#import "DateHelper.h"
#import <UIImageView+AFNetworking.h>
#import "MenuViewController.h"


@interface EventsTableViewController ()<ResourceTableDelegate>

@end

@implementation EventsTableViewController{
    NSArray *tableData;
    NSDictionary *lastSelectedEvent;
    UITableViewCell *headerView;
    NSDictionary *selectedResource;
    ResourcesTableViewController *resourcePopover;
    DataManager *dataManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    dataManager = [DataManager sharedDataManager];
    
    eventsArray = [NSArray new];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:168.0/256.0 green:168.0/256.0 blue:168.0/256.0 alpha:1.0]];
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *delagete = [[UIApplication sharedApplication] delegate];
    [delagete.rootViewController setNavigationBarHidden:NO];
    [self loadEvents];
}

-(void)loadEvents{
    if (dataManager.resources && [dataManager.resources count] > 0) {
        [dataManager getEventsWithCompanyId:@"1" onSuccess:^(NSObject *responseObject) {
            eventsArray = (NSArray*) responseObject;
            [self.tableView reloadData];
            [self performSelector:@selector(loadEvents) withObject:nil afterDelay:10.0];
        
        } onError:^(NSError *error) {
            [self performSelector:@selector(loadEvents) withObject:nil afterDelay:10.0];
        }];
    } else {
        [dataManager getResourcesWithCompanyId:@"1" onSuccess:^(NSObject *responseObject) {
            [self loadEvents];
            
        } onError:^(NSError *error) {
            [self loadEvents];
        }];

    }
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
    
    cell.dateLabel.text = [self generateTimeLabelForEvent:dictionary];
    
    cell.numberOfPeople.text = [self generateParticipientsLabelForEvent:dictionary];
    NSDictionary *owner = [dictionary objectForKey:@"owner"];
    cell.ownerLabel.text = [owner objectForKey:@"displayName"];
    
    NSArray *resourceArray = [dataManager resources];
    if  (resourceArray && [resourceArray count] > 0) {
        NSNumber *resourceId = [dictionary objectForKey:@"resource_resourceId"];
        for (NSDictionary *resource in resourceArray){
            if ([resourceId isEqual: [resource objectForKey:@"resourceId"]]){
                NSString *imagePath = [resource objectForKey:@"image"];
                NSURL *url = [NSURL URLWithString:imagePath];
                [cell.resourceImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"entertaiment_image.jpg"]];
            }
        }
    }
    return cell;
}
- (NSString *)generateParticipientsLabelForEvent:(NSDictionary *) event {
    NSArray *users = [event objectForKey:@"users"];
    
    
    return [NSString stringWithFormat:@"Joined: %tu/%d",[users count],[[event objectForKey:@"maxUsers"] intValue]];
    
}

- (NSString *)generateTimeLabelForEvent:(NSDictionary *) event {
    NSDate *endDate = [DateHelper convertDateFromString:[event objectForKey:@"endTime"]];
    NSDate *startDate = [DateHelper convertDateFromString:[event objectForKey:@"startTime"]];
    NSString *startHours = [DateHelper convertStringHoursMinutesFromDate:startDate];
    
    NSString *endHours = [DateHelper convertStringHoursMinutesFromDate:endDate];
    
    return [NSString stringWithFormat:@"Time: %@ - %@", startHours, endHours];
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"SectionHeader";
    headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    lastSelectedEvent = [eventsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowEventSegue" sender:self];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([@"ShowEventSegue" isEqualToString:segue.identifier]){
        EventDetailVIewController *destinationController = (EventDetailVIewController *)segue.destinationViewController;
        [destinationController setCurrentEvent:[NSMutableDictionary dictionaryWithDictionary:lastSelectedEvent]];
        NSArray *resourceArray = [dataManager resources];
        NSNumber *resourceId = [lastSelectedEvent objectForKey:@"resource_resourceId"];
        for (NSDictionary *resource in resourceArray){
            if ([resourceId isEqual: [resource objectForKey:@"resourceId"]]){
                [destinationController setCurrentResource:resource];
                break;
            }
        }
        NSDictionary *ownerDictionary = [lastSelectedEvent objectForKey:@"owner"];
        NSNumber *userId = [dataManager.user objectForKey:@"userId"];
        if ([userId isEqual:[ownerDictionary objectForKey:@"userId"]]){
            [destinationController setEventViewState:EDIT];
        } else {
            NSArray *users = [lastSelectedEvent objectForKey:@"users"];
            [destinationController setEventViewState:JOIN];
            for (NSDictionary *user in users){
                if ([userId isEqual:[user objectForKey:@"userId"]]){
                    [destinationController setEventViewState:LEAVE];
                    break;
                }
            }
        }
    } else if ([segue.identifier isEqualToString:@"SelectResourcePopover"]) {
        resourcePopover = (ResourcesTableViewController *)segue.destinationViewController;
        UIPopoverPresentationController *controller = resourcePopover.popoverPresentationController;
        if (controller) {
            controller.sourceView = headerView;
            controller.sourceRect = headerView.frame;
            controller.delegate = self;
            
            resourcePopover.resourceDelegate = self;
            
        }
    } else if ([@"CreateEventSegue" isEqualToString:segue.identifier]){
        EventDetailVIewController *viewController = (EventDetailVIewController *) segue.destinationViewController;
        [viewController setCurrentResource:selectedResource];
        [viewController setCurrentEvent:[NSMutableDictionary dictionaryWithObjectsAndKeys:[DateHelper convertStringFromDate:[NSDate new]],@"startTime",[DateHelper convertStringFromDate:[NSDate new]], @"endTime", nil]];
        [viewController setEventViewState:CREATE];
    }
}
- (IBAction)createNewEvent:(id)sender {
    [self performSegueWithIdentifier:@"SelectResourcePopover" sender:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super viewWillDisappear:animated];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

#pragma mark - ResourceTableDelegate

-(void)didSelectResource:(NSDictionary *)resource {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    selectedResource =  resource;
    [resourcePopover dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"CreateEventSegue" sender:self];
    }];
    
}

@end
