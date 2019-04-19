//
//  NSURLRequest+NewsPicks.m
// NewsPicks
//
//  Created by Xuan Pham on 15/04/2019.
//  Copyright (c) 2019 Xuan Pham. All rights reserved.
//

#import "NSURLRequest+NewsPicks.h"

@implementation NSString (Contains)
- (BOOL)myContainsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}
@end

@implementation NSURLRequest(NewsPicks)
- (NSURLRequest*)requestWithCachePolicyModified {
    
    NSMutableURLRequest *modifiedRequest = self.mutableCopy;
    
    BOOL willCache = [self.HTTPMethod isEqualToString:@"GET"];
    
    // Ignore cache for the following request
    if ([self.HTTPMethod isEqualToString:@"GET"]) {
        for (NSString *ignoredAPI in [self cacheIgnoredAPIs]) {
            if ([[self.URL absoluteString] myContainsString:ignoredAPI])
                willCache = NO;
        }
    }
    
    if ([self ignoreAll]) willCache = NO;
    
    if (!willCache) modifiedRequest.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    return modifiedRequest;
}

- (NSArray*)cacheIgnoredAPIs {
    return @[];
}

- (BOOL)ignoreAll {
    return NO;
}

@end
