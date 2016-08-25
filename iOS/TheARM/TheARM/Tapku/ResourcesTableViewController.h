//
//  ResourcesTableViewController.h
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@protocol ResourceTableDelegate <NSObject>

-(void) didSelectResource:(NSDictionary *) resource;

@end

@interface ResourcesTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *resourcesArray;
}

@property id<ResourceTableDelegate> resourceDelegate;

@end
