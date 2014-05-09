//
//  ISAlgoHybrid.m
//  iSwipe
//
//  Created by Nathaniel Symer on 5/7/14.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "ISAlgoHybrid.h"

#import "ISDefines.h"
#import "ISData.h"
#import "ISKey.h"
#import "ISWord.h"

@implementation ISAlgoHybrid

static double getValue(ISData *data, ISWord* isword){
	int i = 1;
	int j = 1;
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
    
	if (i != word.length) return -1;
    
	return val;
}

+ (NSMutableArray *)findMatch:(ISData *)data dict:(NSArray *)dict {
	NSArray *keyboardLayout = @[@"qwertyuiop", @"asdfghjkl", @"zxcvbnm"];

	NSArray *keys = data.keys;
	
	NSMutableArray *rows = [NSMutableArray array];
  
	for (ISKey *iskey in keys) {
		char key = iskey.letter;
		for (int i = 0; i < keyboardLayout.count; i++) {
			NSString *row = keyboardLayout[i];
			
			for (int j = 0; j < row.length; j++) {
				if ([row characterAtIndex:j] == key) {
					[rows addObject:@(i)];
					break;
				}
			}
		}
	}
  
  NSMutableArray *rows_compressed = [NSMutableArray array];
  
  for (NSNumber *num in rows) {
    if (rows_compressed.count > 0 && [rows_compressed.lastObject intValue] != num.intValue) {
      [rows_compressed addObject:num];
    }
  }              
            
	int minLength = rows_compressed.count;

  NSMutableArray *matches = [NSMutableArray array];
    
	int ct = 0;
	for (ISWord *word in dict) {
		if (word.match.length > minLength) {
			double val = getValue(data, word);
			word.weight = val*(1+0.5*((int)dict.count-ct)/dict.count);
            
			if (val != -1) [matches addObject:word];
            
			ct++;
		}
	}
  
  return matches;
}

@end