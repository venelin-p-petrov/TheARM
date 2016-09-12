//
//  MenuViewController.m
//  TheARM
//
//  Created by Mihail Karev on 8/23/16.
//  Copyright © 2016 Accedia. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"

@implementation MenuViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefults objectForKey:@"username"];
    NSString *displayName = [userDefults objectForKey:@"displayName"];
    self.usernameLabel.text = username;
    self.displayNameLabel.text = displayName;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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

@end
