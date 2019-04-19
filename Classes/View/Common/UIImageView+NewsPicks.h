//
//  UIImageView+NewsPicks.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImageView (NewsPicks)

- (void)roundedStyle;
- (void)setPlaceholderImage:(NSString*)placeholderImage;
- (void)loadImageWithImageURL:(NSString *)url noImageFile:(NSString*)noImageFile;
- (void)setImageWithPFFile:(PFFile*)pfFile noImageFile:(NSString*)noImageFile loadedImage:(UIImage*)loadedImage;
@end

