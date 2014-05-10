//
//  ISAlgoHybrid.h
//  iSwipe
//
//  Created by Nathaniel Symer on 5/7/14.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ISData;
@interface ISAlgoHybrid : NSObject

+ (NSArray *)findMatch:(NSArray *)keys fromWords:(NSArray *)words;

@end