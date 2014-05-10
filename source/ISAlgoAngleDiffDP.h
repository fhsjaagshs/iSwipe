//
//  ISAlgoAngleDiffDP.h
//  iSwipe
//
//  Created by Andrew Liu on 6/11/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import <Foundation/Foundation.h>

//find best possible matching
//in practice there is little, if any, difference from greedy
@interface ISAlgoAngleDiffDP : NSObject

+ (NSArray *)findMatch:(NSArray *)keys fromWords:(NSArray *)words;

@end
