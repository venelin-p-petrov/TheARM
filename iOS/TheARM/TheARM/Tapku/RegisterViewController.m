//
//  RegisterViewController.m
//  TheARM
//
//  Created by JGeorgiev on 11/14/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "RegisterViewController.h"
#import "RestManager.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeTextFieldStyles:self.usernameTextField isValid:NO];
    [self changeTextFieldStyles:self.passwordTextField isValid:NO];
    [self changeTextFieldStyles:self.confirmPasswordTextField isValid:NO];
    [self changeTextFieldStyles:self.emailTextField isValid:NO];
    self.registerButton.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerButtonClicked:(id)sender {
    [RestManager doRegisterUsername:self.usernameTextField.text password:self.passwordTextField.text andEmail:self.emailTextField.text onSuccess:^(NSObject *reponseObject){

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful registration"
                                                        message:@"Registration was successful."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }onError:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration fail"
                                                        message:@"Registration was unseccessful."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)emailEditingChanged:(id)sender {
    [self changeTextFieldStyles: (UITextField *)sender isValid:[self validateEmail:self.emailTextField.text]];
}

- (IBAction)fextFieldsMinLenghtEditingChanged:(id)sender {
    [self changeTextFieldStyles: (UITextField *)sender isValid:((UITextField *)sender).text.length > 6];
}

- (IBAction)confirmPasswordNotMatchEditingChanged:(id)sender {
    [self changeTextFieldStyles: (UITextField *)sender isValid: (self.passwordTextField.text == self.confirmPasswordTextField.text && self.confirmPasswordTextField.text.length > 6)];
}


- (void)changeTextFieldStyles:(UITextField *) textField isValid:
(BOOL) valid {
    if(!valid){
        textField.layer.cornerRadius=8.0f;
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor=[[UIColor redColor]CGColor];
        textField.layer.borderWidth= 1.0f;
    } else{
        textField.layer.borderWidth= 0.0f;
    }
}

- (IBAction)registerButtonEnableTextFieldsEditingChanged:(id)sender {
    if([self areTextFieldsValid]){
        self.registerButton.enabled = YES;
    }
    else{
        self.registerButton.enabled = NO;
    }
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL)areTextFieldsValid {
    if(self.usernameTextField.text.length > 6 && self.passwordTextField.text.length > 6 &&
       self.confirmPasswordTextField.text.length >6 && self.confirmPasswordTextField.text == self.passwordTextField.text &&
       [self validateEmail:self.emailTextField.text]){
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
