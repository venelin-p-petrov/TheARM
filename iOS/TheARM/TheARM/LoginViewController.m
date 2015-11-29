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
            [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        } else {
            [self showAlerWithString:@"Wrong username or password"];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([@"CreateEvent" isEqualToString:segue.identifier]){
        NSDictionary *dictionary  = @{@"startTime":@"2015-11-21T19:00:00.000Z", @"endTime": @"2015-11-21T19:30:00.000Z"};
        EventViewController *eventViewController = (EventViewController *)segue.destinationViewController;
        [eventViewController setEventViewState:CREATE];
        eventViewController.currentEvent = dictionary;
    }
}

@end
