#import "NSDictionary+NULL.h"

@implementation NSDictionary (CHECKNULL)

- (BOOL)isNullValue:(NSString *)key
{
    if (![self objectForKey:key]) {
        return YES;
    }
    if ([self[key] isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

- (id)nsnullAsNil:(NSString *)key
{
    if (![self objectForKey:key] || [self isNullValue:key]) {
        return nil;
    }
    return [self objectForKey:key];
}

- (BOOL)nsnullAsNo:(NSString *)key
{
    if (![self objectForKey:key] || [self isNullValue:key]) {
        return NO;
    }
    return [[self objectForKey:key] boolValue];
}

- (NSInteger)nsnullAsZero:(NSString *)key
{
    if (![self objectForKey:key] || [self isNullValue:key]) {
        return 0;
    }
    return [[self objectForKey:key] integerValue];
}

- (NSInteger)nsnullAsDefaultInteger:(NSString *)key
{
    if (![self objectForKey:key] || [self isNullValue:key]) {
        return kDefaultNullInteger;
    }
    return [[self objectForKey:key] integerValue];
}

@end
