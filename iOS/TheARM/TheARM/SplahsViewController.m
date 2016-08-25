//
//  SplahsViewController.m
//  TheARM
//
//  Created by Mihail Karev on 8/25/16.
//  Copyright © 2016 Accedia. All rights reserved.
//

#import "SplahsViewController.h"
#import <AFNetworking.h>
#import "AppDelegate.h"

@implementation SplahsViewController


-(void)viewDidLoad {
    [super viewDidLoad];
     [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self performSelector:@selector(startTheARM) withObject:nil afterDelay:0.5];
}



- (void) startTheARM {
    if ([self internetCheck]){
        NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
        NSString *userToken = [userDefults objectForKey:@"userToken"];
        UIViewController *viewController = nil;
        if (userToken != nil && ![userToken isEqualToString:@""]){
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
        } else {
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogingNavCotroller"];
        }
        
        AppDelegate *delaget = [[UIApplication sharedApplication] delegate];
        delaget.window.rootViewController = viewController;
        [delaget.window makeKeyAndVisible];
    }
}


- (BOOL) internetCheck {
    if([AFNetworkReachabilityManager sharedManager].reachable) {
        
        return YES;
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Please, turn on your internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self startTheARM];
}

@end
