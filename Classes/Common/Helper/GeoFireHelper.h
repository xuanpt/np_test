//
//  GeoFireHelper.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Firebase/Firebase.h>
//#import <GeoFire/GeoFire.h>

@interface GeoFireHelper : NSObject

+ (GeoFireHelper *)sharedInstance;

- (void)settingGeoFire:(CLLocation*)location;

- (void)saveLocation:(NSString*)key location:(CLLocation *)newLocation completed:(void (^)(NSError *error))completed;

- (void)getLocation:(NSString*)key completed:(void (^)(CLLocation *location, NSError *error))completed;

- (void)deleteLocation:(NSString*)key completed:(void (^)(NSError *error))completed;

@end
