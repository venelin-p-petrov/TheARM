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

@interface LoginViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *username;
    @property (weak, nonatomic) IBOutlet UITextField *pasword;
    @property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.username.leftViewMode = UITextFieldViewModeAlways;
    self.username.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user.png"]];
     
    [self.username.leftView setFrame:CGRectMake(self.username.frame.origin.x, self.username.frame.origin.y, 40, 40)];
    
    self.pasword.leftViewMode = UITextFieldViewModeAlways;
    self.pasword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock.png"]];
    
    [self.pasword.leftView setFrame:CGRectMake(self.username.frame.origin.x, self.username.frame.origin.y, 40, 40)];
    
    
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *userToken = [userDefults objectForKey:@"userToken"];
    if (userToken != nil && ![userToken isEqualToString:@""]){

        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        AppDelegate *delaget = [[UIApplication sharedApplication] delegate];
        delaget.window.rootViewController = viewController;
        [delaget.window makeKeyAndVisible];

    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.loginButton setEnabled:YES];
}

- (IBAction)clickLogin:(id)sender {
    [self.loginButton setEnabled:NO];
    NSLog(@"Username %@", self.username.text);
    NSLog(@"Password %@", self.pasword.text);

    DataManager *dataManager = [DataManager sharedDataManager];
    [dataManager doLoginWithUsername:self.username.text password:self.pasword.text onSuccess:^(NSObject *responseObject) {
        NSLog(@"Success");

    
        NSDictionary *responseDictionary =  (NSDictionary*)responseObject;

        if ([@"success" isEqualToString:[responseDictionary objectForKey:@"status"]]){
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:self.pasword.text forKey:@"userPassword"];
            [userDefaults setObject:self.username.text forKey:@"userToken"];

            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
            AppDelegate *delaget = [[UIApplication sharedApplication] delegate];
            delaget.window.rootViewController = viewController;
            [delaget.window makeKeyAndVisible];
   
        } else {
            [self showAlerWithString:@"Wrong username or password"];
            [self.loginButton setEnabled:YES];
        }
        
    } onError:^(NSError *error) {
        NSLog(@"ERROR --- ");
         [self showAlerWithString:[error description]];
        [self.loginButton setEnabled:YES];
    }];

}

-(void) showAlerWithString:(NSString *) alertMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



@end
