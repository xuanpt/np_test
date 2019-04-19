//
// config.h
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#ifndef NewsPicks_config_h
#define NewsPicks_config_h

//================================ SERVER - ACCESS POINT CONSTANTS DEFINITION =====================
//#define USE_LOCAL_DEVELOP
#define USE_STAGE
//#define USE_PRODUCTION

#if defined(USE_STAGE)
#elif defined(USE_PRODUCTION)
#else
#define USE_LOCAL_DEVELOP
#endif


#ifdef USE_LOCAL_DEVELOP
    #define kServerAPIBaseURL @"http://localhost:8000/api"
#endif

#ifdef USE_STAGE
    #define kServerAPIBaseURL @"http://18.223.161.205/api"
#endif

#ifdef USE_PRODUCTION
    #define kServerAPIBaseURL @"http://18.223.161.205/api"
#endif


#define kParseAPIBaseURL        @"https://api.parse.com"
#define kParseAPIUniMatching    @"/1/functions/match_uni"
//#define kParseAPIUniMatching    @"https://api.algorithmia.com/v1/algo/globalacademics/Hello/0.1.1"
#define kParseAPIUploadFile     @"/1/files/"

#define		PREMIUM_LINK						@"http://www.relatedcode.com/realtimepremium"
#define		LINK_PARSE							@"https://files.parsetfss.com"
#define		MESSAGE_INVITE						@"Check out chatexamples.com"



#define kParseApplicationIDHeader           @"X-Parse-Application-Id"
#define kParseAPIKeyHeader                  @"X-Parse-REST-API-Key"
#define kParseMasterKeyHeader               @"X-Parse-Master-Key"

#define kParseApplicationID                 @"cUFot95ubjParhuEvu2axHJDewG35irpipbf3FVa"
#define kParseAPIKey                        @"Qor0QIBkVokd2PAo9QCLewSMdPhZ0DUdivHDT3qZ"
#define kParseClientKey                     @"SWVE9lZHKCbskdaEv3EAYqEsy2JXL2fjUco8BX3S"
#define kParseMasterKey                     @"C1I45JLqcAPEOCj7mbeMFknaj4deBkAoq8sYIsW5"


#define kStripePublishableKey               @"pk_live_EZL2Hs7HTTqxCaSN8ZMPCkCr"
#define kTestFairyServiceKey                @"b9b38e63c404d6934d619e2b85f13391a3589ffb"

#define kAlgorithmiaAPIKey                  @"Simple simDytfJl1YPb9ea34W0MwrpjVx1"


#define kAuthHeaderUsername                 @"admin"
#define kAuthHeaderPassword                 @"password"
#define kAPIHeaderNewsPicksUUID            @"X-NewsPicksUUID"
#define kAPIHeaderNewsPicksToken           @"X-NewsPicksToken"
#define kAPIHeaderDeviceType                @"X-DeviceType"
#define kAPIHeaderDeviceID                  @"X-DeviceID"

#define kHTTPContentType                    @"Content-Type"
#define kHTTPContentLength                  @"Content-Length"
#define kAuthorization                      @"Authorization"

#define kHTTPAccept                         @"Accept"
#define kHTTPPost                           @"POST"
#define kHTTPGet                            @"GET"
#define kHTTPDelete                         @"DELETE"
#define IGNORE_ALL_CACHE                    NO
#define CACHE_CONTROL_MAX_AGE               @"max-age=60"

#define kHTTPContentType_ApplicationJson    @"application/json"
#define kHTTPContentType_ImageJpeg          @"image/jpeg"



//================================ APP CONSTANTS DEFINITION =======================================
typedef NS_ENUM(int, RotationDirection) {
    RotationDirection_Clockwise = 0,
    RotationDirection_Counterclockwise = 1,
};

#define		VIDEO_LENGTH						5
#define		AFDOWNLOAD_TIMEOUT					300
#endif
