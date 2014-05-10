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

+ (NSArray *)findMatch:(ISData *)data fromWords:(NSArray *)words {
    NSMutableArray *matches = [NSMutableArray array];
	
    int ct = 0;
    for (ISWord *word in words) {
        double val = getValue(data, word);
        word.weight = val*(1+0.5*((int)words.count-ct)/words.count);
		
        if (val != BAD) [matches addObject:word];
		
        ct++;
    }
    
    return [matches sortedArrayUsingSelector:@selector(compare:)];
}

@end