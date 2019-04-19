//
//  APIHelper.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import "APIHelper.h"


@implementation APIHelper


+ (APIHelper *)sharedAPIHelper {
    static APIHelper *_sharedAPIHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPIHelper = [[APIHelper alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    
    return _sharedAPIHelper;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self settingNetworkMonitoring];
    }
    
    return self;
}


- (BOOL)isNetworkAvailable {
    return _isCurrentNetworkAvailable;
}


- (void)settingNetworkMonitoring {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    self.checkingConnectionReach = [Reachability reachabilityWithHostname:@"www.google.com"];
    self.checkingConnectionReach.reachableBlock = ^(Reachability * reachability) {
        _isCurrentNetworkAvailable = TRUE;
    };
    
    self.checkingConnectionReach.unreachableBlock = ^(Reachability * reachability) {
        _isCurrentNetworkAvailable = FALSE;
    };
    [self.checkingConnectionReach startNotifier];
    
    
    self.internetConnectionReach = [Reachability reachabilityForInternetConnection];
    self.internetConnectionReach.reachableBlock = ^(Reachability * reachability) {
        _isCurrentNetworkAvailable = TRUE;
    };
    self.internetConnectionReach.unreachableBlock = ^(Reachability * reachability) {
        _isCurrentNetworkAvailable = FALSE;
    };
    
    [self.internetConnectionReach startNotifier];
}



-(void)reachabilityChanged:(NSNotification*)note {
    Reachability * reach = [note object];
    
    if (reach == self.internetConnectionReach) {
        if([reach isReachable]) {
            self.isCurrentNetworkAvailable = TRUE;
            NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Reachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
        } else {
            self.isCurrentNetworkAvailable = FALSE;
            NSString * temp = [NSString stringWithFormat:@"InternetConnection Notification Says Unreachable(%@)", reach.currentReachabilityString];
            NSLog(@"%@", temp);
        }
    }
}



- (void)cancelAllHTTPOperations {
    for (NSOperation *operation in [self.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) continue;
        
        [operation cancel];
    }
}


- (AFHTTPRequestOperation *)NCBHTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    /*
    AFHTTPRequestOperation *operation = [[HTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
        NSURLResponse *response = cachedResponse.response;
        if ([response isKindOfClass:NSHTTPURLResponse.class]) return cachedResponse;
        
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse*)response;
        NSDictionary *headers = HTTPResponse.allHeaderFields;
        if (headers[@"Cache-Control"]) return cachedResponse;
        
        NSMutableDictionary *modifiedHeaders = headers.mutableCopy;
        modifiedHeaders[@"Cache-Control"] = CACHE_CONTROL_MAX_AGE;
        NSHTTPURLResponse *modifiedResponse = [[NSHTTPURLResponse alloc]
                                               initWithURL:HTTPResponse.URL
                                               statusCode:HTTPResponse.statusCode
                                               HTTPVersion:@"HTTP/1.1"
                                               headerFields:modifiedHeaders];
        
        cachedResponse = [[NSCachedURLResponse alloc]
                          initWithResponse:modifiedResponse
                          data:cachedResponse.data
                          userInfo:cachedResponse.userInfo
                          storagePolicy:cachedResponse.storagePolicy];
        return cachedResponse;
    }];
    
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;
    return operation;
     */
    return nil;
}


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableURLRequest *networkAvailableRequest = request.mutableCopy;
    if(![self isNetworkAvailable]) {
        networkAvailableRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    
    NSURLRequest *modifiedRequest = [networkAvailableRequest requestWithCachePolicyModified];
    
    AFHTTPRequestOperation *operation = [self NCBHTTPRequestOperationWithRequest:modifiedRequest
                                                                       success:success
                                                                       failure:failure];
    return operation;
}


- (NSString *)getFullPathFromAPI:(NSString *)path {
    return [NSString stringWithFormat:@"%@%@", kServerAPIBaseURL, path];
}



