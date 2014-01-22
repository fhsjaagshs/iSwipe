//
//  ISWord.m
//  iSwipe
//
//  Created by Andrew Liu on 6/5/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISWord.h"

@implementation ISWord

+ (ISWord *)word:(NSString *)word match:(NSString *)m weight:(double)wei {
    ISWord *w = [[ISWord alloc]init];
    w.word = word;
    w.weight = wei;
    w.match = m;
    return w;
}

- (NSComparisonResult)compare:(ISWord *)obj{
    if(_weight>obj.weight) return NSOrderedAscending;
    if(_weight<obj.weight) return NSOrderedDescending;
    if(_word.length<obj.word.length) return NSOrderedAscending;
    if(_word.length>obj.word.length) return NSOrderedDescending;
    return NSOrderedSame;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@(%@) - %.2f",_word,_match,_weight];
}

@end
