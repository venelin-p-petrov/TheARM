//
//  RegisterViewController.m
//  TheARM
//
//  Created by JGeorgiev on 11/14/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import "RegisterViewController.h"
#import "DataManager.h"
#import "MBProgressHUD.h"

@interface RegisterViewController ()


@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property RegisterFormController *registerForm;

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    self.registerButton.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToLoginButton:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButtonClicked:(id)sender {
    if ([self.registerForm areTextFieldsValid]) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
   
        
        [self.registerButton setEnabled:NO];
        DataManager *dataManager = [DataManager sharedDataManager];
        [dataManager doRegisterUsername:self.registerForm.usernameField.text password:self.registerForm.passwordField.text email: self.registerForm.emailField.text     andDisplayName:self.registerForm.displayNameField.text  onSuccess:^(NSObject *reponseObject){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful registration"
                                                            message:@"Registration was successful."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
            [alert show];
        }onError:^(NSError *error) {
            [self.registerButton setEnabled:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration fail"
                                                            message:@"Registration was unseccessful."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
            
          });
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)registerButtonEnableTextFieldsEditingChanged:(id)sender {
    if([self.registerForm areTextFieldsValid]){
        self.registerButton.enabled = YES;
    }
    else{
        self.registerButton.enabled = NO;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.registerForm endTextEditing];
}
- (IBAction)tapGesture:(id)sender {
     [self.registerForm endTextEditing];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"RegisterContainerSegue"]) {
        self.registerForm = (RegisterFormController *) [segue destinationViewController];
        self.registerForm.delegate = self;
    }
}

-(void)registerStatusChabged{
    [self registerButtonEnableTextFieldsEditingChanged:nil];
}

@end
