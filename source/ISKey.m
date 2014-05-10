//
//  ISKey.m
//  iSwipe
//
//  Created by Andrew Liu on 6/4/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISKey.h"
#import "ISDefines.h"

@implementation ISKey

+ (ISKey *)keyWithTree:(UIKBTree *)tree {
	return [[[self class]alloc]initWithTree:tree];
}

- (instancetype)initWithTree:(UIKBTree *)tree {
	self = [super init];
	if (self) {
	  _angle = 0;
	  _letter = [tree.displayString.lowercaseString characterAtIndex:0];
	  _pts = [NSMutableArray array];
		_tree = tree;
	}
	return self;
}

- (CGRect)frame {
    return _tree.frame;
}

- (void)addPoint:(CGPoint)p {
  [_pts addObject:[NSValue valueWithCGPoint:p]];
}

static inline double calcAngle(CGPoint p1, CGPoint p2, CGPoint p3){
  return vecAng(p1.x-p2.x, p1.y-p2.y, p2.x-p3.x, p2.y-p3.y);
}

// This method is both over-engineered and 
// Over optimized. I know.
- (void)compute {
  if (_pts.count >= 3) {
    CGPoint p1 = [_pts.lastObject CGPointValue];
    CGPoint p2 = CGPointZero;
    CGPoint p3 = [_pts.firstObject CGPointValue];
        
    // find farthest point away from p1 and p2
    // & calc avg along the way
    double max = 0;
    float tx = 0, ty = 0;
		
    for (NSValue *value in _pts) {
      CGPoint pp = value.CGPointValue;
      double dt = dist(pp.x-p1.x, pp.y-p1.y) + dist(pp.x-p3.x,pp.y-p3.y);
      if (dt > max) {
        max = dt;
        p2 = pp;
      }
			
      tx += pp.x;
      ty += pp.y;
		}
		
    self.angle = calcAngle(p1, p2, p3);
    _avg = CGPointMake(tx/_pts.count, ty/_pts.count);
  } else {
    // Only two points so calcAngle() makes no sense
    float tx = 0, ty = 0;
    
    for (NSValue *value in _pts) {
      CGPoint pp = value.CGPointValue;
      tx += pp.x;
      ty += pp.y;
    }
    
    _avg = CGPointMake(tx/_pts.count, ty/_pts.count);
		
    // TODO: Potentially set angle to 180??? Would this skew towards words that are
  }
}

@end