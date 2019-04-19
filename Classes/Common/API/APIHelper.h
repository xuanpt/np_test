//
//  APIHelper.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
//#import "AFNetworkActivityIndicatorManager.h"
#import "AFSecurityPolicy.h"
//#import "HTTPRequestOperation.h"
#import "NSURLRequest+NewsPicks.h"
#import "AFNetworking.h"
#import "ServiceError.h"
#import "SessionInfo.h"
#import "defined.h"
#import "Reachability.h"


@interface APIHelper : AFHTTPRequestOperationManager

@property (strong, nonatomic) Reachability *checkingConnectionReach;
@property (strong, nonatomic) Reachability *internetConnectionReach;
@property (assign, nonatomic) BOOL isCurrentNetworkAvailable;


+ (APIHelper *)sharedAPIHelper;

- (BOOL)isNetworkAvailable;
- (void)cancelAllHTTPOperations;

- (void)getXXX:(NSString *)ownerID completed:(void (^)(NSArray* result, ServiceError *error))completed;

- (void)registerWithFacebook:(NSDictionary *)facebookInfo completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)registerWithEmailPwd:(NSString *)email pwd:(NSString*)pwd completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)loginWithFacebook:(NSString *)facebookID completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)loginWithEmailPwd:(NSString *)email pwd:(NSString*)pwd completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)updateProfile:(NSDictionary *)profileInfo completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)updateFirebase:(NSUInteger)userID firebaseID:(NSString*)firebaseID completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)updateDeviceToken:(NSUInteger)userID deviceToken:(NSString*)deviceToken completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)updateBadgeCount:(NSUInteger)userID badgeCount:(NSUInteger)badgeCount completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)searchUserList:(NSDictionary *)condition completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)createChat:(NSDictionary *)chatInfo completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)getChatList:(NSUInteger)userID completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)createMessge:(NSDictionary *)messageInfo completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)acceptChatRequest:(NSDictionary *)chatInfo completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)rejectChatRequest:(NSDictionary *)chatInfo completed:(void (^)(NSDictionary* result, NSError *error))completed;

- (void)cancelChatRequest:(NSDictionary *)chatInfo completed:(void (^)(NSDictionary* result, NSError *error))completed;


- (void)doMatching:(NSMutableDictionary*)paramDic completed:(void (^)(NSMutableArray *reachUniArr, NSMutableArray *matchUniArr,
                                                                      NSMutableArray *safeUniArr, NSError *error))completed;
- (void)doMatching2:(NSString *)xxx completed:(void (^)(ServiceError *error))completed;

- (void)uploadImage:(NSString*)fileName imageData:(NSData*)imageData completed:(void (^)(NSString *imageURL, NSError *error))completed;
- (void)downloadImage:(NSString *)imageUrl completed:(void (^)(UIImage *image, ServiceError *error))completed;
- (void)deleteFile:(NSString*)fileName completed:(void (^)(NSError *error))completed;

- (void)doAppBootstrap:(NSString*)appVersion completed:(void (^)(BOOL isForceUpdate, NSError *error))completed;

@end

