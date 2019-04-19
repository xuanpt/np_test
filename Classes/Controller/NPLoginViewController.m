//
// NPLoginViewController.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.


#import "NPLoginViewController.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "utilities.h"
#import "NPMainViewController.h"

@implementation NPLoginViewController {
    NSString *email;
    NSString *password;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateLoginButtonState];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (IBAction)textFieldDidChanged:(UITextField *)textField {
    if (textField == _emailTextField)       email    = textField.text;
    if (textField == _paswwordTextField)    password = textField.text;
    [self updateLoginButtonState];
}

- (IBAction)loginButtonClicked:(id)sender {
    [self dismissKeyboard];
    
    [ProgressHUD show:@"Logging in..." Interaction:NO];
    _loginButton.enabled = FALSE;
    
    [[APIHelper sharedAPIHelper] loginWithEmailPwd:email pwd:password completed:^(NSDictionary* result, NSError *error) {
        [ProgressHUD dismiss];
        _loginButton.enabled = TRUE;
        
        if (!error) {
            int status = [[result objectForKey:@"status"] intValue];
            if (status == 0) {
                NPMainViewController *npMainViewController = [[NPMainViewController alloc] init];
                [self presentViewController:npMainViewController animated:YES completion:nil];
            } else if (status == 1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:LocStr(@"Failed to authenticate.")
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:LocStr(@"Something went wrong, please try again later.")
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)dismissKeyboard {
    [_emailTextField resignFirstResponder];
    [_paswwordTextField resignFirstResponder];
}

- (void)updateLoginButtonState {
    BOOL isEnabled = ([Util isGoodString:email] && [Util isGoodString:password]);
    _loginButton.enabled = isEnabled;
    _loginButton.backgroundColor = isEnabled ? UIColorFromRGBValues(235.0, 123.0, 45.0) : UIColorFromRGBValues(254.0, 211.0, 127.0);
}

@end
