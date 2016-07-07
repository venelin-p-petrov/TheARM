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
#import "RestManager.h"
#import "DayViewController.h"

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
    [self loadEvents];
}

-(void) loadEvents{
    
    [RestManager getResourcesWithCompanyId:@"1" onSuccess:^(NSObject *responseObject) {
       resourcesArray = (NSArray*) responseObject;
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
    return [resourcesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResourceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResourceViewCell" forIndexPath:indexPath];
    NSDictionary *dictionary = [resourcesArray objectAtIndex:indexPath.row];
    
    cell.name.text = [dictionary objectForKey:@"name"];
//    [cell.imageUrl setImageWithURLRequest:[dictionary objectForKey:@"image"] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//        cell.imageUrl.image = image;
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        NSLog(@"Error %@", error.description);
//    }];
    [cell.imageUrl setImage:[UIImage imageNamed: @"xbox-one2.jpg"]];
    cell.tag = indexPath.row;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSInteger row = ((ResourceViewCell *)sender).tag;
    NSDictionary *dictionary = [resourcesArray objectAtIndex:row];
    NSLog(@"Selected row %ld %@", (long)row, dictionary );
    DayViewController *viewController = (DayViewController *)segue.destinationViewController;
    viewController.resource = dictionary;
}

@end
