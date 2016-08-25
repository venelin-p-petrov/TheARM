//
//  RegisterFormController.m
//  TheARM
//
//  Created by Mihail Karev on 7/11/16.
//  Copyright © 2016 Accedia. All rights reserved.
//

#import "RegisterFormController.h"
#import "ARMTextFieldCell.h"

@implementation RegisterFormController


-(void)viewWillAppear:(BOOL)animated{
    [self changeTextFieldStyles:self.usernameField isValid:NO];
    [self changeTextFieldStyles:self.passwordField isValid:NO];
    [self changeTextFieldStyles:self.confirmPasswordField isValid:NO];
    [self changeTextFieldStyles:self.emailField isValid:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endTextEditing];
}

-(void) endTextEditing {
    [self.emailField endEditing:YES];
    [self changeTextFieldStyles: self.emailField isValid:[self validateEmail:self.emailField.text]];

    [self.passwordField endEditing:YES];
    [self changeTextFieldStyles: self.passwordField isValid: ([self.passwordField.text isEqualToString: self.confirmPasswordField.text] && self.confirmPasswordField.text.length > 6)];
    [self.confirmPasswordField endEditing:YES];
    [self changeTextFieldStyles: self.confirmPasswordField isValid: ([self.passwordField.text isEqualToString: self.confirmPasswordField.text] && self.confirmPasswordField.text.length > 6)];
    [self.usernameField endEditing:YES];
    [self changeTextFieldStyles: self.usernameField  isValid:self.usernameField.text.length > 6];
    [self.displayNameField endEditing:YES];
    [self changeTextFieldStyles: self.displayNameField  isValid:self.displayNameField.text.length > 6];
}



- (void)changeTextFieldStyles:(UITextField *) textField isValid:
(BOOL) valid {
    if(!valid){
        textField.superview.layer.cornerRadius=8.0f;
        textField.superview.layer.masksToBounds=YES;
        textField.superview.layer.borderColor=[[UIColor redColor]CGColor];
        textField.superview.layer.borderWidth= 1.0f;
    } else{
        textField.superview.layer.borderWidth= 0.0f;
    }
    [self.delegate registerStatusChabged];
}



- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL)areTextFieldsValid {
    if(self.usernameField.text.length > 6 && self.passwordField.text.length > 6 &&
       self.confirmPasswordField.text.length >6 && [self.confirmPasswordField.text isEqualToString:self.passwordField.text] &&
       [self validateEmail:self.emailField.text]){
        return YES;
    } else {
        return NO;
    }
}



@end
