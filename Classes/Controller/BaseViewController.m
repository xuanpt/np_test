//
//  BaseViewController.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor_Dark;
}



- (void)backButtonClicked:(UIButton*)button {
    //CATransition *transition = [Util settingTransitionAnimation:kCATransitionFromLeft];
    //[self.view.window.layer addAnimation:transition forKey:nil];
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}



- (UIButton*)createBackButton:(BOOL)isWhiteOrBlack {
    CGRect buttonImageFrame;
    NSString *imageName;
    
    if (isWhiteOrBlack == TRUE) {
        buttonImageFrame    = CGRectMake(20, 0, 20 * 28 / 51, 20);
        imageName           = @"icon_back_white2.png";
    } else {
        buttonImageFrame    = CGRectMake(20, 0, 60, 20);
        imageName           = @"icon_back_black.png";
    }
    
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(0, StatusBarHeight + 10, 100 , 20);
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:buttonImageFrame];
    buttonImageView.image = [UIImage imageNamed:imageName];
    [backButton addSubview:buttonImageView];
    return backButton;
}


- (UIButton*)createCloseButton {
    UIButton* closedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    closedButton.frame = CGRectMake(10, 20 + (44 - 23) / 2, 23, 23);
    [closedButton setBackgroundImage:[UIImage imageNamed:@"btn_close_nm@3x.png"] forState:UIControlStateNormal];
    return closedButton;
}


@end
