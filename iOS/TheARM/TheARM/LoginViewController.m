//
//  LoginViewController.m
//  TheARM
//
//  Created by Mihail Karev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "LoginViewController.h"
#import "RestManager.h"

@interface LoginViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *username;
    @property (weak, nonatomic) IBOutlet UITextField *pasword;
    @property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];    
}

- (IBAction)clickLogin:(id)sender {
    NSLog(@"Username %@", self.username.text);
    NSLog(@"Password %@", self.pasword.text);

    [RestManager doLoginWithUsername:self.username.text password:self.pasword.text onSuccess:^(NSObject *responseObject) {
        NSLog(@"Success");
        if ([@"ok" isEqualToString:(NSString *)responseObject]){
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        } else {
            [self showAlerWithString:@"Wrong username or password"];
        }
    } onError:^(NSError *error) {
        NSLog(@"ERROR --- ");
         [self showAlerWithString:[error description]];
    }];

}

-(void) showAlerWithString:(NSString *) alertMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

@end
