//
// FirebaseHelper.h
// NewsPicks
//
//  Created by Xuan Pham on 2019/02/10.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import Firebase;

@interface FirebaseHelper : NSObject

+ (FirebaseHelper *)sharedInstance;

- (void)signIn;
- (void)signOut;

@end
