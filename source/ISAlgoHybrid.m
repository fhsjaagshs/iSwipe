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

@implementation ISAlgoWordSimilarity

static double getValue(ISData *data, ISWord* isword){
    int i = 1 ,j = 1;
    double val = BASE;
    NSArray *datakeys = data.keys;
    NSString *word = isword.match;
    
    int key_count = datakeys.count;
    char keys[key_count];
    double angles[key_count];
    
    int word_count = isword.match.length;
    char word[word_count];

    for (int i = 0; i < key_count; ++i) {
      keys[i] = [datakeys[i] letter];
    }
    
    for (int i = 0; i < key_count; ++i) {
      angles[i] = [datakeys[i] angle];
    }
    
    memset(word, '\0', sizeof(word)); // make sure word is empty
    strncpy(word, isword.match.UTF8String, word_count);
    
    // Now that we've dumped the ObjC BS

    double weight = 0;
    
    // keys:
    // sdfghit
    
    // words:
    // shut
    // shoot
    // suit
    // soot
    // slit
    // shit
    
    // two pass
    // pass one:
    // eliminate impossible words (slit, soot, shoot shut)
    
    // TODO: inner loop on the word, not the swipe (word is probably shorter than swipe)
    // iterate through word
    for (int i = 0; i < word_count; i++) {
      char w = word[i];
      
      int plausible = 0;
      
      // check each character in the swipe against the word
      // If the 
      for (int j = 0; j < key_count; j++) {
        char k = key[j];
        
        if (k == w) {
          plausible = 1;
        }
      }
      
      if (plausible == 0) {
        weight = -1;
      }
    }  
    
    // The word was not plausible
    if (weight == -1) return -1;
    
    
    // pass two:
    // check info about words

    for (int i = 0; i < word_count; i++) {
      char w = word[i];
      
      // check each char against the word
      for (int j = 0; j < key_count; j++) {
        char k = keys[j];
        double angle = angles[j];
        
        double w_addition = (w == k) ? 2 : 1;
        
        // if the angle indicates passing up, multiply addition to weight by 0.5
        if (angle > 160 && angle < 200) w_addition *= 0.5;
      }
    }    
    
    return weight;
}

+ (NSMutableArray *)findMatch:(ISData *)data dict:(NSArray *)dict {
  NSMutableArray *matches = [NSMutableArray array];
	
  for (ISWord *isword in dict) {
    double val = getValue(data, isword);
    isword.weight = val;
    if (val == -1) [matches addObject:isword];
  }

  return matches;
}

@end