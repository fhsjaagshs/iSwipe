#import "ISScribbleView.h"
#import "ISDefines.h"
#import "headers/UIKeyboard.h"

#define PTSLIM 300

@interface ISScribbleView ()

@property (nonatomic, strong) NSMutableArray *points;

@end

@implementation ISScribbleView

- (void)show {
	self.isVisible = YES;
  UIKeyboard *kb = [UIKeyboard activeKeyboard];
  self.frame = CGRectMake(0,0,kb.frame.size.width, kb.frame.size.height);
  [kb addSubview:self];
}

- (void)hide {
	self.isVisible = NO;
	[self removeFromSuperview];
}

- (void)resetPoints {
	[self.points removeAllObjects];
}

- (instancetype)init {
	self = [super init];
	if (self) {
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.points = [[NSMutableArray alloc]initWithCapacity:PTSLIM];
	}
	return self;
}

- (double)length {
  if (_points.count == 0) return 0;
	
  double tot = 0;
  CGPoint p = [_points.firstObject CGPointValue];
  for (int i = 1; i < _points.count; i += 2){
    CGPoint p2 = [_points[i] CGPointValue];
    tot += dist(p2.x-p.x, p2.y-p.y);
    p = p2;
  }
  return tot;
}

- (void)drawRect:(CGRect)rect {
  int pointsCount = _points.count;
	
  if (pointsCount > 0) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 7.5);
    CGContextSetRGBStrokeColor(context, 0, .58, .9, 1);
    
    CGPoint point = [_points.firstObject CGPointValue];
    CGContextMoveToPoint(context, point.x, point.y);

    for (int i = 1; i < pointsCount; i++) {
      point = [_points[i] CGPointValue];
      CGContextSetRGBStrokeColor(context, 0, .58, .9, pow((double)i/pointsCount, .7));
      CGContextSetLineWidth(context, pow((double)i/pointsCount, .55)*9);
      CGContextAddLineToPoint(context, point.x, point.y);
      CGContextStrokePath(context);
      CGContextMoveToPoint(context, point.x, point.y);
    }
	}
}

- (void)drawToTouch:(UITouch *)touch{
	if (!touch) return;
	
  CGPoint point = [touch locationInView:touch.view];
	
	while (self.length > PTSLIM) {
    [self.points removeObjectAtIndex:0];
	}
	
  [_points addObject:[NSValue valueWithCGPoint:point]];
	
  [self setNeedsDisplay];
}

@end