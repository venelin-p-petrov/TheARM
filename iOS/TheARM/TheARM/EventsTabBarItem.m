//
//  ARTTabBar.m
//  TheARM
//
//  Created by Mihail Karev on 7/20/16.
//  Copyright © 2016 Accedia. All rights reserved.
//

#import "EventsTabBarItem.h"

@implementation EventsTabBarItem

-(void)awakeFromNib{
     self.image = [[UIImage imageNamed:@"events-not-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.selectedImage = [[UIImage imageNamed:@"events-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
