// NPImageView.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//


@interface NPImageView : UIImageView

- (void)setupCircleAnimation:(CGPoint)startPoint radius:(CGFloat)radius;
- (void)updateCircleAnimation:(BOOL)isClockwise;

@end

