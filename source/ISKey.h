//
//  ISKey.h
//  iSwipe
//
//  Created by Andrew Liu on 6/4/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIKBTree;
@interface ISKey : NSObject

@property (nonatomic, assign) char letter;
@property (nonatomic, assign) double angle;
@property (nonatomic, assign) BOOL intentional;
@property (nonatomic, strong) NSMutableArray *pts;
@property (nonatomic, readonly) CGPoint avg;
@property (nonatomic, strong) UIKBTree *tree;

+ (ISKey *)keyWithLetter:(char)c;
- (void)add:(CGPoint)p;
- (void)compute;

@end
