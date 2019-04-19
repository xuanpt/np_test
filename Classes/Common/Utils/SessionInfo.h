//
//  SessionInfo.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionInfo : NSObject{
    
    NSString *someProperty;
    
}

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *userType;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic) int unreadNotificationCount;
@property (nonatomic) int unreadMarketReportCount;
+ (id)session;

@end
