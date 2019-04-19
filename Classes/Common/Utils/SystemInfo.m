//
//  SystemInfo.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SystemInfo.h"
#import "Util.h"

@implementation SystemInfo

+ (SystemInfo *)sharedInstance {
    static SystemInfo *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SystemInfo alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.sharedData = [NSMutableDictionary dictionary];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)loadUserInfo:(NSUserDefaults*)user {
    self.userInfo = [[TMUser alloc] init];
}

- (void)saveUserInfo {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearUserInfo {
    self.userInfo = nil;
    [self saveUserInfo];
}

- (void)loadFirebaseUser {
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
        if (user) self.firUser = user;
    }];
}

/*
- (BOOL)checkIsLogginedIn {
    return ((_loginEmailAddress != nil && _loginPassword != nil) ||
            (_loginFacebookID != nil && _loginFacebookToken != nil)) ? TRUE : FALSE;
}


- (void)setLoginEmailAddress:(NSString *)loginEmailAddress {
    _loginEmailAddress = loginEmailAddress;
    
    //[[NSUserDefaults standardUserDefaults] setObject:loginEmailAddress forKey:kLoginEmailAddress];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setLoginPassword:(NSString*)loginPassword {
    _loginPassword = loginPassword;
    
    //[[NSUserDefaults standardUserDefaults] setObject:loginPassword forKey:kLoginPasssword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setFacebookID:(NSString*)facebookID {
    _loginFacebookID = facebookID;
    
    //[[NSUserDefaults standardUserDefaults] setObject:facebookID forKey:kLoginFacebookID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)setFacebookToken:(NSString*)facebookToken {
    _loginFacebookToken = facebookToken;
    
    //[[NSUserDefaults standardUserDefaults] setObject:facebookToken forKey:kLoginFacebookAccessToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)clearLoginInfo {
    _loginEmailAddress = nil;
    _loginFacebookID = nil;
    _loginFacebookToken = nil;
 
    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoginEmailAddress];
    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoginFacebookID];
    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoginEmailAddress];
    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoginUserType];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
}
*/


/*
- (int)getLanguageID:(NSString *)language {
    if      ([language isEqualToString:@"ja"])      return 1;
    else if ([language isEqualToString:@"en"])      return 2;
    else if ([language isEqualToString:@"zh-Hant"]) return 3;
    else                                            return 1;
}

- (void)loadUserInfoIfAuthenticated {
    if(!_authenticated) return;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _accessToken = [user stringForKey:kAccessTokenPref];
    _loginID = [user stringForKey:kLoginIdPref];
}


- (void)loggedInWithAccessToken:(NSString *)accessToken withLogin:(NSString *)loginId {
    _authenticated = YES;
    _accessToken = accessToken;
    _loginID = loginId;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:_authenticated forKey:kAuthenticatedPref];
    [user setObject:accessToken forKey:kAccessTokenPref];
    [user setObject:loginId forKey:kLoginIdPref];
    [user synchronize];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    _deviceToken = deviceToken;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:deviceToken forKey:kDeviceTokenPref];
    [user synchronize];
}

- (void)saveDeviceToken:(NSString*)deviceToken {
    _deviceToken = deviceToken;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:_deviceToken forKey:kDeviceTokenPref];
    [user synchronize];
}
*/


@end
