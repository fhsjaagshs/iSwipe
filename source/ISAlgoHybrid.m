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

static double calcWeight(NSArray *keys, NSString *word){
	int i = 1;
	int j = 1;
	double val = BASE;

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
    
    NSMutableArray *vettedkeys = [NSMutableArray array];
    
     [vettedkeys addObject:keys.firstObject];
     for (int i = 1; i < keys.count-1; i++) {
         ISKey *key = keys[i];
     
         CGPoint keyCenter = CGPointMake(key.frame.origin.x+(key.frame.size.width/2), key.frame.origin.y+(key.frame.size.height/2));
         
         double acceptedRadius = (MIN(key.frame.size.width, key.frame.size.height)*2)/3;
         double distToKeyCenter = dist(keyCenter.x-key.avg.x, keyCenter.y-key.avg.y);
         
         if (distToKeyCenter <= acceptedRadius && i != keys.count-1) [vettedkeys addObject:key];
     }
     [vettedkeys addObject:keys.lastObject];

	NSMutableArray *rows = [NSMutableArray array];
  
	for (ISKey *iskey in vettedkeys) {
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
      double val = calcWeight(vettedkeys, word.match);
      word.weight = val*(1+0.5*(wordcount-ct)/wordcount);
      
      if (val != -1) [matches addObject:word];
            
      ct++;
    }
  }
  
  return [matches sortedArrayUsingSelector:@selector(compare:)];
}

@end