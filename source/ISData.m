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
#import "ISAlgoAngleDiffGreedy.h"
//#import "ISAlgoHybrid.h"

#import "fmdb/FMDatabase.h"

@implementation ISData

- (instancetype)init {
  self = [super init];
  if (self) {
    self.keys = [NSMutableArray array];
    self.cur = nil;
  }
  return self;
}

- (void)addData:(CGPoint)p forKey:(NSString *)k {
    
  if (!k || k.length != 1) return;

  if (!_cur || [k characterAtIndex:0] != self.cur.letter) {
    [_cur compute];
    self.cur = [ISKey keyWithLetter:[k characterAtIndex:0]];
    [_keys addObject:_cur];
  }
    
  [_cur add:p];
}

- (void)end {
  [_cur compute];
}

- (NSArray *)findMatches {
  NSMutableArray *iswords = [NSMutableArray array];
    
  int first = [_keys.firstObject letter];
  int last = [_keys.lastObject letter];
    
  NSString *like = [NSString stringWithFormat:@"%c%%%c",first,last];
    
  // Intentional, iSwipe takes no performance hit from this.
  FMDatabase *db = [FMDatabase databaseWithPath:@"/usr/share/iSwipe/dictionaries.db"];
	
  // This is where the sqlite3 object is created
  if (![db open]) {
    [db close]; // Not 100% sure of this one
    return [NSMutableArray array];
  }

  FMResultSet *s = [db executeQuery:@"SELECT word,match FROM dict_en WHERE match LIKE ?",like];
  while ([s next]) {
    NSString *word = [s stringForColumn:@"word"];
    NSString *match = [s stringForColumn:@"match"];
    [iswords addObject:[ISWord word:word match:match weight:0]];
  }
	
  [s close];
  [db close];

  NSMutableArray *arr = [ISAlgoAngleDiffGreedy findMatch:self dict:iswords];
  [arr sortUsingSelector:@selector(compare:)];
	
  if (arr.count == 0) return arr;

  NSMutableArray *ret = [NSMutableArray array];
  double best = [arr.firstObject weight];
	
  for (ISWord *word in arr) {
    if (word.weight > best*0.5) [ret addObject:word];
  }
	
  return ret;
}

@end