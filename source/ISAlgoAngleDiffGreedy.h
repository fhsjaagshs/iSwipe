//
//  ISAlgoAngleDiffGreedy.h
//  iSwipe
//
//  Created by Andrew Liu on 6/5/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import <Foundation/Foundation.h>

// Matches the first possible char it can match

@class ISData;
@interface ISAlgoAngleDiffGreedy : NSObject

+ (NSArray *)findMatch:(ISData *)data fromWords:(NSArray *)words;

@end
