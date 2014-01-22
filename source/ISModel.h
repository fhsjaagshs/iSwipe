#import "CGPointWrapper.h"
#import "ISData.h"
#import "ISKey.h"
#import "ISAlgoAngleDiffGreedy.h"
#import "ISAlgoAngleDiffDP.h"

@interface ISModel : NSObject 

+ (ISModel *)sharedInstance;
- (NSArray *)findMatch:(ISData *)data;

@end
