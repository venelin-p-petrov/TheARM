//
//  EventsTableViewController.h
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SlideNavigationController.h>

@interface EventsTableViewController : UITableViewController<SlideNavigationControllerDelegate, UIPopoverPresentationControllerDelegate,UITableViewDataSource, UITableViewDelegate>
{
    NSArray *eventsArray;
}


@end
