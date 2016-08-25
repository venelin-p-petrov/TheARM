//
//  SideViewController.m
//  TheARM
//
//  Created by Mihail Karev on 8/24/16.
//  Copyright © 2016 Accedia. All rights reserved.
//

#import "SideViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"

@interface SideViewController()

@property (strong, nonatomic) MenuViewController *leftViewController;

@end

@implementation SideViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    MenuViewController *menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    [SlideNavigationController sharedInstance].leftMenu =   menuController ;
    AppDelegate *delaget = [[UIApplication sharedApplication] delegate];
    delaget.rootViewController = self.navigationController;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:168.0/256.0 green:168.0/256.0 blue:168.0/256.0 alpha:1.0]];
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
