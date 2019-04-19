//
//  SystemInfo.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMUser.h"
@import Firebase;

@interface SystemInfo : NSObject

@property (nonatomic, strong) TMUser *userInfo;
@property (nonatomic, strong) FIRUser *firUser;
@property (nonatomic, strong) NSMutableDictionary *sharedData;


//============================== Unused ===================================
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *loginFacebookToken;
@property (nonatomic, assign) int currentLanguage;

@property (nonatomic, strong) NSString *loginID;
@property (nonatomic, strong, readonly) NSString *accessToken;
@property (nonatomic, assign, readonly) BOOL authenticated;
@property (nonatomic, assign)           BOOL isUpdatedAcademicInfo;
@property (nonatomic, strong, readonly) NSString *deviceID;
@property (nonatomic, strong, readonly) NSString *deviceToken;
@property (nonatomic, strong, readonly) NSCalendar *defaultCalendar;
//==========================================================================


+ (SystemInfo *)sharedInstance;

- (void)saveUserInfo;
- (void)clearUserInfo;

/*
- (void)setLoginEmailAddress:(NSString*)loginEmailAddress;
- (void)setLoginPassword:(NSString*)loginPassword;
- (void)setFacebookID:(NSString*)facebookID;
- (void)setFacebookToken:(NSString*)facebookToken;
- (BOOL)checkIsLogginedIn;
*/

/*
- (void)loadUserInfoIfAuthenticated;
- (void)setDeviceToken:(NSString*)deviceToken;
- (void)loggedInWithAccessToken:(NSString *)accessToken withLogin:(NSString *)loginId;
- (int)getLanguageID:(NSString *)language;
+ (BOOL)notificationServicesEnabled ;
 */

@end
