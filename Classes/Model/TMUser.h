//
//  TMUser.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface TMUser : NSObject

//Login info
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString  *firebaseID;
@property (nonatomic, strong) NSString  *facebookID;
@property (nonatomic, strong) NSString  *fbAccessToken;
@property (nonatomic, strong) NSString  *facebookEmail;
@property (nonatomic, strong) NSString  *email;
@property (nonatomic, strong) NSString  *password;
@property (nonatomic, strong) NSString  *mobile;

//Profile info
@property (nonatomic, strong) NSString  *familyName;
@property (nonatomic, strong) NSString  *nationality;
@property (nonatomic, strong) NSString  *birthday;
@property (nonatomic, strong) NSString  *language;
@property (nonatomic, strong) NSString  *profileImageURL;

@property (nonatomic, strong) NSString  *deviceToken;
@property (nonatomic, assign) NSInteger pushNotificationFlag;


//Map / location / last user info
@property (nonatomic, assign) CLLocationCoordinate2D    locationCoordinate;
@property (nonatomic, strong) GMSMarker                 *mapMarker;
@property (nonatomic, strong) NSDate                    *lastUpdatedAt;


@property (nonatomic, assign) NSInteger requesterID;
@property (nonatomic, assign) NSInteger statusToRequester;
@property (nonatomic, assign) NSInteger targeterID;
@property (nonatomic, assign) NSInteger statusToTargeter;

@property (nonatomic, assign) NSInteger distance2CurrentUser;

/*
 @property (nonatomic, assign) CLLocationCoordinate2D    targetLocationCoordinate;
 
@property (nonatomic, assign) UserType  userType;

//Driver info
@property (nonatomic, strong) NSString  *countryCode;
@property (nonatomic, strong) NSString  *mobileNumber;
@property (nonatomic, assign) CarType   carType;

@property (nonatomic, assign) float     price;
@property (nonatomic, assign) float     totalRatingPoint;


@property (nonatomic, assign) float                 driver_FareByCurrentBooking;
@property (nonatomic, assign) float                 driver_CalculatedFareByCurrentBooking;

@property (nonatomic, assign) DriverResponseType    driver_ResponseType;
@property (nonatomic, assign) BOOL                  driver_isHasDiscountFare;

@property (nonatomic, strong) NSString  *distanceToTargetLocation;
@property (nonatomic, strong) NSString  *timeToTargetLocationStr;
@property (nonatomic, assign) int       timeToTargetLocation;


//Dummy info
@property (nonatomic, strong) NSMutableArray            *dummyInstructions;
@property (nonatomic, assign) int                       dummyCurrentInstructionStep;
@property (nonatomic, strong) NSTimer                   *dummySimulateDriverTrafficTimmer;
@property (nonatomic, strong) NSTimer                   *dummySimulateDriverToPickUpLocationTimmer;
@property (nonatomic, strong) NSTimer                   *dummySimulateDriverToDropOffLocationTimmer;
*/


- (id)initWithDictionary:(NSDictionary*)userInfo;
- (void)updateLocationCoordinate:(CLLocationCoordinate2D)newLocationCoordinate;
- (void)updateTargetLocationCoordinate:(CLLocationCoordinate2D)newLocationCoordinate;
@end
