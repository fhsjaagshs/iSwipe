//
//  ISAlgoHybrid.m
//  iSwipe
//
//  Created by Nathaniel Symer on 5/7/14.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "ISAlgoHybrid.h"

#import "ISDefines.h"
#import "ISKey.h"
#import "ISWord.h"

@implementation ISAlgoHybrid

static double calcWeight(NSArray *keys, ISWord *isword){
	int i = 1;
	int j = 1;
	double val = BASE;
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

+ (NSArray *)findMatch:(NSArray *)keys fromWords:(NSArray *)words {
	NSArray *keyboardLayout = @[@"qwertyuiop", @"asdfghjkl", @"zxcvbnm"];

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
  
  for (int i = 0; i < rows.count; i++) {
    NSNumber *num = rows[i];
    if (i+1 < rows.count && [rows[i+1] intValue] != num.intValue) {
      [rows_compressed addObject:num];
    }
  }
  
  int minLength = rows_compressed.count;
  int wordcount = (int)words.count;
  
  // TODO: min length based on numbers of 0 degree key angles

  NSMutableArray *matches = [NSMutableArray array];
    
  int ct = 0;
  for (ISWord *word in words) {
    if (word.match.length >= minLength) {
      double val = calcWeight(keys, word);
      word.weight = val*(1+0.5*(wordcount-ct)/wordcount);
      
      if (val != -1) [matches addObject:word];
            
      ct++;
    }
  }
  
  return [matches sortedArrayUsingSelector:@selector(compare:)];
}

@end