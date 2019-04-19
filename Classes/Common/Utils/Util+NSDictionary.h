//
//  Util+NSDictionary.h
// NewsPicks
//
//  Created by Tran Minh Thuan on 5/15/15.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Util)

- (NSString *)stringValueForKey:(NSString *)key;
- (NSString *)stringValueForKeyPath:(NSString *)key;
- (int)intValueForKey:(NSString *)key;
- (int)intValueForKeyPath:(NSString *)key;

//TODO - write functions to format price/datetime/...
- (NSString *)dateStringForKey:(NSString *)key format:(NSString *)format;
- (NSString *)dateStringForKeyPath:(NSString *)key format:(NSString *)format;
- (NSString *)priceStringForKey:(NSString *)key currency:(NSString *)currency;
- (NSString *)priceStringForKeyPath:(NSString *)key currency:(NSString *)currency;

@end
