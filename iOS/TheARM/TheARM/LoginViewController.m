//
//  LoginViewController.m
//  TheARM
//
//  Created by Mihail Karev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "LoginViewController.h"

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
    
}
@end
