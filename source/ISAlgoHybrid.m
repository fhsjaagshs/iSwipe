//
//  ISAlgoHybrid.m
//  iSwipe
//
//  Created by Nathaniel Symer on 5/7/14.
//  Copyright (c) 2012 Nathaniel Symer. All rights reserved.
//

#import "ISAlgoHybrid.h"
#import "ISAlgoAngleDiffGreedy.h"

#import "ISDefines.h"
#import "ISData.h"
#import "ISKey.h"
#import "ISWord.h"

@implementation ISAlgoHybrid

+ (NSMutableArray *)findMatch:(ISData *)data dict:(NSArray *)dict {
	NSArray *kKeyboardLayout = @[@"qwertyuiop", @"asdfghjkl", @"zxcvbnm"];

	NSArray *keys = data.keys;
	
	NSMutableArray *rows = [NSMutableArray array];
  
	for (ISKey *iskey in keys) {
		char key = iskey.letter;
		for (int i = 0; i < kKeyboardLayout.count; i++) {
			NSString *row = kKeyboardLayout[i];
			
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
    if (rows_compressed.count > 0 && [rows_compressed.lastObject intValue] != [num intValue]) {
      [rows_compressed addObject:num];
    }
  }              
            
	int minLength = rows_compressed.count;
  
  NSMutableArray *greedy = [ISAlgoAngleDiffGreedy findMatch:data dict:dict];
  
  NSMutableArray *matches = [NSMutableArray array];
  
  for (ISWord *word in greedy) {
    if (word.match.length > minLength) [matches addObject:word];
  }
  
  return matches;
  
	/*
 // NSMutableArray *anglediffgreedy = [ISAlgoAngleDiffGreedy findMatch:data dict:dict];
	NSMutableArray *matches = [NSMutableArray array];
    
	for (ISWord *isword in dict) {
		NSString *match = isword.match;
		int i = 0;
      
		for (ISKey *key in keys) {
			for (int j = 0; j < match.length; j++) {
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
  
	// now add a weight to each word
	int currWeight = matches.count;
    
	for (ISWord *isword in matches) {
		isword.weight = currWeight;
		currWeight -= 1;
	}
  
  return matches;*/
}

@end