//
//  SessionInfo.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import "SessionInfo.h"

@implementation SessionInfo

+ (id)session {
    static SessionInfo *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[self alloc] init];
    });
    return session;
}

- (id)init {
    if (self = [super init]) {
        [self setEmail:@""];
        [self setFirstName:@""];
        [self setLastName:@""];
        [self setUserType:@""];
        [self setPhoneNumber:@""];
        [self setToken:@""];
        [self setUserId:@""];
        [self setUnreadNotificationCount:0];
        [self setUnreadMarketReportCount:0];
    }
    return self;
}

- (void)dealloc {
    
}

@end
