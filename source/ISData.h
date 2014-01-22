#import <Foundation/Foundation.h>

@class ISKey;

@interface ISData : NSObject

@property (nonatomic, strong) ISKey *cur;
@property (nonatomic, strong) NSMutableArray *keys;

- (void)addData:(CGPoint)p forKey:(NSString *)k;
- (void)end;

- (NSArray *)findMatches;

@end
