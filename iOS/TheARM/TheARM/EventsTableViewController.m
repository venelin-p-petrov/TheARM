//
//  EventsTableViewController.m
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "EventsTableViewController.h"
#import "EventCellView.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController{
    NSArray *tableData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64,0,0,0);
    
    [self loadEvents];
}


-(void)loadEvents{
    eventsArray = [NSMutableArray arrayWithObjects:
                    @{@"description": @"CS ARM", @"date": @"14:21", @"numberOfPeople":@"1/4"},
                   @{@"description": @"Fifa ", @"date": @"15:30", @"numberOfPeople":@"1/2"},
                   @{@"description": @"Tenis masa", @"date": @"12:01", @"numberOfPeople":@"1/10"}, nil];
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

@end
