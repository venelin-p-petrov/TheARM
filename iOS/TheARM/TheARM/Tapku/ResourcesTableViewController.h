//
//  ResourcesTableViewController.h
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourcesTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *resourcesArray;
}

@end
