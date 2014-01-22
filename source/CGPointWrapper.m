#import "CGPointWrapper.h"

@implementation CGPointWrapper

+ (CGPointWrapper *)wrapperWithPoint:(CGPoint)p {
    CGPointWrapper *wrap = [[CGPointWrapper alloc] init];
    wrap.point = p;
    return wrap;
}

@end
