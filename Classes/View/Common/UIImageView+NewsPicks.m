//
//  UIImageView+NewsPicks.m
// NewsPicks
//
//  Created by Xuan Pham on 7/16/15.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+NewsPicks.h"
#import "FileHelper.h"
#import "Util.h"

@implementation UIImageView (NewsPicks)

- (void)roundedStyle {
    self.layer.cornerRadius = floorf(self.frame.size.width/2.0);
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}


- (void)setPlaceholderImage:(NSString*)placeholderImage {
    self.image = [UIImage imageNamed:placeholderImage];
}



- (void)setImageWithPFFile:(PFFile*)pfFile noImageFile:(NSString*)noImageFile loadedImage:(UIImage*)loadedImage {
    if (loadedImage != nil) self.image = loadedImage;
    else {
        if (pfFile != nil) {
            [pfFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    self.image = [UIImage imageWithData:data];
                } else {
                    self.image = [UIImage imageNamed:noImageFile];
                }
            }];
        } else {
            self.image = [UIImage imageNamed:noImageFile];
        }
    }
}


- (void)loadImageWithImageURL:(NSString*)imageURL noImageFile:(NSString*)noImageFile {
    [Util loadImageWithImageURL:imageURL noImageFile:noImageFile completed:^(UIImage *image) {
        self.image = image;
    }];
}


/*
- (void)loadImageWithImageURL:(NSString*)imageURL noImageFile:(NSString*)noImageFile {
    self.image = [UIImage imageNamed:noImageFile];
    
    if ([Util isGoodString:imageURL]) {
        if ([[FileHelper sharedInstance] hasImageFileWithURL:imageURL]) {
            [[FileHelper sharedInstance] loadLocalImageFromImageURL:imageURL completed:^(UIImage *image) {
                if (image != nil) self.image = image;
            }];
        } else {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            
            if(cachedResponse) {
                self.image = [UIImage imageWithData:cachedResponse.data];
            } else {
                [[APIHelper sharedAPIHelper] downloadImage:imageURL completed:^(UIImage *image, ServiceError *error) {
                    if (!error) {
                        self.image = image;
                        [[FileHelper sharedInstance] saveImageFile:image withImageURL:imageURL];
                    } else {
                        DLog(@"loadImageWithURL error = %@", error);
                    }
                }];
            }
        }
    }
}
 */

@end
