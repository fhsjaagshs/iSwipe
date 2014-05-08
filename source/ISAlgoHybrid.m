//
//  ISAlgoHybrid.m
//  iSwipe
//
//  Created by Nathaniel Symer on 5/7/14.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

//static int const straight_angle_leeway = 10;

#import "ISAlgoHybrid.h"

#import "ISDefines.h"
#import "ISData.h"
#import "ISKey.h"
#import "ISWord.h"

@implementation ISAlgoHybrid

// From ISAlgoAngleDiffGreedy
/*static double getValue(ISData *data, ISWord* isword) {
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
}*/

+ (NSMutableArray *)findMatch:(ISData *)data dict:(NSArray *)dict {
	NSArray *kKeyboardLayout = @[@"qwertyuiop", @"asdfghjkl", @"zxcvbnm"];

	NSArray *keys = data.keys;
	
	NSMutableArray *rows = [NSMutableArray array];
  
	for (ISKey *iskey in keys) {
		char key = iskey.letter;
		for (int i = 0; i < kKeyboardLayout.count; i++) {
			if ([rows.lastObject intValue] != i) {
				NSString *row = kKeyboardLayout[i];
			
				for (int j = 0; i < row.length; j++) {
					char curr = [row characterAtIndex:j];
					if (curr == key) {
						[rows addObject:@(i)];
						break;
					}
				}
			}
		}
	}
            
	int minLength = rows.count;
	
	char firstKey = [keys.firstObject letter];
	char lastKey = [keys.lastObject letter];
	
	NSMutableArray *matches = [NSMutableArray array];
    
	for (ISWord *isword in dict) {
		NSString *match = isword.match;
		
		if ([match characterAtIndex:0] == firstKey && [match characterAtIndex:match.length-1] == lastKey) {
			int i = 0;
        
			for (ISKey *key in keys) {
				for (int j = 0; i < match.length; j++) {
					char curr = [match characterAtIndex:j];
					if (curr == key.letter) {
						i += 1;
						break;
					}
				}
			}
        
			if (i == match.length) {
				if (isword.match.length > minLength) [matches addObject:isword];
			}
		}
	}
  
	//
	// now add a weight to each word
	//
	
	int currWeight = matches.count;
    
	for (ISWord *isword in containsWord) {
		isword.weight = currWeight;
		currWeight -= 1;
	}
    
	return matches;
}

@end