- (void)getXXX:(NSString *)ownerID completed:(void (^)(NSArray* result, ServiceError *error))completed {
    NSString *path = [NSString stringWithFormat:@"%@XXX", ownerID];
    path = [self getFullPathFromAPI:path];
    
    [self GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSMutableArray *data = [NSMutableArray array];
        ServiceError *serviceError = [ServiceError makeServiceErrorIfNeededWithOperation:operation responseObject:responseObject];
        if(!serviceError) {
            //NSDictionary *dict = [responseObject objectForKey:JsonResponseKeyResult];
            /*
            NSArray *xxxs = [dict objectForKey:@"xxx"];
            for (NSDictionary *usersDict in xxxs) {
                [data addObject:[[RJCUser alloc] initWithDictionary:usersDict]];
            }
             */
        }
        if (completed) {
            completed(@[],serviceError);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ServiceError *serviceError = [ServiceError makeServiceErrorIfNeededWithOperation:operation withNSError:error];
        if (completed) {
            completed(@[],serviceError);
        }
    }];
}

- (void)registerWithFacebook:(NSDictionary *)facebookInfo completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/user/register/facebook";
    path = [self getFullPathFromAPI:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:facebookInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)registerWithEmailPwd:(NSString *)email pwd:(NSString*)pwd completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/user/register/email";
    path = [self getFullPathFromAPI:path];
    
    NSString *deviceToken = [[SystemInfo sharedInstance].sharedData objectForKey:@"device_token"];
    if (!deviceToken) deviceToken = @"";
    
    NSDictionary *parameters = @{ @"email" : email, @"pwd" : pwd, @"device_token" : deviceToken};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)loginWithFacebook:(NSString *)facebookID completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/user/login/facebook";
    path = [self getFullPathFromAPI:path];
    
    
    NSDictionary *parameters = @{ @"facebook_id" : facebookID};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)loginWithEmailPwd:(NSString *)email pwd:(NSString*)pwd completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/user/login/email";
    path = [self getFullPathFromAPI:path];
    
    NSDictionary *parameters = @{ @"email" : email, @"pwd" : pwd};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)updateProfile:(NSDictionary *)profileInfo completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/user/profile";
    path = [self getFullPathFromAPI:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:profileInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)updateFirebase:(NSUInteger)userID firebaseID:(NSString*)firebaseID completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/user/firebase";
    path = [self getFullPathFromAPI:path];
    
    NSDictionary *parameters = @{ @"user_id" : @(userID), @"firebase_id" : firebaseID};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)updateDeviceToken:(NSUInteger)userID deviceToken:(NSString*)deviceToken completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/user/device-token";
    path = [self getFullPathFromAPI:path];
    
    NSDictionary *parameters = @{ @"user_id" : @(userID), @"device_token" : deviceToken};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)updateBadgeCount:(NSUInteger)userID badgeCount:(NSUInteger)badgeCount completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/user/badge-count";
    path = [self getFullPathFromAPI:path];
    
    NSDictionary *parameters = @{ @"user_id" : @(userID), @"badge_count" : @(badgeCount)};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)searchUserList:(NSDictionary *)condition completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/users";
    path = [self getFullPathFromAPI:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:condition success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}


- (void)createChat:(NSDictionary *)chatInfo completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/chat";
    path = [self getFullPathFromAPI:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:chatInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)getChatList:(NSUInteger)userID completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = ConcatString(@"/chat/", Int2String(userID));
    path = [self getFullPathFromAPI:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)createMessge:(NSDictionary *)messageInfo completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/chat/message";
    path = [self getFullPathFromAPI:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:messageInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)acceptChatRequest:(NSDictionary *)chatInfo completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/chat/request/accept";
    path = [self getFullPathFromAPI:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:chatInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)rejectChatRequest:(NSDictionary *)chatInfo completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/chat/request/reject";
    path = [self getFullPathFromAPI:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:chatInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

- (void)cancelChatRequest:(NSDictionary *)chatInfo completed:(void (^)(NSDictionary* result, NSError *error))completed {
    NSString *path = @"/chat/request/cancel";
    path = [self getFullPathFromAPI:path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:chatInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completed) completed((NSDictionary*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completed) completed(nil, error);
    }];
}

