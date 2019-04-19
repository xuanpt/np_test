//
//  GeoFireHelper.m
// TravelerMatching
//
//  Created by Xuan Pham on 4/12/15.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import "GeoFireHelper.h"

@implementation GeoFireHelper {
    GeoFire *geoFire;
}


+ (GeoFireHelper *)sharedInstance {
    static GeoFireHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GeoFireHelper alloc] init];
    });
    return _sharedInstance;
}



- (id)init {
    self = [super init];
    if(self) {
        geoFire = [[GeoFire alloc] initWithFirebaseRef:[[Firebase alloc] initWithUrl:FIREBASE_URL]];
    }
    return self;
}



- (void)settingGeoFire:(CLLocation*)location {
    //Doc: https://github.com/firebase/geofire-objc
    /*
     CLLocation *center = [[CLLocation alloc] initWithLatitude:37.7832889 longitude:-122.4056973];
     // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
     GFCircleQuery *circleQuery = [geoFire queryAtLocation:center withRadius:0.6];
     
     // Query location by region
     MKCoordinateSpan span = MKCoordinateSpanMake(0.001, 0.001);
     MKCoordinateRegion region = MKCoordinateRegionMake(center.coordinate, span);
     GFRegionQuery *regionQuery = [geoFire queryWithRegion:region];
     */
    
    
    GFQuery *query = [geoFire queryAtLocation:location withRadius:5000];
    
    
    [query observeEventType:GFEventTypeKeyEntered withBlock:^(NSString *key, CLLocation *location) {
        if (key != nil && location != nil) {
            NSDictionary* userInfo = @{
                                        @"EventType"    : @"KeyEntered",
                                        @"Key"          : key,
                                        @"Location"     : location
                                      };
            [[NSNotificationCenter defaultCenter] postNotificationName:kGeoFireEventNotification object:nil userInfo:userInfo];
        }
    }];
    
    
    [query observeEventType:GFEventTypeKeyExited withBlock:^(NSString *key, CLLocation *location) {
        if (key != nil && location != nil) {
            NSDictionary* userInfo = @{
                                        @"EventType"    : @"KeyExited",
                                        @"Key"          : key,
                                        //@"Location"     : location
                                      };
            [[NSNotificationCenter defaultCenter] postNotificationName:kGeoFireEventNotification object:nil userInfo:userInfo];
        }
    }];
    
    
    [query observeEventType:GFEventTypeKeyMoved withBlock:^(NSString *key, CLLocation *location) {
        if (key != nil && location != nil) {
            NSDictionary* userInfo = @{
                                        @"EventType"    : @"KeyMoved",
                                        @"Key"          : key,
                                        @"Location"     : location
                                      };
            [[NSNotificationCenter defaultCenter] postNotificationName:kGeoFireEventNotification object:nil userInfo:userInfo];
        }
    }];
}



- (void)saveLocation:(NSString*)key location:(CLLocation *)newLocation completed:(void (^)(NSError *error))completed {
    if (key == nil) return;
    
    [geoFire setLocation:newLocation forKey:key withCompletionBlock:^(NSError *error) {
        if (completed) completed(error);
    }];
    
    /*
     if (user != nil) {
     Firebase *firebaseRootRef = [[Firebase alloc] initWithUrl:FIREBASE_URL];
     Firebase *userRef = [firebaseRootRef childByAppendingPath:ConcatString(@"data/users/", user.objectId)];
     
     [userRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
     if (snapshot.value == [NSNull null]) {
     NSDictionary *userInfo = @{
     @"user_id"     : user.objectId,
     @"name"        : user[PF_USER_FULLNAME],
     @"lat"         : @(coordinate.latitude),
     @"long"        : @(coordinate.longitude),
     @"time_stamp"  : @([[NSDate date] timeIntervalSince1970])
     };
     
     [userRef setValue: userInfo];
     } else {
     NSDictionary *userInfo = @{
     @"lat"         : @(coordinate.latitude),
     @"long"        : @(coordinate.longitude),
     @"time_stamp"  : @([[NSDate date] timeIntervalSince1970])
     };
     
     [userRef updateChildValues: userInfo];
     }
     
     sendInfoLabel.text = [NSString stringWithFormat:@"user_id:%@-lat:%f-long:%f", user.objectId, coordinate.latitude, coordinate.longitude];
     }];
     
     
     [geoFire setLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] forKey:user.objectId
     withCompletionBlock:^(NSError *error) {
     if (error != nil) {
     NSLog(@"An error occurred: %@", error);
     } else {
     NSLog(@"Saved location successfully!");
     }
     }];
     }
     */
}



- (void)getLocation:(NSString*)key completed:(void (^)(CLLocation *location, NSError *error))completed {
    if (key == nil) return;
    
    [geoFire getLocationForKey:key withCallback:^(CLLocation *location, NSError *error) {
        if (completed) completed(location, error);
        
        /*
        //Caller checking
         
        if (error != nil) {
            NSLog(@"An error occurred getting the location: %@", [error localizedDescription]);
        } else if (location != nil) {
            NSLog(@"Location is [%f, %f]",
                  location.coordinate.latitude,
                  location.coordinate.longitude);
        } else {
            NSLog(@"GeoFire does not contain location");
        }
         */
    }];
}


- (void)deleteLocation:(NSString*)key completed:(void (^)(NSError *error))completed {
    if (key == nil) return;
    
    [geoFire removeKey:key withCompletionBlock:^(NSError *error) {
        if (completed) completed(error);
    }];
}


@end
