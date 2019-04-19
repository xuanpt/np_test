// NPImageView.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import "NPImageView.h"

@interface NPImageView () {
    CAKeyframeAnimation *circleAnimation;
    CGPoint startPoint;
    CGFloat radius;
}

@end

@implementation NPImageView

- (void)setupCircleAnimation:(CGPoint)sPoint radius:(CGFloat)circleRadius {
    startPoint = sPoint;
    radius = circleRadius;
    
    circleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    circleAnimation.calculationMode = kCAAnimationPaced;
    circleAnimation.duration = 10.0;
    circleAnimation.repeatCount = CGFLOAT_MAX;
    circleAnimation.fillMode = kCAFillModeForwards;
    circleAnimation.removedOnCompletion = NO;
    
    CGFloat angle = [self calculateAngle:CGPointMake(self.center.x, self.center.y)];
    angle = DEGREES_TO_RADIANS(angle);
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, startPoint.x + radius, startPoint.y + radius, radius, angle, angle + 2 * M_PI, NO);
    circleAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    [self.layer addAnimation:circleAnimation forKey:@"circleAnimation"];
}

- (void)updateCircleAnimation:(BOOL)isClockwise {
    [self.layer removeAnimationForKey:@"circleAnimation"];
    
    CGPoint currentPosition = [[self.layer presentationLayer] frame].origin;
    CGFloat faceImageViewCenterX = currentPosition.x + self.frame.size.width / 2;
    CGFloat faceImageViewCenterY = currentPosition.y + self.frame.size.height / 2;
    
    CGFloat angle = [self calculateAngle:CGPointMake(faceImageViewCenterX, faceImageViewCenterY)];
    angle = DEGREES_TO_RADIANS(angle);
    CGFloat endAngle = isClockwise ? angle + 2 * M_PI : angle - 2 * M_PI;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, startPoint.x + radius, startPoint.y + radius, radius, angle, endAngle, !isClockwise);
    circleAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    [self.layer addAnimation:circleAnimation forKey:@"circleAnimation"];
}

- (CGFloat)calculateAngle:(CGPoint)point {
    CGFloat circleCenterPointX = startPoint.x + radius;
    CGFloat circleCenterPointY = startPoint.y + radius;
    
    float deltaY = point.y - circleCenterPointY;
    float deltaX = point.x - circleCenterPointX;
    float radians = atan(deltaY / deltaX);
    float degrees = RADIANS_TO_DEGREES(radians);
    if (deltaX < 0) degrees += 180.0;
    return degrees;
}

@end
