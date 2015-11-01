//
//  EventsTableViewController.h
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *eventsArray;
}


@end
