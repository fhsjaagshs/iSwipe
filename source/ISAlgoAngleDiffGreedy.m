//
//  ISAlgoAngleDiffGreedy.mm
//  iSwipe
//
//  Created by Andrew Liu on 6/5/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISAlgoAngleDiffGreedy.h"
#import "ISDefines.h"
#import "ISData.h"
#import "ISKey.h"
#import "ISWord.h"

@implementation ISAlgoAngleDiffGreedy

static double getValue(ISData *data, ISWord* isword){
    int i = 1 ,j = 1;
    double val = BASE;
    NSArray *keys = data.keys;
    NSString *word = isword.match;
    
    for ( ; i < word.length && j < keys.count; j++) {
        char currentKeyLetter = [keys[j] letter];
        if ([word characterAtIndex:i] == currentKeyLetter) {
            while (++i < word.length && [word characterAtIndex:i] == currentKeyLetter) {
                val += BONUS;
            }
            val += [(ISKey *)keys[j] angle];
        }
    }
    
    if (i != word.length) val = BAD; // not possible
    
    return val;
}

+ (NSMutableArray *)findMatch:(ISData *)data dict:(NSArray *)dict {
    NSMutableArray *arr = [NSMutableArray array];
	
    int ct = 0;
    for (ISWord *str in dict) {
        double val = getValue(data, str);
        str.weight = val*(1+0.5*((int)dict.count-ct)/dict.count);
		
        if (val != BAD) [arr addObject:str];
		
        ct++;
    }
    
    return arr;
}

@end