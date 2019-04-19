#import <Foundation/Foundation.h>

@interface NSDictionary (CHECKNULL)

- (BOOL)isNullValue:(NSString *)key;

- (id)nsnullAsNil:(NSString *)key;
- (BOOL)nsnullAsNo:(NSString *)key;
- (NSInteger)nsnullAsZero:(NSString *)key;
- (NSInteger)nsnullAsDefaultInteger:(NSString *)key;

@end
