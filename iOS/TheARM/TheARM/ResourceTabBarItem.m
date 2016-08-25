//
//  ResourceTabBarItem.m
//  TheARM
//
//  Created by Mihail Karev on 7/20/16.
//  Copyright © 2016 Accedia. All rights reserved.
//

#import "ResourceTabBarItem.h"

@implementation ResourceTabBarItem

-(void)awakeFromNib{
    self.image = [[UIImage imageNamed:@"resources-not-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.selectedImage = [[UIImage imageNamed:@"resources-active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
