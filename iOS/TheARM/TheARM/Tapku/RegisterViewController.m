//
//  RegisterViewController.m
//  TheARM
//
//  Created by JGeorgiev on 11/14/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButtonClicked:(id)sender {
}

- (IBAction)emailTextFieldEditingEnded:(id)sender {
    
}

- (BOOL)areTextFieldsValid {
    if(self.usernameTextField.text.length > 6 && self.passwordTextField.text.length > 6 &&
       self.confirmPasswordTextField.text.length >6 && self.confirmPasswordTextField.text == self.passwordTextField.text
       ){
        return YES;
    } else {
        return NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
