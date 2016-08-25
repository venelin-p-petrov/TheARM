//
//  LoginViewController.m
//  TheARM
//
//  Created by Mihail Karev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "LoginViewController.h"
#import "DataManager.h"
#import "EventViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "LoginTableViewController.h"

@interface LoginViewController ()
    @property LoginTableViewController *tableView;
    @property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.loginButton setEnabled:YES];
}

- (IBAction)clickLogin:(id)sender {
    [self.loginButton setEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
    DataManager *dataManager = [DataManager sharedDataManager];
    [dataManager doLoginWithUsername:self.tableView.usernameTextField.text password:self.tableView.passwordTextField.text onSuccess:^(NSObject *responseObject) {
        NSLog(@"Success");

    
        NSDictionary *responseDictionary =  (NSDictionary*)responseObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if ([@"success" isEqualToString:[responseDictionary objectForKey:@"status"]]){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.tableView.passwordTextField.text forKey:@"userPassword"];
            [userDefaults setObject:self.tableView.usernameTextField.text forKey:@"userToken"];
            [userDefaults setObject:[responseDictionary objectForKey:@"userId"] forKey:@"userID"];
            [userDefaults setObject:[responseDictionary objectForKey:@"displayName"] forKey:@"displayName"];
            [userDefaults setObject:self.tableView.usernameTextField.text forKey:@"username"];
            [dataManager getResourcesWithCompanyId:@"1" onSuccess:^(NSObject *responseObject) {
                [self openNextFlowOfTheApplication];
            } onError:^(NSError *error) {
                [self openNextFlowOfTheApplication];
            }];
            
   
        } else {
            [self showAlerWithString:@"Wrong username or password"];
            [self.loginButton setEnabled:YES];
        }
        
    } onError:^(NSError *error) {
        NSLog(@"ERROR --- ");
        [self showAlerWithString:[error description]];
        [self.loginButton setEnabled:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
    });
}

- (void) openNextFlowOfTheApplication{
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"];
    AppDelegate *delaget = [[UIApplication sharedApplication] delegate];
    delaget.window.rootViewController = viewController;
    [delaget.window makeKeyAndVisible];

}

-(void) showAlerWithString:(NSString *) alertMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"LoginContainerSegue"]) {
        self.tableView = (LoginTableViewController *) [segue destinationViewController];
    }
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


@end
