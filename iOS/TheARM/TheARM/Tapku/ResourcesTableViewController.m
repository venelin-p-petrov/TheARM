//
//  ResourcesTableViewController.m
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "ResourcesTableViewController.h"
#import "ResourceViewCell.h"
#import "AFNetWorking.h"
#import "DataManager.h"
#import "DayViewController.h"
#import <UIImageView+AFNetworking.h>
#import "RestManager.h"
#import "AppDelegate.h"

@interface ResourcesTableViewController ()

@end

@implementation ResourcesTableViewController{
    NSArray *tableData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    //self.tableView.contentInset = UIEdgeInsetsMake(64,0,0,0);
    resourcesArray = [NSArray new];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadResources];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void) loadResources{
    DataManager *dataManger = [DataManager sharedDataManager];
    [dataManger getResourcesWithCompanyId:@"1" onSuccess:^(NSObject *responseObject) {
       resourcesArray = (NSArray*) responseObject;
        [self.tableView reloadData];
        [self performSelector:@selector(loadResources) withObject:nil afterDelay:10.0];
        
    } onError:^(NSError *error) {
        [self performSelector:@selector(loadResources) withObject:nil afterDelay:10.0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resourcesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResourceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResourceViewCell" forIndexPath:indexPath];
    NSDictionary *dictionary = [resourcesArray objectAtIndex:indexPath.row];
    
    cell.name.text = [dictionary objectForKey:@"name"];
    NSString *imagePath = [dictionary objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:imagePath];
    [cell.imageUrl setImageWithURL:url placeholderImage:[UIImage imageNamed:@"entertaiment_image.jpg"]];
    cell.tag = indexPath.row;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSInteger row = ((ResourceViewCell *)sender).tag;
    NSDictionary *dictionary = [resourcesArray objectAtIndex:row];
    NSLog(@"Selected row %ld %@", (long)row, dictionary );
    DayViewController *viewController = (DayViewController *)segue.destinationViewController;
    viewController.resource = dictionary;
}

@end
