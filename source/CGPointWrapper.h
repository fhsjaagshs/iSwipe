#import <UIKit/UIKit.h>

@interface CGPointWrapper : NSObject

@property (nonatomic, assign) CGPoint point;

+ (CGPointWrapper *)wrapperWithPoint:(CGPoint)p;

@end
