//
//  Util+NSDictionary.m
// NewsPicks
//
//  Created by Tran Minh Thuan on 5/15/15.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import "Util+NSDictionary.h"

@implementation NSDictionary (Util)

- (NSString *)stringValueForKey:(NSString *)key {
    NSString *ret = [NSString stringWithFormat:@"%@", [self valueForKey:key]];
    if (!ret) ret = @"-";
    return ret;
}

- (NSString *)stringValueForKeyPath:(NSString *)key {
    NSString *ret =  [NSString stringWithFormat:@"%@", [self valueForKeyPath:key]];
    if (!ret) ret = @"-";
    return ret;
}

- (int)intValueForKey:(NSString *)key {
    return [[self valueForKey:key] intValue];
}

- (int)intValueForKeyPath:(NSString *)key {
    return [[self valueForKeyPath:key] intValue];
}

- (NSString *)dateStringForKey:(NSString *)key format:(NSString *)format {
    return [self stringValueForKey:key];
}

- (NSString *)dateStringForKeyPath:(NSString *)key format:(NSString *)format {
    return [self stringValueForKeyPath:key];
}

- (NSString *)priceStringForKey:(NSString *)key currency:(NSString *)currency {
    return [self stringValueForKey:key];
}

- (NSString *)priceStringForKeyPath:(NSString *)key currency:(NSString *)currency {
    return [self stringValueForKeyPath:key];
}

@end
