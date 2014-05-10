//
//  ISData.m
//  iSwipe
//
//  Created by Andrew Liu on 6/4/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISData.h"

#import "ISWord.h"
#import "ISKey.h"
#import "ISAlgoHybrid.h"

#import "headers/UIKBTree.h"

#import "fmdb/FMDatabase.h"

@implementation ISData

- (instancetype)init {
  self = [super init];
  if (self) {
    _keys = [NSMutableArray array];
    _cur = nil;
  }
  return self;
}

- (void)addPoint:(CGPoint)p forKeyTree:(UIKBTree *)t {
  if (!t || t.displayString.length != 1) return;
  
  NSString *k = t.displayString.lowercaseString;
  
  if (!_cur || [k characterAtIndex:0] != _cur.letter) {
    [_cur compute];
		self.cur = [ISKey keyWithTree:t];
    [_keys addObject:_cur];
  }
    
  [_cur addPoint:p];
}

- (void)end {
  [_cur compute];
}

- (NSArray *)findMatches {  
  // Intentional, iSwipe takes no performance hit from this.
  FMDatabase *db = [FMDatabase databaseWithPath:@"/usr/share/iSwipe/dictionaries.db"];
	
  // This is where the sqlite3 object is created
  if (![db open]) {
    [db close]; // Not 100% sure of this one
    return [NSArray array];
  }
	
  NSMutableArray *iswords = [NSMutableArray array];
    
  char first = [_keys.firstObject letter];
  char last = [_keys.lastObject letter];
    
  NSString *like = [NSString stringWithFormat:@"%c%%%c",first,last];

  FMResultSet *s = [db executeQuery:@"SELECT word,match FROM dict_en WHERE match LIKE ?",like];
  while ([s next]) {
    NSString *word = [s stringForColumn:@"word"];
    NSString *match = [s stringForColumn:@"match"];
    [iswords addObject:[ISWord word:word match:match weight:0]];
  }
	
  [s close];
  [db close];
  
  /*NSMutableArray *intentional_keys = [NSMutableArray array];
  [intentional_keys addObject:_keys.firstObject];
  for (int i = 1; i < _keys.count-1; i++) {
    ISKey *key = _keys[i];
    if (key.intentional) [intentional_keys addObject:key];
  }
  [intentional_keys addObject:_keys.lastObject];*/

  NSArray *arr = [ISAlgoHybrid findMatch:_keys fromWords:iswords];
	
  if (arr.count == 0) return arr;

  NSMutableArray *ret = [NSMutableArray array];
  double best = [arr.firstObject weight];
	
  for (ISWord *word in arr) {
    if (word.weight > best*0.5) [ret addObject:word];
  }
	
  return [NSArray arrayWithArray:ret];
}

@end