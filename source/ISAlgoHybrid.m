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

/*static double getValue(ISData *data, ISWord* isword){
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
    
    // now time to check order
    // If it's in order, multiply by two

    int word_count = word.length;
    char cword[word_count];
    memset(cword, '\0', sizeof(cword)); // make sure word is empty
    strncpy(cword, word.UTF8String, word_count);
    
    int prevIndex = -1;
    
    int bestIndex = 0;
    
    for (ISKey *key in keys) {
        int idx = -1;

        for (int i = prevIndex+1; i < word_count; i++) {
            if (cword[i] == key.letter) {
                idx = i;
                break;
            }
        }
        
        if (idx > bestIndex) {
            bestIndex = idx;
        }
    }
    
    if (bestIndex == word_count-1) {
        val *= 2;
    }

    return val;
}*/

/*static double getValue_inner_c(ISData *data, ISWord* isword){
    NSArray *datakeys = data.keys;
    
    int key_count = datakeys.count;
    char keys[key_count];
    double angles[key_count];
    
    int word_count = isword.match.length;
    char word[word_count];
    
    for (int i = 0; i < key_count; ++i) {
        keys[i] = [datakeys[i] letter];
        angles[i] = [(ISKey *)datakeys[i] angle];
    }
    
    memset(word, '\0', sizeof(word)); // make sure word is empty
    strncpy(word, isword.match.UTF8String, word_count);
    
    // Now that we've dumped the ObjC BS
    
    // sdfghiuyt
    // shit
    
    // dfghiuy
    // hi
    
 
    // first, strip off outer character on either end
    
    char inner_word[word_count-2];
    
    for (int i = 1; i < word_count-1; ++i) {
        inner_word[i] = word[i];
    }
    
    char inner_keys[key_count-2];
    double inner_angles[key_count-2];
    
    for (int i = 1; i < key_count-1; ++i) {
        inner_keys[i] = keys[i];
        inner_angles[i] = angles[i];
    }
    
    word_count -= 2;
    key_count -= 2;
 
     //now check if the word is supported by the keys' characters
    
    for (int i = 0; i < word_count; i++) {
        char w = inner_word[i];
        
        int plausible = 0;
        for (int j = 0; j < key_count; j++) {
            if (inner_keys[i] == w) {
                plausible = 1;
            }
        }
        
        if (plausible) {
            return -1;
            break;
        }
    }
 
    // now weight the words by angle

    double weight = 0;
    
    int i = 1 ,j = 1;
    for ( ; i < word_count && j < key_count; j++) {
        char currentKeyLetter = inner_keys[j];
        if (inner_word[i] == currentKeyLetter) {
            while (++i < word_count && inner_word[i] == currentKeyLetter) {
                weight -= 5;
            }
            weight += inner_angles[j];
        }
    }
    
    if (i != word_count) return -1;
    
    
    return weight;
}*/

/*static double getValue_greedy(ISData *data, ISWord* isword){
    NSArray *datakeys = data.keys;
    
    int key_count = datakeys.count;
    char keys[key_count];
    double angles[key_count];
    
    int word_count = isword.match.length;
    char word[word_count];
    
    for (int i = 0; i < key_count; ++i) {
        keys[i] = [datakeys[i] letter];
        angles[i] = [(ISKey *)datakeys[i] angle];
    }
    
    memset(word, '\0', sizeof(word)); // make sure word is empty
    strncpy(word, isword.match.UTF8String, word_count);
    
    // Now that we've dumped the ObjC BS
    
    double weight = 0;
    
    int i = 1 ,j = 1;
    for ( ; i < word_count && j < key_count; j++) {
        char currentKeyLetter = keys[j];
        if (word[i] == currentKeyLetter) {
            while (++i < word_count && word[i] == currentKeyLetter) {
                weight -= 5;
            }
            weight += angles[j];
        }
    }
    
    if (i != word_count) return -1;
    
    return weight;
}

static double getValue_original(ISData *data, ISWord* isword){
    NSArray *datakeys = data.keys;
    
    int key_count = datakeys.count;
    char keys[key_count];
    double angles[key_count];
    
    int word_count = isword.match.length;
    char word[word_count];

    for (int i = 0; i < key_count; ++i) {
      keys[i] = [datakeys[i] letter];
      angles[i] = [(ISKey *)datakeys[i] angle];
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
      
      int plausible = 1;
      
      // check each character in the swipe against the word
      // If the 
      for (int j = 0; j < key_count; j++) {
        char k = keys[j];
        
        if (k != w) {
          plausible = 0;
          break;
        }
      }
      
      if (plausible == 0) {
        weight = -1;
        break;
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
        
        double w_addition = (w == k) ? angle : 0;
        
        // if the angle indicates passing up, multiply addition to weight by 0.5
       if (angle > 180-straight_angle_leeway && angle < 180+straight_angle_leeway) w_addition *= 0.5;
          weight += w_addition;
      }
    }
    
    return weight;
}*/

+ (NSMutableArray *)findMatch:(ISData *)data dict:(NSArray *)dict {
  NSMutableArray *matches = [NSMutableArray array];
	
  for (ISWord *isword in dict) {
    double val = getValue(data, isword);
    isword.weight = val;
    if (val != -1) [matches addObject:isword];
  }

  return matches;
}

@end