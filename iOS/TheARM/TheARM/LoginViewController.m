//
//  LoginViewController.m
//  TheARM
//
//  Created by Mihail Karev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "LoginViewController.h"
#import "RestManager.h"
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.loginButton setEnabled:YES];
}

- (IBAction)clickLogin:(id)sender {
    [self.loginButton setEnabled:NO];
    NSLog(@"Username %@", self.username.text);
    NSLog(@"Password %@", self.pasword.text);

    [RestManager doLoginWithUsername:self.username.text password:self.pasword.text onSuccess:^(NSObject *responseObject) {
        NSLog(@"Success");
        NSError *error;
        NSDictionary *responseDictionary =  [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:kNilOptions error:&error];

        if ([@"success" isEqualToString:[responseDictionary objectForKey:@"status"]]){
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