//=======================================================================================================================================

- (void)uploadImage:(NSString*)fileName imageData:(NSData*)imageData completed:(void (^)(NSString *imageURL, NSError *error))completed {
    NSString *urlString = Concat3String(kParseAPIBaseURL, kParseAPIUploadFile, fileName);
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [parseRequest setHTTPMethod:kHTTPPost];
    [parseRequest setValue:kParseApplicationID          forHTTPHeaderField:kParseApplicationIDHeader];
    [parseRequest setValue:kParseAPIKey                 forHTTPHeaderField:kParseAPIKeyHeader];
    [parseRequest setValue:kHTTPContentType_ImageJpeg   forHTTPHeaderField:kHTTPContentType];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:imageData];
    [parseRequest setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:parseRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        if ([httpResponse statusCode] == 201) {
            NSError *error;
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:[responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:NSJSONReadingMutableContainers error:&error];
            
            if (completed) completed((error == nil) ? [responseDictionary objectForKey:@"url"] : nil, error);
        } else {
            if (completed) completed(nil, connectionError);
        }
    }];
}


- (void)downloadImage:(NSString *)imageUrl completed:(void (^)(UIImage *image, ServiceError *error))completed {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completed((UIImage*)responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //DLog(@"Error: %@", error);
        ServiceError *serviceError = [ServiceError makeServiceErrorIfNeededWithOperation:operation withNSError:error];
        if (completed) {
            completed(nil, serviceError);
        }
    }];
    
    [operation start];
}



- (void)deleteFile:(NSString*)fileName completed:(void (^)(NSError *error))completed {
    /*
    NSString *urlString = Concat3String(kParseAPIBaseURL, kParseAPIUploadFile, fileName);
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [parseRequest setHTTPMethod:kHTTPDelete];
    [parseRequest setValue:kParseApplicationID  forHTTPHeaderField:kParseApplicationIDHeader];
    [parseRequest setValue:kParseMasterKey      forHTTPHeaderField:kParseMasterKeyHeader];
    
    [NSURLConnection sendAsynchronousRequest:parseRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (completed) completed(connectionError);
    }];
     */
}

- (void)doAppBootstrap:(NSString*)appVersion completed:(void (^)(BOOL isForceUpdate, NSError *error))completed {
    /*
    NSString *urlString = ConcatString(kParseAPIBaseURL, kParseAPIBootstrap);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:kHTTPPost];
    [request setValue:[SystemInfo sharedInstance].parseApplicationID    forHTTPHeaderField:kParseApplicationIDHeader];
    [request setValue:[SystemInfo sharedInstance].parseAPIKey           forHTTPHeaderField:kParseAPIKeyHeader];
    [request setValue:@"application/json"                               forHTTPHeaderField:kHTTPContentType];
    
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:appVersion forKey:@"version"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:jsonData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        BOOL isForceUpdate = FALSE;
        
        if ([httpResponse statusCode] == 200) {
            
            NSError *error;
            NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:[responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                               options:NSJSONReadingMutableContainers error:&error];
            
            NSMutableDictionary *versionInfoDic = [[responseDictionary objectForKey:@"result"] objectForKey:@"versionInfo"];
            NSMutableDictionary *currentVersionInfoDic = [versionInfoDic objectForKey:appVersion];
            
            if (![Util isNullObject:currentVersionInfoDic]) {
                if (![Util isNullObject:[currentVersionInfoDic objectForKey:@"forceUpdate"]]) {
                    isForceUpdate = (BOOL)[[currentVersionInfoDic objectForKey:@"forceUpdate"] integerValue];
                }
            }
        }
        
        if (completed) completed(isForceUpdate, connectionError);
    }];
    */
}



@end
