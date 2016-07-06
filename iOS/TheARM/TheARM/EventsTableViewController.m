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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadEvents];
}

-(void)loadEvents{
    DataManager *dataManager = [DataManager sharedDataManager];
    [dataManager getEventsWithCompanyId:@"1" onSuccess:^(NSObject *responseObject) {
        eventsArray = (NSArray*) responseObject;
        [self.tableView reloadData];
         [self performSelector:@selector(loadEvents) withObject:nil afterDelay:10.0];
    
    } onError:^(NSError *error) {
         [self performSelector:@selector(loadEvents) withObject:nil afterDelay:10.0];
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
    //Miai e bot xaxa
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
- (IBAction)logout:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"userPassword"];
    [userDefaults removeObjectForKey:@"userToken"];
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogingNavCotroller"];
    AppDelegate *delaget = [[UIApplication sharedApplication] delegate];
    delaget.window.rootViewController = viewController;
    [delaget.window makeKeyAndVisible];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([@"ShowEventSegue" isEqualToString:segue.identifier]){
        EventDetailVIewController *destinationController = (EventDetailVIewController *)segue.destinationViewController;
        [destinationController setCurrentEvent:[NSMutableDictionary dictionaryWithDictionary:lastSelectedEvent]];
        DataManager *dataManager = [DataManager sharedDataManager];
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
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super viewWillDisappear:animated];
}

@end
