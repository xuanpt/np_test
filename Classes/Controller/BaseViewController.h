//
//  BaseViewController.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController

@property(nonatomic, weak) BaseViewController *parentVC;

- (UIButton*)createBackButton:(BOOL)isWhiteOrBlack;

- (UIButton*)createCloseButton;

@end
