//
//  GeoFireHelper.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import "GeoFireHelper.h"

@implementation GeoFireHelper {
    //GeoFire *geoFire;
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
        //geoFire = [[GeoFire alloc] initWithFirebaseRef:[[Firebase alloc] initWithUrl:FIREBASE_URL]];
    }
    return self;
}



- (void)settingGeoFire:(CLLocation*)location {
    
}



- (void)saveLocation:(NSString*)key location:(CLLocation *)newLocation completed:(void (^)(NSError *error))completed {
   
}



- (void)getLocation:(NSString*)key completed:(void (^)(CLLocation *location, NSError *error))completed {
    
}


- (void)deleteLocation:(NSString*)key completed:(void (^)(NSError *error))completed {
    
}


@end
