//
// MainViewController.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.


#import <QuartzCore/QuartzCore.h>
#import "NPMainViewController.h"
#import "NPLoginViewController.h"
#import "config.h"
#import "NPImageView.h"

@implementation NPMainViewController {
    int currentRotationDirection;
    CGPoint startPoint;
    CGPoint circleCenterPoint;
    CGFloat radius;
    
    NSMutableArray *faceImageViewList;
    
    CAKeyframeAnimation *circleAnimation;
    CGPoint touchBeganPoint;
    CGPoint touchEndedPoint;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //Init settings
    radius                      = (ScreenWidth - 50) / 2;
    circleCenterPoint           = self.view.center;
    startPoint                  = CGPointMake(circleCenterPoint.x - radius, circleCenterPoint.y - radius);
    currentRotationDirection    = RotationDirection_Clockwise;
    
    //Create center circle view
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    circleView.center = self.view.center;
    circleView.layer.cornerRadius = radius;
    circleView.layer.borderWidth = 1;
    circleView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:circleView];
    
    //Create face images list
    [self settingFaceImageList];
}

- (void)settingFaceImageList {
    faceImageViewList = [NSMutableArray array];
    CGPoint positionByHour;
    NPImageView *faceImageView;
    
    NSArray *imageURLList = @[
                              @"https://contents.newspicks.us/users/100013/cover?circle=true",
                              @"https://contents.newspicks.us/users/100269/cover?circle=true",
                              @"https://contents.newspicks.us/users/100094/cover?circle=true",
                              @"https://contents.newspicks.us/users/100353/cover?circle=true",
                              @"https://contents.newspicks.us/users/100019/cover?circle=true",
                              @"https://contents.newspicks.us/users/100529/cover?circle=true"
                             ];
    
    for (int i = 0; i < 6; i++) {
        //The idea of face images list position is by hour of the clock: 2h; 4h; 6h; 8h; 10h; 12h
        positionByHour = [self hourToPosition: (i * 2) + 2];
        
        faceImageView = [[NPImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        faceImageView.center = positionByHour;
        [self.view addSubview:faceImageView];
        [faceImageViewList addObject:faceImageView];
        
        [Util loadImageWithImageURL:imageURLList[i] noImageFile:@"no_profile_image.png" completed:^(UIImage *image) {
            faceImageView.image = image;
        }];
        
        [faceImageView setupCircleAnimation:startPoint radius:radius];
    }
}

- (void)handeCircleRevolution {
    int rotationDirection = currentRotationDirection;
    
    if (touchBeganPoint.y < circleCenterPoint.y && touchEndedPoint.y < circleCenterPoint.y){
        //In case of top horizontal swipe
        rotationDirection = (touchBeganPoint.x < touchEndedPoint.x) ? RotationDirection_Clockwise : RotationDirection_Counterclockwise;
    } else if (touchBeganPoint.y > circleCenterPoint.y && touchEndedPoint.y > circleCenterPoint.y) {
        //In case of bottom horizontal swipe
        rotationDirection = (touchBeganPoint.x < touchEndedPoint.x) ? RotationDirection_Counterclockwise : RotationDirection_Clockwise;
    } else if (touchBeganPoint.x > circleCenterPoint.x && touchEndedPoint.x > circleCenterPoint.x) {
        //In case of right vertical swipe
        rotationDirection = (touchBeganPoint.y > touchEndedPoint.y) ? RotationDirection_Counterclockwise : RotationDirection_Clockwise;
    } else if (touchBeganPoint.x < circleCenterPoint.x && touchEndedPoint.x < circleCenterPoint.x) {
        //In case of left vertical swipe
        rotationDirection = (touchBeganPoint.y > touchEndedPoint.y) ? RotationDirection_Clockwise : RotationDirection_Counterclockwise;
    }
    
    if (currentRotationDirection != rotationDirection) {
        currentRotationDirection = rotationDirection;
        BOOL isClockwise = (currentRotationDirection == RotationDirection_Clockwise);
        
        for (NPImageView *faceImageView in faceImageViewList) {
            [faceImageView updateCircleAnimation:isClockwise];
        }
     }
}

- (CGPoint)hourToPosition:(CGFloat)hour {
    float radians = 2 * M_PI * (hour - 3) / 12;
    float degrees = RADIANS_TO_DEGREES(radians);
    if (degrees < 0) degrees += 360.0;
    
    CGFloat pointX = circleCenterPoint.x + cos(radians) * radius;
    CGFloat pointY = circleCenterPoint.y + sin(radians) * radius;
    return CGPointMake(pointX, pointY);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touchBeganPoint = [[touches anyObject] locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    touchEndedPoint = [[touches anyObject] locationInView:self.view];
    [self handeCircleRevolution];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

@end
