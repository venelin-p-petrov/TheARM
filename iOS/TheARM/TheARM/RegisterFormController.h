//
//  RegisterFormController.h
//  TheARM
//
//  Created by Mihail Karev on 7/11/16.
//  Copyright © 2016 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterControllerDelegate <NSObject>

-(void) registerStatusChabged;

@end

@interface RegisterFormController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *displayNameField;

@property  NSObject<RegisterControllerDelegate> *delegate;


-(void) endTextEditing;
- (BOOL)areTextFieldsValid;
@end
