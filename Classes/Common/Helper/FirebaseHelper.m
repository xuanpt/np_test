//
//  FirebaseHelper.m
// NewsPicks
//
//  Created by Xuan Pham on 2019/02/10.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import "FirebaseHelper.h"
#import "Util.h"

@implementation FirebaseHelper {
    FIRDatabaseReference *fiDBRef;
    FIRStorageReference *fiStorageRef;
}

+ (FirebaseHelper *)sharedInstance {
    static FirebaseHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FirebaseHelper alloc] init];
    });
    return _sharedInstance;
}


- (id)init {
    self = [super init];
    
    if (self) {
        [self configureFirebaseDB];
    }
    
    return self;
}

- (void)signIn {
    NSString *facebookID    = [SystemInfo sharedInstance].userInfo.facebookID;
    NSString *fbAccessToken = [SystemInfo sharedInstance].userInfo.fbAccessToken;
    NSString *email         = [SystemInfo sharedInstance].userInfo.email;
    NSString *password      = [SystemInfo sharedInstance].userInfo.password;
    
    if (facebookID && fbAccessToken) {
        //Sign in Firebase with Facebook account
        FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:fbAccessToken];
        [[FIRAuth auth] signInAndRetrieveDataWithCredential:credential completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (!error) {
                if (authResult == nil) { return; }
                //FIRUser *user = authResult.user;
            } else {
                NSLog(@"FIRAuth -> signInWithFacebook error %@", error.localizedDescription);
            }
        }];
    } else if (email && password) {
        //Sign in Firebase with email/password
        [[FIRAuth auth] signInWithEmail:[SystemInfo sharedInstance].userInfo.email
                               password:[SystemInfo sharedInstance].userInfo.password
                             completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (!error) {
                if (authResult == nil) { return; }
                //FIRUser *user = authResult.user;
            } else {
                NSLog(@"FIRAuth -> signInWithEmail error %@", error.localizedDescription);
            }
        }];
    }
}

- (void)initFirebaseChat {
    [FirebaseHelper.sharedInstance configureFirebaseDB];
    [FirebaseHelper.sharedInstance configureFirebaseStorage];
}

- (void)configureFirebaseDB {
    fiDBRef = [[FIRDatabase database] reference];
}

- (void)configureFirebaseStorage {
    fiStorageRef = [[FIRStorage storage] reference];
}

- (void)signOut {
    FIRAuth *firebaseAuth = [FIRAuth auth];
    NSError *signOutError;
    BOOL status = [firebaseAuth signOut:&signOutError];
    if (!status) {
        NSLog(@"FIRAuth -> sign out error: %@", signOutError);
    }
}
@end
